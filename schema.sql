-- ============================
--  SCHÉMA COMPLET SUPABASE
--  Projet : gestion avs
-- ============================

-- =====================================
-- TABLE : admins
-- =====================================
create table public.admins (
  user_id uuid not null,
  email text not null,
  created_at timestamp with time zone not null default now(),
  constraint admins_pkey primary key (user_id),
  constraint admins_email_key unique (email),
  constraint admins_user_id_fkey foreign key (user_id)
    references auth.users (id)
    on delete cascade
) tablespace pg_default;

-- =====================================
-- TABLE : clients
-- =====================================
create table public.clients (
  id uuid not null default gen_random_uuid(),
  name text not null,
  address text null,
  phone text null,
  notes text null,
  created_at timestamp with time zone not null default now(),
  constraint clients_pkey primary key (id)
) tablespace pg_default;

-- =====================================
-- TABLE : employees
-- =====================================
create table public.employees (
  id uuid not null,
  first_name text not null,
  last_name text not null,
  phone text null,
  created_at timestamp with time zone not null default now(),
  address text null,
  email text null,
  constraint employees_pkey primary key (id),
  constraint employees_id_fkey foreign key (id)
    references auth.users (id)
    on delete cascade
) tablespace pg_default;

-- =====================================
-- TABLE : interventions
-- =====================================
create table public.interventions (
  id uuid not null default gen_random_uuid(),
  client_id uuid not null,
  employee_id uuid not null,
  date date not null,
  start_time_planned time without time zone not null,
  end_time_planned time without time zone not null,
  status text not null default 'planned'::text,
  notes text null,
  created_at timestamp with time zone not null default now(),
  is_weekly boolean not null default false,
  constraint interventions_pkey primary key (id),
  constraint interventions_client_id_fkey foreign key (client_id)
    references public.clients (id)
    on delete restrict,
  constraint interventions_employee_id_fkey foreign key (employee_id)
    references public.employees (id)
    on delete restrict,
  constraint interventions_status_check check (
    status = any (
      array['planned'::text, 'in_progress'::text, 'done'::text, 'cancelled'::text]
    )
  )
) tablespace pg_default;

-- =====================================
-- TRIGGER : création automatique d’une deuxième intervention hebdomadaire
-- =====================================
create trigger trg_create_second_weekly_intervention
after insert on public.interventions
for each row
execute function public.create_second_weekly_intervention();

-- =====================================
-- TABLE : pointages
-- =====================================
create table public.pointages (
  id uuid not null default gen_random_uuid(),
  intervention_id uuid not null,
  employee_id uuid not null,
  type text not null,
  timestamp timestamp with time zone not null default now(),
  latitude double precision null,
  longitude double precision null,
  accuracy double precision null,
  created_at timestamp with time zone not null default now(),
  constraint pointages_pkey primary key (id),
  constraint pointages_employee_id_fkey foreign key (employee_id)
    references public.employees (id)
    on delete cascade,
  constraint pointages_intervention_id_fkey foreign key (intervention_id)
    references public.interventions (id)
    on delete cascade,
  constraint pointages_type_check check (
    type = any (array['start'::text, 'end'::text])
  )
) tablespace pg_default;
