import { create } from "zustand";
import { ProfileUser } from "../features/profile/types";

interface AuthState {
  user: ProfileUser | null;
  setUser: (user: ProfileUser) => void;
  updateProfile: (data: Partial<ProfileUser>) => void;
}

export const useAuthStore = create<AuthState>((set) => ({
  user: {
    id: "me",
    alias: "Francis",
    bio: "Web3 Builder 🚀",
  },

  setUser: (user) => set({ user }),

  updateProfile: (data) =>
    set((state) => ({
      user: state.user ? { ...state.user, ...data } : null,
    })),
}));
