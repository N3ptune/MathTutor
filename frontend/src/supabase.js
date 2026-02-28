import { createClient } from '@supabase/supabase-js';

const SUPABASE_URL = import.meta.env.VITE_SUPABASE_URL;
const SUPABASE_ANON_KEY = import.meta.env.VITE_SUPABASE_ANON_KEY;

// #region agent log
fetch('http://127.0.0.1:7418/ingest/9e11d919-51b9-4dad-a5a4-c5bbc1800f95',{method:'POST',headers:{'Content-Type':'application/json','X-Debug-Session-Id':'511fd2'},body:JSON.stringify({sessionId:'511fd2',location:'supabase.js:6',message:'Supabase env check at runtime',data:{supabaseUrlPresent:!!SUPABASE_URL,supabaseAnonKeyPresent:!!SUPABASE_ANON_KEY,supabaseUrlLength:SUPABASE_URL?.length??0},timestamp:Date.now(),hypothesisId:'H2',runId:'pre-fix'})}).catch(()=>{});
// #endregion

if (!SUPABASE_URL || !SUPABASE_ANON_KEY) {
  throw new Error("Supabase URL or anon key is missing! Check your .env file.");
}

export const supabase = createClient(SUPABASE_URL, SUPABASE_ANON_KEY);
