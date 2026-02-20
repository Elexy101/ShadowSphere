import { useWallet } from "@provablehq/aleo-wallet-adaptor-react";
import { Navigate } from "react-router-dom";

export default function ProtectedRoute({ children }) {
  const { connected, connecting, address } = useWallet();

  if (connecting) {
    return (
      <div className="min-h-screen flex flex-col items-center justify-center bg-slate-950 text-indigo-400">
        <div className="w-8 h-8 border-4 border-indigo-500 border-t-transparent rounded-full animate-spin mb-4"></div>
        <p className="animate-pulse font-mono text-sm">
          SCANNING ALEO LEDGER...
        </p>
      </div>
    );
  }

  if (!connected || !address) {
    return <Navigate to="/" replace />;
  }
  return children;
}
