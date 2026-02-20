export type TransactionType =
  | "deposit"
  | "withdraw"
  | "gift_sent"
  | "gift_received"
  | "platform_fee";

export interface Transaction {
  id: string;
  type: TransactionType;
  amount: number;
  timestamp: string;
  status: "pending" | "completed";
}
