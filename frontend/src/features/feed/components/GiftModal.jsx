import { useState, useMemo, useEffect } from "react";
import { createPortal } from "react-dom";
import { X } from "lucide-react";
import Card from "../../../components/ui/Card";
import Button from "../../../components/ui/Button";

export default function GiftModal({ open, onClose, recipientAlias }) {
  const [amount, setAmount] = useState(0);
  const [message, setMessage] = useState("");

  const platformFee = useMemo(() => amount * 0.02, [amount]);
  const recipientReceives = useMemo(
    () => amount - platformFee,
    [amount, platformFee],
  );

  // Prevent background scroll when modal is open
  useEffect(() => {
    if (open) {
      document.body.style.overflow = "hidden";
    }
    return () => {
      document.body.style.overflow = "auto";
    };
  }, [open]);

  if (!open) return null;

  return createPortal(
    <div className="fixed inset-0 z-[2147483647]">
      {/* Overlay */}
      <div
        onClick={onClose}
        className="absolute inset-0 bg-black/60 backdrop-blur-md"
      />

      {/* Centered Modal Wrapper */}
      <div className="absolute inset-0 flex items-center justify-center p-4">
        <Card className="w-full max-w-md relative z-[2147483648]">
          {/* Close */}
          <button
            onClick={onClose}
            className="absolute top-4 right-4 text-[var(--color-text-secondary)] hover:text-white transition">
            <X size={18} />
          </button>

          <div className="flex flex-col gap-5">
            <div>
              <h2 className="text-lg font-semibold">Send Gift</h2>
              <p className="text-xs text-[var(--color-text-secondary)] mt-1">
                Recipient: @{recipientAlias}
              </p>
            </div>

            {/* Amount Input */}
            <div className="flex flex-col gap-2">
              <label className="text-xs text-[var(--color-text-secondary)]">
                Amount (USDCx)
              </label>

              <input
                type="number"
                min={0}
                value={amount}
                onChange={(e) => setAmount(Number(e.target.value))}
                placeholder="0.00"
                className="bg-[var(--color-surface-2)] 
                           border border-[var(--color-border)] 
                           rounded-[var(--radius-md)] 
                           p-3 text-sm 
                           focus:outline-none 
                           focus:border-[var(--color-primary)]"
              />
            </div>

            {/* Optional Message */}
            <div className="flex flex-col gap-2">
              <label className="text-xs text-[var(--color-text-secondary)]">
                Optional Message
              </label>

              <textarea
                rows={3}
                value={message}
                onChange={(e) => setMessage(e.target.value)}
                placeholder="Add a private message..."
                className="bg-[var(--color-surface-2)] 
                           border border-[var(--color-border)] 
                           rounded-[var(--radius-md)] 
                           p-3 text-sm resize-none
                           focus:outline-none 
                           focus:border-[var(--color-primary)]"
              />
            </div>

            {/* Fee Breakdown */}
            <div
              className="bg-[var(--color-muted)]/40 
                         p-4 rounded-[var(--radius-md)] 
                         text-sm space-y-1">
              <div className="flex justify-between">
                <span className="text-[var(--color-text-secondary)]">
                  Platform Fee (2%)
                </span>
                <span>{platformFee.toFixed(2)} USDCx</span>
              </div>

              <div className="flex justify-between font-medium">
                <span>Recipient Receives</span>
                <span>{recipientReceives.toFixed(2)} USDCx</span>
              </div>
            </div>

            {/* Confirm */}
            <Button disabled={amount <= 0} className="w-full">
              Confirm Gift
            </Button>
          </div>
        </Card>
      </div>
    </div>,
    document.body,
  );
}
