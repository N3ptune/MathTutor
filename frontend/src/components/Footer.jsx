import { Link } from "react-router-dom";
import { PRODUCT_NAME, SUPPORT_EMAIL } from "@/lib/config";

export default function Footer() {
  return (
    <footer className="border-t mt-auto">
      <div className="max-w-6xl mx-auto px-4 sm:px-6 py-6 flex flex-col sm:flex-row gap-3 sm:items-center justify-between text-sm text-muted-foreground">
        <p>© {new Date().getFullYear()} {PRODUCT_NAME}</p>
        <nav className="flex flex-wrap gap-x-5 gap-y-2">
          <Link to="/#pricing" className="hover:text-foreground">Pricing</Link>
          <Link to="/terms" className="hover:text-foreground">Terms</Link>
          <Link to="/privacy" className="hover:text-foreground">Privacy</Link>
          <Link to="/refunds" className="hover:text-foreground">Refunds</Link>
          {SUPPORT_EMAIL && (
            <a href={`mailto:${SUPPORT_EMAIL}`} className="hover:text-foreground">Contact</a>
          )}
        </nav>
      </div>
    </footer>
  );
}
