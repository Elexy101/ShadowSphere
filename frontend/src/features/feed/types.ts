export interface Post {
  id: string;
  alias: string;
  reputation: number;
  verified: boolean;
  category: string;
  content: string;
  encrypted?: boolean;
  likes: number;
  comments: number;
  timestamp: string;
}
