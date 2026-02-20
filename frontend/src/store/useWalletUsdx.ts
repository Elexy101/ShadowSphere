// src/store/useWalletStore.js
import { create } from "zustand";
import { DECIMAL_MULTIPLIER } from "../config/config"; // From our previous config

const useWalletUsdx = create((set, get) => ({
  balance: 0,
  isLoading: false,
  lastUpdated: null,

  fetchBalance: async (address: any, connected: any) => {
    if (!connected || !address) return;

    set({ isLoading: true });
    try {
      // Using the mapping endpoint for the stablecoin
      const rpcUrl =
        "https://testnet.aleoscan.io/testnet/program/test_usdcx_stablecoin.aleo/mapping/balances";

      const response = await fetch(`${rpcUrl}/${address}`, {
        method: "GET",
        headers: { "Content-Type": "application/json" },
      });

      if (response.status === 404) {
        set({ balance: 0, isLoading: false, lastUpdated: Date.now() });
        return;
      }

      const rawData = await response.json();
      // Clean "1000000u64" -> 1.0
      const cleanBalance =
        parseFloat(String(rawData).replace("u64", "")) / DECIMAL_MULTIPLIER;

      set({ balance: cleanBalance, lastUpdated: Date.now() });
    } catch (error) {
      console.error("Wallet Store Error:", error);
      set({ balance: 0 });
    } finally {
      set({ isLoading: false });
    }
  },
}));

export default useWalletUsdx;
