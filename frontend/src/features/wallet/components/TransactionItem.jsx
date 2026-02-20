// ─── TransactionItem.jsx ──────────────────────────────────────────────────────
import {
  ArrowDownLeft,
  ArrowUpRight,
  Gift,
  Minus,
  CheckCircle2,
  Clock,
  AlertCircle,
} from "lucide-react";

const TX_META = {
  deposit: {
    label: "Deposit",
    icon: ArrowDownLeft,
    color: "text-green-400",
    bg: "bg-green-500/10",
    positive: true,
  },
  withdraw: {
    label: "Withdrawal",
    icon: ArrowUpRight,
    color: "text-rose-400",
    bg: "bg-rose-500/10",
    positive: false,
  },
  gift_sent: {
    label: "Gift Sent",
    icon: Gift,
    color: "text-purple-400",
    bg: "bg-purple-500/10",
    positive: false,
  },
  gift_received: {
    label: "Gift Received",
    icon: Gift,
    color: "text-indigo-400",
    bg: "bg-indigo-500/10",
    positive: true,
  },
  platform_fee: {
    label: "Platform Fee",
    icon: Minus,
    color: "text-amber-400",
    bg: "bg-amber-500/10",
    positive: false,
  },
};

const STATUS_META = {
  completed: {
    icon: CheckCircle2,
    color: "text-green-400",
    label: "Completed",
  },
  pending: { icon: Clock, color: "text-amber-400", label: "Pending" },
  failed: { icon: AlertCircle, color: "text-rose-400", label: "Failed" },
};

export default function TransactionItem({ transaction }) {
  const meta = TX_META[transaction.type] ?? TX_META.platform_fee;
  const status = STATUS_META[transaction.status] ?? STATUS_META.completed;
  const Icon = meta.icon;
  const StatusIcon = status.icon;

  return (
    <div
      className="group flex items-center gap-4 px-6 py-4
      hover:bg-indigo-500/5 transition-all duration-200 cursor-default">
      {/* Icon */}
      <div
        className={`flex-shrink-0 w-10 h-10 rounded-2xl ${meta.bg} flex items-center justify-center
        group-hover:scale-110 transition-transform duration-300`}>
        <Icon size={17} className={meta.color} />
      </div>

      {/* Label + time */}
      <div className="flex-1 min-w-0">
        <p className="text-sm font-semibold text-[var(--color-text-primary)] leading-tight">
          {meta.label}
        </p>
        <p className="text-xs text-[var(--color-text-secondary)] mt-0.5">
          {transaction.timestamp}
        </p>
      </div>

      {/* Amount + status */}
      <div className="flex flex-col items-end gap-1">
        <span
          className={`text-sm font-bold tabular-nums ${meta.positive ? "text-green-400" : "text-[var(--color-text-primary)]"}`}>
          {meta.positive ? "+" : "−"}
          {transaction.amount?.toLocaleString("en-US", {
            minimumFractionDigits: 2,
          })}{" "}
          USDCx
        </span>

        <div className={`flex items-center gap-1 ${status.color}`}>
          <StatusIcon
            size={11}
            className={transaction.status === "pending" ? "animate-pulse" : ""}
          />
          <span className="text-[10px] font-medium capitalize">
            {status.label}
          </span>
        </div>
      </div>
    </div>
  );
}
