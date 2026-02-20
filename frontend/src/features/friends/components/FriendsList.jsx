import { Users } from "lucide-react"

// export interface Friend {
//   id: string
//   name: string
//   username: string
//   avatar?: string
//   isOnline?: boolean
// }

// interface FriendListProps {
//   friends: Friend[]
//   onMessage?: (id: string) => void
//   onRemove?: (id: string) => void
// }

export default function FriendList({
  friends,
  onMessage,
  onRemove,
}) {
  if (!friends.length) {
    return (
      <div className="bg-white rounded-2xl shadow-sm border p-8 text-center">
        <Users className="mx-auto mb-4 text-gray-400" size={32} />
        <p className="text-gray-500">No friends yet</p>
      </div>
    )
  }

  return (
    <div className="bg-white rounded-2xl shadow-sm border divide-y">
      {friends.map((friend) => (
        <div
          key={friend.id}
          className="flex items-center justify-between p-4 hover:bg-gray-50 transition"
        >
          <div className="flex items-center gap-4">
            <div className="relative">
              <img
                src={friend.avatar || `https://i.pravatar.cc/150?u=${friend.id}`}
                alt={friend.name}
                className="w-12 h-12 rounded-full object-cover"
              />
              {friend.isOnline && (
                <span className="absolute bottom-0 right-0 w-3 h-3 bg-green-500 border-2 border-white rounded-full" />
              )}
            </div>

            <div>
              <p className="font-semibold text-white">{friend.name}</p>
              <p className="text-sm text-white">@{friend.username}</p>
            </div>
          </div>

          <div className="flex items-center gap-2">
            <button
              onClick={() => onMessage?.(friend.id)}
              className="px-3 py-1.5 text-sm rounded-lg bg-indigo-600 text-white hover:bg-indigo-700 transition"
            >
              Message
            </button>

            <button
              onClick={() => onRemove?.(friend.id)}
              className="px-3 py-1.5 text-sm rounded-lg bg-gray-100 hover:bg-gray-200 transition"
            >
              Remove
            </button>
          </div>
        </div>
      ))}
    </div>
  )
}
