import { Outlet } from "react-router-dom";
import Sidebar from "./SideBar";
import Topbar from "./TopBar";
import BottomNav from "./BottomNav";

export default function AppLayout() {
  return (
    <div className="h-screen flex bg-[var(--color-background)] text-[var(--color-text-primary)]">
      <Sidebar />
      <div className="flex-1 flex flex-col overflow-hidden">
        <Topbar />
        <main className="flex-1 overflow-y-auto p-6">
          <Outlet /> {/* This is where the specific page components render */}
        </main>
        {/* <BottomNav /> */}
      </div>
    </div>
  );
}
