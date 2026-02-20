// src/hooks/useAleoBalance.js
import { useEffect } from "react";
import { useWallet } from "@provablehq/aleo-wallet-adaptor-react";
import useWalletStore from "../store/useWalletStore";

export const useAleoBalance = () => {
  const { address, connected } = useWallet();
  const { balance, isLoading, fetchBalance } = useWalletStore();

  useEffect(() => {
    if (connected && address) {
      fetchBalance(address, connected);

      // Background refresh every 60 seconds
      const interval = setInterval(
        () => fetchBalance(address, connected),
        60000,
      );
      return () => clearInterval(interval);
    }
  }, [address, connected, fetchBalance]);

  return {
    balance,
    isLoading,
    refresh: () => fetchBalance(address, connected),
  };
};
