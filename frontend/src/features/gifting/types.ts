export interface Gift {
  id: string;
  name: string;
  emoji: string;
  price: number;
  category: "popular" | "romantic" | "premium";
}
