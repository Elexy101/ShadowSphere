// ─── WalletPage.jsx ───────────────────────────────────────────────────────────
import BalanceCard from "./components/BalanceCard";
import WalletStats from "./components/WalletStats";
import TransactionList from "./components/TransactionList";
import { useWallet } from "@provablehq/aleo-wallet-adaptor-react";
import { Shield, Unplug } from "lucide-react";
// import { useEffect } from "react";
import {useAleoBalance} from "../../hooks/useUsdxBalance"

export default function WalletPage() {
  const { address, connected } = useWallet();
  // const [balance, setBalance] = useState(0);
  // const [loading, setLoading] = useState(false);
  const { balance, isLoading, refresh } = useAleoBalance();
  // console.log(wallet);

  // useEffect(() => {
  //   const fetchBalance = async () => {
  //     if (!connected || !address) return;

  //     setLoading(true);
  //     try {
  //       // 1. Use the direct RPC proxy or a more stable endpoint
  //       // We use a POST request to the RPC which often bypasses the GET CORS restrictions
  //       const rpcUrl =
  //         "https://testnet.aleoscan.io/testnet/program/test_usdcx_stablecoin.aleo/mapping/balances";

  //       const response = await fetch(`${rpcUrl}/${address}`, {
  //         method: "GET",
  //         headers: {
  //           "Content-Type": "application/json",
  //         },
  //       });

  //       if (response.status === 404) {
  //         // 404 in Aleo mappings means 0 credits (the account isn't on-chain yet)
  //         setBalance(0);
  //         return;
  //       }

  //       if (!response.ok) throw new Error("Network response was not ok");

  //       const rawData = await response.json();
  //       // Data usually returns like "100.234u64" or just "100234u64"
  //       const cleanBalance =
  //         parseFloat(String(rawData).replace("u64", "")) / 1_000_000;
  //       setBalance(cleanBalance);
  //     } catch (error) {
  //       console.error("CORS or Network Error:", error);
  //       // Fallback to 0 if the account doesn't exist
  //       setBalance(0);
  //     } finally {
  //       setLoading(false);
  //     }
  //   };

  //   fetchBalance();
  //   // Refresh every 30 seconds
  //   const interval = setInterval(fetchBalance, 30000);
  //   return () => clearInterval(interval);
  // }, [address, connected]);

  return (
    <div className="relative flex flex-col gap-6 wallet-root">
      {/* Ambient glows */}
      <div className="absolute -top-16 -left-16 w-72 h-72 bg-indigo-500/8 rounded-full blur-3xl pointer-events-none" />
      <div className="absolute top-32 right-0 w-64 h-64 bg-purple-500/8 rounded-full blur-3xl pointer-events-none" />

      {/* ── Balance ─────────────────────────────────── */}
      <BalanceCard balance={balance} isLoading={isLoading} onRefresh ={refresh} />

      {/* ── Stats ───────────────────────────────────── */}
      {/* <WalletStats sent={150} received={275} fees={8} /> */}

      {/* ── Transactions ────────────────────────────── */}
      {/* <TransactionList/> */}

      {/* ── Connected wallet info ───────────────────── */}
      {connected && (
        <div className="relative p-5 rounded-2xl bg-[var(--color-surface-2)] border border-[var(--color-border)] hover:border-indigo-500/20 transition-all duration-300 space-y-4 wallet-address-card">
          {/* Top glow line */}
          <div className="absolute top-0 left-0 right-0 h-px bg-gradient-to-r from-transparent via-indigo-500/30 to-transparent pointer-events-none rounded-t-2xl" />

          <div className="flex items-center justify-between">
            <div className="flex items-center gap-2">
              <Shield size={14} className="text-indigo-400" />
              <span className="text-xs font-semibold text-[var(--color-text-secondary)] uppercase tracking-widest">
                Connected Address
              </span>
            </div>
            <div className="flex items-center gap-1.5">
              <div className="w-1.5 h-1.5 rounded-full bg-green-400 animate-pulse" />
              <span className="text-[10px] text-green-400 font-medium">
                Live
              </span>
            </div>
          </div>

          <p className="font-mono text-xs text-[var(--color-text-primary)] break-all bg-black/20 px-3 py-2.5 rounded-xl border border-[var(--color-border)]">
            {address?.toString()}
          </p>
          {/* 
          <button
            onClick={() => (connected ? disconnect() : connect())}
            className="group flex items-center gap-2 px-4 py-2.5 rounded-xl text-sm font-semibold
              border border-rose-500/20 bg-rose-500/10 text-rose-400
              hover:bg-rose-500/20 hover:border-rose-500/40
              active:scale-95 transition-all duration-300">
            <Unplug
              size={14}
              className="group-hover:rotate-12 transition-transform duration-300"
            />
            Disconnect Wallet
          </button> */}
        </div>
      )}

      <style jsx>{`
        @keyframes fadeSlideUp {
          from {
            opacity: 0;
            transform: translateY(16px);
          }
          to {
            opacity: 1;
            transform: translateY(0);
          }
        }
        .wallet-root > * {
          animation: fadeSlideUp 0.45s ease-out both;
        }
        .wallet-root > *:nth-child(1) {
          animation-delay: 0.05s;
        }
        .wallet-root > *:nth-child(2) {
          animation-delay: 0.1s;
        }
        .wallet-root > *:nth-child(3) {
          animation-delay: 0.15s;
        }
        .wallet-root > *:nth-child(4) {
          animation-delay: 0.2s;
        }
        .wallet-address-card {
          animation-delay: 0.25s;
        }
      `}</style>
    </div>
  );
}
