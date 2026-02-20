import { create } from "zustand";
import { Conversation, Message } from "../features/messages/type";

interface MessageState {
  conversations: Conversation[];
  activeConversationId: string | null;

  setActiveConversation: (id: string) => void;
  addMessage: (convId: string, message: Message) => void;
  addConversation: (conversation: Conversation) => void;
}

export const useMessageStore = create<MessageState>((set) => ({
  conversations: [],
  activeConversationId: null,

  setActiveConversation: (id) => set({ activeConversationId: id }),

  addMessage: (convId, message) =>
    set((state) => ({
      conversations: state.conversations.map((conv) =>
        conv.id === convId
          ? {
              ...conv,
              messages: [...conv.messages, message],
              lastMessage: message,
            }
          : conv,
      ),
    })),

  addConversation: (conversation) =>
    set((state) => ({
      conversations: [conversation, ...state.conversations],
    })),
}));
