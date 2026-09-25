import LegalPage, { ContactLine } from "./LegalPage";
import { PLANS } from "@/lib/config";

// DRAFT: written as a starting point, not legal advice. Have a lawyer review before launch.
export default function Refunds() {
  return (
    <LegalPage title="Refund Policy">
      <h2>Cancelling</h2>
      <p>
        You can cancel Pro anytime from your Account page ("Manage billing"). You won't be charged again, and you keep
        Pro until the end of the month you've already paid for.
      </p>

      <h2>Refunds</h2>
      <ul>
        <li>
          <strong>First charge:</strong> if Pro isn't right for you, contact us within 7 days of your first payment
          for a full refund.
        </li>
        <li>
          <strong>Renewals:</strong> monthly renewals aren't refunded, including partial months, but cancelling stops
          all future charges.
        </li>
        <li>
          <strong>Our mistakes:</strong> if you were charged in error or the Service was unavailable for a long
          stretch, contact us and we'll make it right.
        </li>
      </ul>

      <h2>Free plan</h2>
      <p>
        The Free plan ({PLANS.free.monthlyActions} AI checks a month) is the best way to try the Service before
        paying.
      </p>

      <ContactLine />
    </LegalPage>
  );
}
