/* eslint-disable no-unused-vars */
// ─── TransactionList.jsx ──────────────────────────────────────────────────────
import { Clock, Shield } from "lucide-react";
import TransactionItem from "./TransactionItem";
import { useWallet } from "@provablehq/aleo-wallet-adaptor-react";
import { useEffect, useState } from "react";

export default function TransactionList() {
  const { connected, connect, requestTransactionHistory } = useWallet();

  const [transactions, setTransactions] = useState([]);
  const [loading, setLoading] = useState(false);

  useEffect(() => {
    async function getHistory() {
      try {
        setLoading(true);

        if (!connected) {
          await connect();
        }

        const history = await requestTransactionHistory("credits.aleo");
        console.log("history:", history);

        console.log("Transactions:", history?.transactions);

        setTransactions(history?.transactions || []);
      } catch (err) {
        console.error("Failed to fetch history:", err);
      } finally {
        setLoading(false);
      }
    }

    getHistory();
  }, [connected]);

  // const pending = transactions.filter((t) => t.status === "pending");
  // const completed = transactions.filter((t) => t.status !== "pending");

  return (
    <div className="relative rounded-2xl bg-[var(--color-surface-2)] border border-[var(--color-border)] overflow-hidden hover:border-indigo-500/15 transition-all duration-300">
      {/* Top glow */}
      <div className="absolute top-0 left-0 right-0 h-px bg-gradient-to-r from-transparent via-indigo-500/30 to-transparent pointer-events-none" />

      {/* Header */}
      <div className="flex items-center justify-between px-6 py-5 border-b border-[var(--color-border)]">
        <div className="flex items-center gap-2.5">
          <div className="w-8 h-8 rounded-xl bg-gradient-to-br from-indigo-600 to-purple-600 flex items-center justify-center shadow-md shadow-indigo-500/30">
            <Clock size={14} className="text-white" />
          </div>
          <h3 className="text-sm font-bold text-[var(--color-text-primary)] tracking-tight">
            Transaction History
          </h3>
        </div>
        <div className="flex items-center gap-1.5">
          <Shield size={12} className="text-indigo-400" />
          <span className="text-[10px] text-[var(--color-text-secondary)]">
            ZK-verified
          </span>
        </div>
      </div>

      {/* Pending banner */}
      {/* {pending.length > 0 && (
        <div className="px-6 py-3 bg-amber-500/8 border-b border-amber-500/15 flex items-center gap-2">
          <div className="w-1.5 h-1.5 rounded-full bg-amber-400 animate-pulse" />
          <span className="text-xs text-amber-400 font-medium">
            {pending.length} transaction{pending.length > 1 ? "s" : ""}{" "}
            processing…
          </span>
        </div>
      )} */}

      {/* List */}
      <div className="divide-y divide-[var(--color-border)]">
        {transactions.length === 0 ? (
          <div className="flex flex-col items-center gap-3 py-16 px-6">
            <div className="w-12 h-12 rounded-2xl bg-gradient-to-br from-indigo-600/20 to-purple-600/20 border border-indigo-500/20 flex items-center justify-center">
              <Clock size={20} className="text-indigo-400/50" />
            </div>
            <p className="text-sm text-[var(--color-text-secondary)]">
              No transactions yet
            </p>
          </div>
        ) : (
          transactions.map((tx, i) => (
            <div
              key={tx.transactionId}
              className="tx-item"
              style={{ animationDelay: `${i * 50}ms` }}>
              <TransactionItem transaction={tx} />
            </div>
          ))
        )}
      </div>

      <style jsx>{`
        @keyframes fadeSlideIn {
          from {
            opacity: 0;
            transform: translateX(-8px);
          }
          to {
            opacity: 1;
            transform: translateX(0);
          }
        }
        .tx-item {
          animation: fadeSlideIn 0.35s ease-out both;
        }
      `}</style>
    </div>
  );
}
