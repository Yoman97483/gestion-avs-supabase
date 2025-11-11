import { createClient } from '@supabase/supabase-js'

// Chargement des variables d'environnement
const SUPABASE_URL = 'https://dxtckfdhzfbwdtptwuza.supabase.co'
const SUPABASE_ANON_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImR4dGNrZmRoemZid2R0cHR3dXphIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjI0ODgyMzcsImV4cCI6MjA3ODA2NDIzN30.YDB8fDz2PAI5ZrBt4DCWAuUkST9NbY0DbC-iMEbw-Mo'

const supabase = createClient(SUPABASE_URL, SUPABASE_ANON_KEY)

// Exemple : lire la table "users"
async function getUsers() {
  const { data, error } = await supabase.from('users').select('*')
  if (error) console.error('Erreur :', error)
  else console.log('Utilisateurs :', data)
}

getUsers()
