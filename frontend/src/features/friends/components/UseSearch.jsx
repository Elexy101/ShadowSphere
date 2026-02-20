import { Search } from "lucide-react"

// export interface SearchUser {
//   id: string
//   name: string
//   username: string
//   avatar?: string
// }

// interface UserSearchProps {
//   value: string
//   onChange: (value: string) => void
//   results: SearchUser[]
//   onAddFriend?: (id: string) => void
// }

export default function UserSearch({
  value,
  onChange,
  results,
  onAddFriend,
}) {
  return (
    <div className="space-y-4">
      {/* Search Input */}
      <div className="relative">
        <Search
          className="absolute left-3 top-1/2 -translate-y-1/2 text-gray-400"
          size={18}
        />
        <input
          type="text"
          placeholder="Search users..."
          value={value}
          onChange={(e) => onChange(e.target.value)}
          className="w-full pl-10 pr-4 py-2 rounded-xl border bg-white focus:outline-none focus:ring-2 focus:ring-indigo-500"
        />
      </div>

      {/* Results */}
      <div className="bg-white rounded-2xl shadow-sm border divide-y">
        {results.length === 0 && value && (
          <div className="p-4 text-center text-gray-500">
            No users found
          </div>
        )}

        {results.map((user) => (
          <div
            key={user.id}
            className="flex items-center justify-between p-4 hover:bg-gray-50 transition"
          >
            <div className="flex items-center gap-4">
              <img
                src={user.avatar || `https://i.pravatar.cc/150?u=${user.id}`}
                alt={user.name}
                className="w-10 h-10 rounded-full object-cover"
              />

              <div>
                <p className="font-semibold text-gray-900">{user.name}</p>
                <p className="text-sm text-gray-500">@{user.username}</p>
              </div>
            </div>

            <button
              onClick={() => onAddFriend?.(user.id)}
              className="px-3 py-1.5 text-sm rounded-lg bg-indigo-600 text-white hover:bg-indigo-700 transition"
            >
              Add
            </button>
          </div>
        ))}
      </div>
    </div>
  )
}
