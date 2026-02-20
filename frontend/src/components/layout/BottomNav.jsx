import { Home, MessageSquare, Wallet, Gift, Users, User } from "lucide-react";
import { NavLink } from "react-router-dom";

const navItems = [
  { label: "Feed", icon: Home, path: "/feed" },
  { label: "Messages", icon: MessageSquare, path: "/messages", badge: 3 },
  { label: "Wallet", icon: Wallet, path: "/wallet" },
  { label: "Gifts", icon: Gift, path: "/gifts" },
  { label: "Friends", icon: Users, path: "/friends" },
  { label: "Profile", icon: User, path: "/profile" },
];

export default function BottomNav() {
  return (
    <>
      {/* Mobile Bottom Nav */}
      <nav className="md:hidden fixed bottom-0 left-0 right-0 z-50">
        {/* Frosted glass backdrop */}
        <div className="absolute inset-0 bg-[var(--color-surface)]/80 backdrop-blur-xl border-t border-[var(--color-border)] pointer-events-none" />

        {/* Gradient glow top edge */}
        <div className="absolute top-0 left-0 right-0 h-px bg-gradient-to-r from-transparent via-indigo-500/50 to-transparent pointer-events-none" />

        <div className="relative flex items-center justify-around px-2 py-2 safe-area-pb">
          {navItems.map((item, index) => (
            <NavLink
              key={item.label}
              to={item.path}
              className="relative flex-1"
              style={{ animationDelay: `${index * 40}ms` }}>
              {({ isActive }) => (
                <div
                  className={`
                    group relative flex flex-col items-center gap-1 px-2 py-2 rounded-2xl
                    transition-all duration-300 mx-0.5
                    ${
                      isActive
                        ? "bg-gradient-to-b from-indigo-600/20 to-purple-600/20"
                        : "hover:bg-[var(--color-muted)] active:scale-90"
                    }
                  `}>
                  {/* Active glow ring */}
                  {isActive && (
                    <div className="absolute inset-0 rounded-2xl bg-indigo-500/10 blur-sm animate-pulse pointer-events-none" />
                  )}

                  {/* Icon wrapper */}
                  <div className="relative">
                    <item.icon
                      size={22}
                      className={`transition-all duration-300 ${
                        isActive
                          ? "text-indigo-400 drop-shadow-[0_0_8px_rgba(99,102,241,0.7)] scale-110"
                          : "text-[var(--color-text-secondary)] group-hover:text-[var(--color-text-primary)] group-active:scale-90"
                      }`}
                    />

                    {/* Badge */}
                    {item.badge && (
                      <span className="absolute -top-1.5 -right-2 flex items-center justify-center w-4 h-4 text-[9px] font-bold text-white bg-gradient-to-r from-pink-500 to-rose-500 rounded-full shadow-lg shadow-pink-500/40 animate-pulse">
                        {item.badge}
                      </span>
                    )}
                  </div>

                  {/* Label */}
                  <span
                    className={`text-[10px] font-semibold tracking-wide transition-all duration-300 ${
                      isActive
                        ? "text-indigo-400"
                        : "text-[var(--color-text-secondary)] group-hover:text-[var(--color-text-primary)]"
                    }`}>
                    {item.label}
                  </span>

                  {/* Active dot indicator */}
                  {isActive && (
                    <div className="absolute -top-0.5 left-1/2 -translate-x-1/2 w-6 h-0.5 bg-gradient-to-r from-indigo-500 to-purple-500 rounded-full" />
                  )}
                </div>
              )}
            </NavLink>
          ))}
        </div>
      </nav>

      {/* Spacer so page content doesn't hide behind nav */}
      <div className="md:hidden h-20" />

      <style jsx>{`
        .safe-area-pb {
          padding-bottom: max(0.5rem, env(safe-area-inset-bottom));
        }

        nav > div > a {
          animation: slideUpIn 0.4s ease-out backwards;
        }

        @keyframes slideUpIn {
          from {
            opacity: 0;
            transform: translateY(16px);
          }
          to {
            opacity: 1;
            transform: translateY(0);
          }
        }
      `}</style>
    </>
  );
}
