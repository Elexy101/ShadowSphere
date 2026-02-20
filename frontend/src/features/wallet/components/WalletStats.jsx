/* eslint-disable no-unused-vars */
// ─── WalletStats.jsx ──────────────────────────────────────────────────────────
import { ArrowUpRight, ArrowDownLeft, Zap } from "lucide-react";

const STATS = (sent, received, fees) => [
  {
    label: "Total Sent",
    value: sent,
    icon: ArrowUpRight,
    color: "text-rose-400",
    glow: "shadow-rose-500/20",
    bg: "from-rose-500/10 to-rose-600/5",
    border: "border-rose-500/15 hover:border-rose-500/30",
  },
  {
    label: "Total Received",
    value: received,
    icon: ArrowDownLeft,
    color: "text-green-400",
    glow: "shadow-green-500/20",
    bg: "from-green-500/10 to-emerald-600/5",
    border: "border-green-500/15 hover:border-green-500/30",
  },
  {
    label: "Platform Fees",
    value: fees,
    icon: Zap,
    color: "text-amber-400",
    glow: "shadow-amber-500/15",
    bg: "from-amber-500/10 to-yellow-600/5",
    border: "border-amber-500/15 hover:border-amber-500/30",
  },
];

export default function WalletStats({ sent, received, fees }) {
  const stats = STATS(sent, received, fees);

  return (
    <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
      {stats.map(({ label, value, icon: Icon, color, glow, bg, border }, i) => (
        <div
          key={label}
          className={`relative group p-5 rounded-2xl bg-gradient-to-br ${bg} border ${border}
            shadow-lg ${glow} hover:scale-[1.02] active:scale-[0.98]
            transition-all duration-300 overflow-hidden stat-card`}
          style={{ animationDelay: `${i * 60}ms` }}
        >
          {/* Top glow line */}
          <div className="absolute top-0 left-0 right-0 h-px bg-gradient-to-r from-transparent via-current to-transparent opacity-20 pointer-events-none" />

          <div className="flex items-start justify-between">
            <div>
              <p className="text-[10px] font-semibold text-[var(--color-text-secondary)] uppercase tracking-widest mb-2">
                {label}
              </p>
              <h3 className="text-2xl font-bold text-[var(--color-text-primary)] tracking-tight">
                {value.toLocaleString("en-US", { minimumFractionDigits: 2 })}
              </h3>
              <p className="text-xs text-[var(--color-text-secondary)] mt-0.5">USDCx</p>
            </div>
            <div className={`p-2.5 rounded-xl bg-current/10 ${color} group-hover:scale-110 transition-transform duration-300`}>
              <Icon size={16} className={color} />
            </div>
          </div>

          <style jsx>{`
            @keyframes fadeSlideUp {
              from { opacity: 0; transform: translateY(12px); }
              to   { opacity: 1; transform: translateY(0); }
            }
            .stat-card { animation: fadeSlideUp 0.4s ease-out both; }
          `}</style>
        </div>
      ))}
    </div>
  );
}
