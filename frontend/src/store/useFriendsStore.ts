import { create } from "zustand";
import { FriendUser, FriendRequest } from "../features/friends/types";

interface FriendsState {
  friends: FriendUser[];
  incoming: FriendRequest[];
  outgoing: FriendRequest[];
  tab: "friends" | "incoming" | "outgoing";

  setTab: (tab: FriendsState["tab"]) => void;

  addFriend: (user: FriendUser) => void;
  removeFriend: (id: string) => void;

  sendRequest: (request: FriendRequest) => void;
  acceptRequest: (requestId: string) => void;
  rejectRequest: (requestId: string) => void;
}

export const useFriendsStore = create<FriendsState>((set) => ({
  friends: [],
  incoming: [],
  outgoing: [],
  tab: "friends",

  setTab: (tab) => set({ tab }),

  addFriend: (user) =>
    set((state) => ({
      friends: [...state.friends, user],
    })),

  removeFriend: (id) =>
    set((state) => ({
      friends: state.friends.filter((f) => f.id !== id),
    })),

  sendRequest: (request) =>
    set((state) => ({
      outgoing: [...state.outgoing, request],
    })),

  acceptRequest: (requestId) =>
    set((state) => {
      const request = state.incoming.find((r) => r.id === requestId);
      if (!request) return state;

      return {
        friends: [...state.friends, request.from],
        incoming: state.incoming.filter((r) => r.id !== requestId),
      };
    }),

  rejectRequest: (requestId) =>
    set((state) => ({
      incoming: state.incoming.filter((r) => r.id !== requestId),
    })),
}));
