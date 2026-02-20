import { ButtonHTMLAttributes } from "react";
import clsx from "clsx";

// interface Props extends ButtonHTMLAttributes<HTMLButtonElement> {
//   variant?: "primary" | "secondary" | "danger";
//   size?: "sm" | "md" | "lg";
// }

export default function Button({
  variant = "primary",
  size = "md",
  className,
  ...props
}) {
  const base =
    "inline-flex items-center justify-center font-medium transition-all duration-200 disabled:opacity-50 disabled:cursor-not-allowed";

  const variants = {
    primary:
      "bg-[var(--color-primary)] hover:bg-[var(--color-primary-hover)] text-white",
    secondary:
      "bg-[var(--color-muted)] hover:bg-[var(--color-border)] text-[var(--color-text-primary)]",
    danger:
      "bg-[var(--color-danger)] hover:opacity-90 text-white",
  };

  const sizes = {
    sm: "px-3 py-1.5 text-xs rounded-[var(--radius-sm)]",
    md: "px-4 py-2 text-sm rounded-[var(--radius-md)]",
    lg: "px-6 py-3 text-base rounded-[var(--radius-lg)]",
  };

  return (
    <button
      className={clsx(base, variants[variant], sizes[size], className)}
      {...props}
    />
  );
}
