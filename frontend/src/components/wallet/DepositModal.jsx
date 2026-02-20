import { useState } from "react"
import { useWalletStore } from "@/store/useWalletStore"
import { v4 as uuid } from "uuid"

// interface Props {
//   open: boolean
//   onClose: () => void
// }

export default function DepositModal({ open, onClose }) {
  const [amount, setAmount] = useState("")
  const { addTransaction } = useWalletStore()

  if (!open) return null

  const handleDeposit = () => {
    if (!amount || Number(amount) <= 0) return

    const id = uuid()

    addTransaction({
      id,
      type: "deposit",
      amount: Number(amount),
      status: "pending",
      createdAt: new Date().toISOString(),
    })

    // You will connect smart contract logic here

    onClose()
    setAmount("")
  }

  return (
    <div className="fixed inset-0 bg-black/40 flex items-center justify-center z-50">
      <div className="bg-white w-full max-w-md rounded-2xl p-6 space-y-4 shadow-xl">
        <h2 className="text-lg font-semibold">Deposit Funds</h2>

        <input
          type="number"
          value={amount}
          onChange={(e) => setAmount(e.target.value)}
          placeholder="Enter amount"
          className="w-full border rounded-lg px-4 py-2 focus:outline-none focus:ring-2 focus:ring-indigo-500"
        />

        <div className="flex justify-end gap-3">
          <button
            onClick={onClose}
            className="px-4 py-2 rounded-lg border"
          >
            Cancel
          </button>

          <button
            onClick={handleDeposit}
            className="px-4 py-2 rounded-lg bg-indigo-600 text-white"
          >
            Deposit
          </button>
        </div>
      </div>
    </div>
  )
}
