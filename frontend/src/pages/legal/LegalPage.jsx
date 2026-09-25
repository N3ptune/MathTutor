import { Link } from "react-router-dom";
import { ArrowLeft } from "lucide-react";
import { Button } from "@/components/ui/button";
import { LEGAL_LAST_UPDATED, SUPPORT_EMAIL } from "@/lib/config";

// Shared layout for Terms, Privacy, and Refunds. Public: readable without signing in.
export default function LegalPage({ title, children }) {
  return (
    <div className="max-w-3xl mx-auto px-4 sm:px-6 py-6 sm:py-10">
      <Button variant="ghost" size="sm" className="mb-4" asChild>
        <Link to="/">
          <ArrowLeft className="size-4" />
          Home
        </Link>
      </Button>
      <h1 className="text-2xl sm:text-3xl font-bold mb-2">{title}</h1>
      <p className="text-sm text-muted-foreground mb-8">Last updated {LEGAL_LAST_UPDATED}</p>
      <div className="space-y-6 leading-relaxed [&_h2]:text-lg [&_h2]:font-semibold [&_h2]:mt-8 [&_h2]:mb-2 [&_ul]:list-disc [&_ul]:pl-6 [&_ul]:space-y-1">
        {children}
      </div>
    </div>
  );
}

export function ContactLine() {
  return SUPPORT_EMAIL ? (
    <p>
      Questions? Email <a className="underline" href={`mailto:${SUPPORT_EMAIL}`}>{SUPPORT_EMAIL}</a>.
    </p>
  ) : null;
}
