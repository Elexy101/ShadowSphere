export default function FeedSkeleton() {
  return (
    <div className="flex flex-col gap-6 animate-pulse">
      {[1, 2, 3].map((i) => (
        <div
          key={i}
          className="bg-[var(--color-surface)] border border-[var(--color-border)] rounded-[var(--radius-lg)] p-5 space-y-4">
          <div className="h-4 w-32 bg-[var(--color-muted)] rounded"></div>
          <div className="h-3 w-full bg-[var(--color-muted)] rounded"></div>
          <div className="h-3 w-5/6 bg-[var(--color-muted)] rounded"></div>
        </div>
      ))}
    </div>
  );
}
