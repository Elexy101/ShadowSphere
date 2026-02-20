export interface User {
  id: string;
  alias: string;
}

export interface Message {
  id: string;
  senderId: string;
  receiverId: string;
  content: string;
  timestamp: string;
  status: "sent" | "delivered" | "read";
}

export interface Conversation {
  id: string;
  participants: User[];
  messages: Message[];
  lastMessage: Message;
}
