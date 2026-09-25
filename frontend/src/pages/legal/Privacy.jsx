import LegalPage, { ContactLine } from "./LegalPage";
import { LEGAL_ENTITY, MINIMUM_AGE, PRODUCT_NAME } from "@/lib/config";

// DRAFT: written as a starting point, not legal advice. Have a lawyer review before launch,
// and keep the list of service providers in sync with what the app actually uses.
export default function Privacy() {
  return (
    <LegalPage title="Privacy Policy">
      <p>
        This policy explains what {LEGAL_ENTITY} ("we") collects when you use {PRODUCT_NAME}, how it's used, and the
        choices you have.
      </p>

      <h2>What we collect</h2>
      <ul>
        <li><strong>Account details:</strong> your name and email address, and when you accepted our terms.</li>
        <li>
          <strong>Your work:</strong> the steps you type, images and PDFs you upload, and the feedback and grades
          the Service gives you, so you can review past attempts and track progress.
        </li>
        <li>
          <strong>Learning progress:</strong> the classes you register for, your proficiency, exam results, and any
          grade reports you send.
        </li>
        <li>
          <strong>Usage:</strong> how many AI checks you use and their cost to us, used to enforce plan limits.
        </li>
        <li>
          <strong>Billing:</strong> your subscription status. Card details are handled entirely by Stripe; we never
          see or store your full card number.
        </li>
        <li>
          <strong>Diagnostics:</strong> error reports when something breaks, without your name, email, or math
          work.
        </li>
      </ul>

      <h2>How we use it</h2>
      <p>
        To run the Service: grade your work, show your history and progress, enforce plan limits, bill Pro
        subscriptions, fix problems, and respond to support requests. We don't sell your personal information and we
        don't use it for advertising.
      </p>

      <h2>Who we share it with</h2>
      <p>Only the service providers that run {PRODUCT_NAME} for us:</p>
      <ul>
        <li><strong>OpenAI</strong> receives the problems and work you submit, to grade them and generate problems.</li>
        <li><strong>Supabase</strong> stores your account and data and handles sign-in.</li>
        <li><strong>Amazon Web Services</strong> hosts the app.</li>
        <li><strong>Stripe</strong> processes payments for Pro.</li>
        <li><strong>Sentry</strong> receives error reports.</li>
        <li><strong>Google</strong>, only if you choose to sign in with Google.</li>
      </ul>
      <p>We may also disclose information if required by law.</p>

      <h2>How long we keep it</h2>
      <p>
        We keep your data while your account exists. When you delete your account, we delete your data from our
        database right away. Copies in backups and our providers' systems are removed on their normal schedules.
        Payment records are kept by Stripe as required for tax and accounting.
      </p>

      <h2>Your choices</h2>
      <ul>
        <li><strong>Download your data</strong> anytime from your Account page.</li>
        <li><strong>Delete your account</strong> and data anytime from your Account page.</li>
        <li>Contact us to correct your information or with any privacy question.</li>
      </ul>

      <h2>Children</h2>
      <p>
        {PRODUCT_NAME} is not for children under {MINIMUM_AGE}. If we learn that someone under {MINIMUM_AGE} has
        created an account, we will delete it. If you believe this has happened, please contact us.
      </p>

      <h2>Security</h2>
      <p>
        Data is encrypted in transit, access to it is restricted to your own account, and our providers encrypt it at
        rest. No system is perfectly secure, so please use a strong, unique password.
      </p>

      <h2>Changes</h2>
      <p>If we change this policy in a meaningful way, we'll ask you to review it before you continue.</p>

      <ContactLine />
    </LegalPage>
  );
}
