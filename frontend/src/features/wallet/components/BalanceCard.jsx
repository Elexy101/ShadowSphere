/* eslint-disable no-unused-vars */
import {
  ArrowDownLeft,
  ArrowUpRight,
  Eye,
  EyeOff,
  Wallet,
  Loader2,
  History,
} from "lucide-react";
import { useState, useEffect } from "react";
import DepositModal from "./DepositModal";
import WithdrawModal from "./WithdrawModal";
import { useWallet } from "@provablehq/aleo-wallet-adaptor-react";
import { useAleoBalance } from "../../../hooks/useUsdxBalance";

export default function BalanceCard({ balance, isLoading }) {
  const [hidden, setHidden] = useState(false);
  const { refresh } = useAleoBalance();
  const [showDeposit, setShowDeposit] = useState(false);
  const [showWithdraw, setShowWithdraw] = useState(false);
  const [history, setHistory] = useState([]);
  const { requestTransactionHistory, address, connected } = useWallet();

  // ─── TRANSACTION HISTORY FETCH ────────────────────────────────
  useEffect(() => {
    const fetchHistory = async () => {
      if (connected && address && requestTransactionHistory) {
        try {
          const data = await requestTransactionHistory(address);
          // Filter out duplicates if necessary and store
          setHistory(Array.isArray(data) ? data : []);
        } catch (error) {
          console.error("Failed to fetch history:", error);
        }
      }
    };

    fetchHistory();
  }, [address, connected, requestTransactionHistory]);

  return (
    <>
      <div className="relative overflow-hidden rounded-3xl p-6 md:p-8 bg-gradient-to-br from-indigo-600/20 via-purple-600/15 to-[var(--color-surface)] border border-indigo-500/20 shadow-xl shadow-indigo-500/10 hover:shadow-indigo-500/20 transition-all duration-500">
        {/* Background Visuals */}
        <div className="absolute -top-10 -right-10 w-48 h-48 bg-indigo-500/15 rounded-full blur-3xl pointer-events-none" />
        <div className="absolute -bottom-8 -left-8 w-40 h-40 bg-purple-500/15 rounded-full blur-3xl pointer-events-none" />
        <div className="absolute top-0 left-0 right-0 h-px bg-gradient-to-r from-transparent via-indigo-400/50 to-transparent pointer-events-none" />

        <div className="relative z-10 flex flex-col md:flex-row md:items-center md:justify-between gap-6">
          {/* Balance Section */}
          <div className="space-y-1">
            <div className="flex items-center gap-2">
              <div className="w-8 h-8 rounded-xl bg-gradient-to-br from-indigo-600 to-purple-600 flex items-center justify-center shadow-md shadow-indigo-500/30">
                <Wallet size={15} className="text-white" />
              </div>
              <p className="text-xs font-semibold text-[var(--color-text-secondary)] uppercase tracking-widest">
                Available Balance
              </p>
              <button
                onClick={() => setHidden(!hidden)}
                className="ml-1 p-1 rounded-lg text-[var(--color-text-secondary)] hover:text-indigo-400 hover:bg-indigo-500/10 active:scale-90 transition-all duration-200">
                {hidden ? <EyeOff size={13} /> : <Eye size={13} />}
              </button>
            </div>

            <div className="flex items-end gap-3 min-h-[44px]">
              {isLoading ? (
                <div className="flex items-center gap-2 animate-pulse">
                  <div className="h-9 w-32 bg-indigo-500/20 rounded-lg" />
                  <Loader2
                    size={16}
                    className="animate-spin text-indigo-400 mb-1"
                  />
                </div>
              ) : (
                <>
                  <h2 className="text-4xl font-bold tracking-tight text-[var(--color-text-primary)]">
                    {hidden ? (
                      <span className="text-3xl tracking-[0.25em] text-[var(--color-text-secondary)]">
                        ••••••
                      </span>
                    ) : (
                      (balance || 0).toLocaleString("en-US", {
                        minimumFractionDigits: 2,
                      })
                    )}
                  </h2>
                  {!hidden && (
                    <span className="mb-1 text-sm font-semibold text-indigo-400">
                      USDCx
                    </span>
                  )}
                </>
              )}
            </div>

            {/* Sync Info / History Badge */}
            <div className="flex items-center gap-3 mt-1">
              <div className="flex items-center gap-1.5">
                <span className="text-xs text-green-400 font-medium">
                  +2.4%
                </span>
                <span className="text-xs text-[var(--color-text-secondary)]">
                  past 24h
                </span>
              </div>
              {history.length > 0 && (
                <div className="flex items-center gap-1 px-2 py-0.5 rounded-full bg-indigo-500/10 border border-indigo-500/20">
                  <History size={10} className="text-indigo-400" />
                  <span className="text-[10px] text-indigo-300 font-medium">
                    {history.length} txs
                  </span>
                </div>
              )}
            </div>
          </div>

          {/* Action Buttons */}
          <div className="flex gap-3">
            <button
              onClick={() => setShowDeposit(true)}
              className="group flex items-center gap-2 px-5 py-3 rounded-2xl font-semibold text-sm
                bg-[var(--color-surface-2)] border border-[var(--color-border)]
                text-[var(--color-text-primary)]
                hover:border-green-500/30 hover:bg-green-500/10 hover:text-green-300
                active:scale-95 transition-all duration-300">
              <ArrowDownLeft
                size={16}
                className="text-green-400 group-hover:scale-110 transition-transform duration-300"
              />
              Deposit
            </button>

            <button
              onClick={() => setShowWithdraw(true)}
              className="group flex items-center gap-2 px-5 py-3 rounded-2xl font-semibold text-sm text-white
                bg-gradient-to-r from-indigo-600 to-purple-600
                hover:from-indigo-500 hover:to-purple-500
                shadow-lg shadow-indigo-500/30 hover:shadow-indigo-500/50
                active:scale-95 hover:scale-[1.02] transition-all duration-300 overflow-hidden relative">
              <span className="absolute inset-0 bg-gradient-to-r from-white/0 via-white/10 to-white/0 translate-x-[-100%] group-hover:translate-x-[100%] transition-transform duration-700 pointer-events-none" />
              <ArrowUpRight
                size={16}
                className="relative z-10 group-hover:scale-110 transition-transform duration-300"
              />
              <span className="relative z-10">Withdraw</span>
            </button>
          </div>
        </div>
      </div>

      {/* Modals */}
      <DepositModal
        open={showDeposit}
        onClose={() => setShowDeposit(false)}
        balance={balance}
      />
      <WithdrawModal
        open={showWithdraw}
        onClose={() => setShowWithdraw(false)}
        balance={balance}
      />
    </>
  );
}
