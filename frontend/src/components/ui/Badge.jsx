import { ReactNode } from "react";
import clsx from "clsx";

// interface Props {
//   children: ReactNode;
//   variant?: "default" | "success" | "verified";
// }

export default function Badge({
  children,
  variant = "default",
}) {
  const variants = {
    default:
      "bg-[var(--color-muted)] text-[var(--color-text-secondary)]",
    success:
      "bg-[var(--color-success)]/20 text-[var(--color-success)]",
    verified:
      "bg-[var(--color-primary)]/20 text-[var(--color-primary)]",
  };

  return (
    <span
      className={clsx(
        "px-2 py-1 text-xs font-medium rounded-full",
        variants[variant]
      )}
    >
      {children}
    </span>
  );
}
