import { ReactNode } from "react";
import clsx from "clsx";

export default function Card({ children, className }) {
  return (
    <div
      className={clsx(
        "bg-[var(--color-surface)]",
        "border border-[var(--color-border)]",
        "rounded-[var(--radius-lg)]",
        "p-5",
        "transition-shadow duration-200",
        "hover:shadow-lg",
        className
      )}
    >
      {children}
    </div>
  );
}
