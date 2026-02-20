export interface FriendUser {
  id: string;
  alias: string;
  avatar?: string;
}

export interface FriendRequest {
  id: string;
  from: FriendUser;
  to: FriendUser;
  status: "pending" | "accepted" | "rejected";
}
