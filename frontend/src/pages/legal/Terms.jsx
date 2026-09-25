import { Link } from "react-router-dom";
import LegalPage, { ContactLine } from "./LegalPage";
import { GOVERNING_LAW, LEGAL_ENTITY, MINIMUM_AGE, PLANS, PRODUCT_NAME } from "@/lib/config";

// DRAFT: written as a starting point, not legal advice. Have a lawyer review before launch.
export default function Terms() {
  return (
    <LegalPage title="Terms of Service">
      <p>
        These terms are an agreement between you and {LEGAL_ENTITY} ("we", "us") for your use of {PRODUCT_NAME}
        (the "Service"). By creating an account or using the Service, you agree to them.
      </p>

      <h2>1. Who can use {PRODUCT_NAME}</h2>
      <p>
        You must be at least {MINIMUM_AGE} years old. If you are under 18, you may only use the Service with the
        permission of a parent or legal guardian, who agrees to these terms on your behalf and is responsible for
        any purchase.
      </p>

      <h2>2. Your account</h2>
      <p>
        Keep your login details private; you are responsible for activity on your account. Tell us promptly if you
        think someone else has accessed it.
      </p>

      <h2>3. Plans, billing, and cancellation</h2>
      <ul>
        <li>
          The Free plan includes {PLANS.free.monthlyActions} AI checks per month. An AI check is one graded
          submission, generated practice problem, exam start that needs new questions, or exam submission.
        </li>
        <li>
          The Pro plan costs ${PLANS.pro.price.toFixed(2)} per month (plus any applicable tax) and includes up to{" "}
          {PLANS.pro.monthlyActions} AI checks per month. Usage limits reset on the 1st of each month (UTC) and
          unused checks don't roll over.
        </li>
        <li>
          Pro renews automatically each month and is charged to your payment method until you cancel. Payments are
          processed by Stripe.
        </li>
        <li>
          You can cancel anytime from your Account page. You keep Pro until the end of the period you've paid for.
          See our <Link to="/refunds" className="underline">Refund Policy</Link>.
        </li>
        <li>We may change prices with at least 30 days' notice; changes apply from your next billing period.</li>
      </ul>

      <h2>4. AI feedback can be wrong</h2>
      <p>
        {PRODUCT_NAME} uses AI to grade work and generate problems. It can make mistakes, including marking correct
        work as wrong or wrong work as correct. It is a study aid, not a replacement for your teacher, textbook, or
        official answer keys. If a grade looks wrong, use "This grade looks wrong" so we can review it.
      </p>

      <h2>5. Academic honesty</h2>
      <p>
        Follow your school's rules. Don't use the Service where outside help isn't allowed, such as on graded tests.
      </p>

      <h2>6. Acceptable use</h2>
      <ul>
        <li>Don't try to get around usage limits, share accounts, or resell access.</li>
        <li>Don't upload content you don't have the right to share, or anything illegal or harmful.</li>
        <li>Don't try to break, overload, reverse engineer, or misuse the Service or its AI.</li>
      </ul>

      <h2>7. Your content</h2>
      <p>
        You own the work you submit. You give us permission to store and process it, including sending it to our AI
        provider, to run the Service for you. How we handle it is described in our{" "}
        <Link to="/privacy" className="underline">Privacy Policy</Link>.
      </p>

      <h2>8. Ending your account</h2>
      <p>
        You can delete your account anytime from your Account page. We may suspend or close accounts that break
        these terms. If we close your account without cause, we'll refund any unused, prepaid Pro time.
      </p>

      <h2>9. Disclaimers and limits of liability</h2>
      <p>
        The Service is provided "as is" without warranties of any kind, to the extent the law allows. To the extent
        the law allows, our total liability for any claim relating to the Service is limited to the amount you paid
        us in the 12 months before the claim. Nothing in these terms limits rights you have under consumer
        protection laws that can't be waived.
      </p>

      <h2>10. Changes to these terms</h2>
      <p>
        If we change these terms in a meaningful way, we'll ask you to accept the new version before you continue
        using the Service.
      </p>

      <h2>11. Governing law</h2>
      <p>These terms are governed by the laws of {GOVERNING_LAW}.</p>

      <ContactLine />
    </LegalPage>
  );
}
