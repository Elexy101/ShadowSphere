import { useState } from "react"
import { useWalletStore } from "@/store/useWalletStore"
import { v4 as uuid } from "uuid"

// interface Props {
//   open: boolean
//   onClose: () => void
// }

export default function WithdrawModal({ open, onClose }) {
  const [amount, setAmount] = useState("")
  const { balance, addTransaction } = useWalletStore()

  if (!open) return null

  const handleWithdraw = () => {
    const numericAmount = Number(amount)

    if (!numericAmount || numericAmount <= 0) return
    if (numericAmount > balance) {
      alert("Insufficient balance")
      return
    }

    addTransaction({
      id: uuid(),
      type: "withdraw",
      amount: numericAmount,
      status: "pending",
      createdAt: new Date().toISOString(),
    })

    onClose()
    setAmount("")
  }

  return (
    <div className="fixed inset-0 bg-black/40 flex items-center justify-center z-50">
      <div className="bg-white w-full max-w-md rounded-2xl p-6 space-y-4 shadow-xl">
        <h2 className="text-lg font-semibold">Withdraw Funds</h2>

        <input
          type="number"
          value={amount}
          onChange={(e) => setAmount(e.target.value)}
          placeholder="Enter amount"
          className="w-full border rounded-lg px-4 py-2 focus:ring-2 focus:ring-indigo-500"
        />

        <p className="text-sm text-gray-500">
          Available Balance: ₦{balance}
        </p>

        <div className="flex justify-end gap-3">
          <button onClick={onClose} className="px-4 py-2 border rounded-lg">
            Cancel
          </button>

          <button
            onClick={handleWithdraw}
            className="px-4 py-2 rounded-lg bg-red-600 text-white"
          >
            Withdraw
          </button>
        </div>
      </div>
    </div>
  )
}
