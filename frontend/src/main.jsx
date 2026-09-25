import React from 'react'
import ReactDOM from 'react-dom/client'
import './index.css'
import App from './App'
import { BrowserRouter } from 'react-router-dom'
import { AuthProvider } from './authState'
import * as Sentry from '@sentry/react'

// Error reporting is on only when a DSN is provided at build time
if (import.meta.env.VITE_SENTRY_DSN) {
  Sentry.init({
    dsn: import.meta.env.VITE_SENTRY_DSN,
    environment: import.meta.env.VITE_ENVIRONMENT || import.meta.env.MODE,
    // Students' work and emails stay out of error reports
    sendDefaultPii: false,
  })
}

ReactDOM.createRoot(document.getElementById('root')).render(
  <Sentry.ErrorBoundary fallback={<p className="p-6 text-center">Something went wrong. Please reload the page.</p>}>
    <BrowserRouter>
      <AuthProvider>
        <App />
      </AuthProvider>
    </BrowserRouter>
  </Sentry.ErrorBoundary>
)
