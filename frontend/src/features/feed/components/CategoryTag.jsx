// interface Props {
//   category: string;
// }

export default function CategoryTag({ category }) {
  return (
    <span
      className="text-xs px-3 py-1 rounded-full 
                 bg-[var(--color-muted)] 
                 text-[var(--color-text-secondary)]"
    >
      {category}
    </span>
  );
}
