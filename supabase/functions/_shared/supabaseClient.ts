import { createClient } from 'https://esm.sh/@supabase/supabase-js@2';

const supabaseUrl = Deno.env.get('VITE_SUPABASE_URL') || 'https://wfrqutsdobwancfanerr.supabase.co';
const supabaseAnonKey = Deno.env.get('VITE_SUPABASE_ANON_KEY') || 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6IndmcnF1dHNkb2J3YW5jZmFuZXJyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDExNDA3ODIsImV4cCI6MjA1NjcxNjc4Mn0.57qGW0OmTt_MMPrXOLZv-X8bqn5bnCcjhHQaKkxHYVQ';

export const supabaseClient = createClient(supabaseUrl, supabaseAnonKey);
