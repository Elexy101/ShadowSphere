import { X } from "lucide-react";
import Card from "../../../components/ui/Card";

// interface Props {
//   open: boolean;
//   onClose: () => void;
// }

export default function CommentDrawer({ open, onClose }) {
  if (!open) return null;

  return (
    <div className="fixed inset-0 bg-black/40 flex justify-center items-end z-50">
      <div className="w-full max-w-2xl mb-6">
        <Card className="relative">
          <button
            onClick={onClose}
            className="absolute top-4 right-4"
          >
            <X size={18} />
          </button>

          <h3 className="text-lg font-semibold mb-4">
            Comments
          </h3>

          <div className="space-y-3 max-h-64 overflow-y-auto">
            <div className="text-sm">Anonymous: Interesting point.</div>
            <div className="text-sm">ShadowUser: Agreed.</div>
          </div>
        </Card>
      </div>
    </div>
  );
}
