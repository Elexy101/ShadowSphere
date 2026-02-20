import { create } from "zustand";

interface WalletAuthState {
  address: string | null;
  isConnected: boolean;

  connect: (address: string) => void;
  disconnect: () => void;
}

export const useWalletAuthStore = create<WalletAuthState>((set) => ({
  address: null,
  isConnected: false,

  connect: (address) =>
    set({
      address,
      isConnected: true,
    }),

  disconnect: () =>
    set({
      address: null,
      isConnected: false,
    }),
}));
