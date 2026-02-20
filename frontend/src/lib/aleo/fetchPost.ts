/**
 * Fetch a post by its transaction ID from Aleo testnet
 */
export async function fetchPost(txId:string) {
  try {
    const programId = "shadowsphere_social9.aleo";
    const url = `https://cors-anywhere.herokuapp.com/https://testnet.aleoscan.io/testnet/program/${programId}/mapping/posts/${txId}u32`;

    const res = await fetch(url);
    if (!res.ok) throw new Error(`Failed to fetch: ${res.status}`);

    const data = await res.json();

    console.log("📄 Fetched post data:", data);

    return data;
  } catch (err) {
    console.error("❌ Fetch post error:", err);
    return null;
  }
}
