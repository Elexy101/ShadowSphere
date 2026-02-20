// src/store/useWalletStore.ts
import { create } from "zustand";
import { DECIMAL_MULTIPLIER } from "../config/config";

// 1. Define the shape of your store
interface WalletState {
  balance: number;
  isLoading: boolean;
  lastUpdated: number | null;
  fetchBalance: (address: string | null, connected: boolean) => Promise<void>;
}

// 2. Pass the interface to create<WalletState>()
const useWalletStore = create<WalletState>()((set) => ({
  balance: 0,
  isLoading: false,
  lastUpdated: null,

  fetchBalance: async (address, connected) => {
    if (!connected || !address) return;

    set({ isLoading: true });
    try {
      const rpcUrl =
        "https://testnet.aleoscan.io/testnet/program/test_usdcx_stablecoin.aleo/mapping/balances";

      const response = await fetch(`${rpcUrl}/${address}`);

      if (response.status === 404) {
        set({ balance: 0, isLoading: false, lastUpdated: Date.now() });
        return;
      }

      const rawData = await response.json();
      const cleanBalance =
        parseFloat(String(rawData).replace("u64", "")) / DECIMAL_MULTIPLIER;

      set({ balance: cleanBalance, lastUpdated: Date.now(), isLoading: false });
    } catch (error) {
      console.error("Wallet Store Error:", error);
      set({ balance: 0, isLoading: false });
    }
  },
}));

export default useWalletStore;
