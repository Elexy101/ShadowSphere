import { UserPlus } from "lucide-react";

// export interface FriendRequest {
//   id: string
//   name: string
//   username: string
//   avatar?: string
// }

// interface RequestListProps {
//   requests: FriendRequest[]
//   type?: "incoming" | "outgoing"
//   onAccept?: (id: string) => void
//   onDecline?: (id: string) => void
//   onCancel?: (id: string) => void
// }

export default function RequestList({
  requests,
  type = "incoming",
  onAccept,
  onDecline,
  onCancel,
}) {
  if (!requests.length) {
    return (
      <div className="bg-white rounded-2xl shadow-sm border p-8 text-center">
        <UserPlus className="mx-auto mb-4 text-gray-400" size={32} />
        <p className="text-gray-500">No {type} requests</p>
      </div>
    );
  }

  return (
    <div className="bg-white rounded-2xl shadow-sm border divide-y">
      {requests.map((req) => (
        <div
          key={req.id}
          className="flex items-center justify-between p-4 hover:bg-gray-50 transition">
          <div className="flex items-center gap-4">
            <img
              src={req.avatar || `https://i.pravatar.cc/150?u=${req.id}`}
              alt={req.name}
              className="w-12 h-12 rounded-full object-cover"
            />

            <div>
              <p className="font-semibold text-gray-900">{req.name}</p>
              <p className="text-sm text-gray-500">@{req.username}</p>
            </div>
          </div>

          {type === "incoming" ? (
            <div className="flex gap-2">
              <button
                onClick={() => onAccept?.(req.id)}
                className="px-3 py-1.5 text-sm rounded-lg bg-green-600 text-white hover:bg-green-700 transition">
                Accept
              </button>
              <button
                onClick={() => onDecline?.(req.id)}
                className="px-3 py-1.5 text-sm rounded-lg bg-gray-100 hover:bg-gray-200 transition">
                Decline
              </button>
            </div>
          ) : (
            <button
              onClick={() => onCancel?.(req.id)}
              className="px-3 py-1.5 text-sm rounded-lg bg-red-100 text-red-600 hover:bg-red-200 transition">
              Cancel
            </button>
          )}
        </div>
      ))}
    </div>
  );
}
