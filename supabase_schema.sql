-- ==========================================================
-- Schema para salvar cálculos de frete por cliente
-- Rode este script inteiro no SQL Editor do seu projeto Supabase
-- (https://app.supabase.com -> seu projeto -> SQL Editor -> New query)
-- ==========================================================

create extension if not exists pgcrypto;

create table if not exists clients (
  id uuid primary key default gen_random_uuid(),
  name text unique not null,
  created_at timestamptz not null default now()
);

create table if not exists freight_calculations (
  id uuid primary key default gen_random_uuid(),
  client_id uuid references clients(id) on delete set null,
  calc_date date not null default current_date,
  destination text,
  distance_km numeric,
  round_trip boolean default false,
  vehicle_id text,
  tractor_id text,
  diesel numeric default 0,
  driver numeric default 0,
  toll numeric default 0,
  maintenance numeric default 0,
  arla numeric default 0,
  depreciation numeric default 0,
  insurance numeric default 0,
  cargo_value numeric default 0,
  risk_pct numeric default 0,
  gris_total numeric default 0,
  taxes_pct numeric default 0,
  taxes_value numeric default 0,
  profit_pct numeric default 0,
  fine numeric default 0,
  total_freight numeric default 0,
  created_at timestamptz not null default now()
);

create index if not exists idx_freight_calc_date on freight_calculations (calc_date);
create index if not exists idx_freight_calc_client on freight_calculations (client_id);

-- ==========================================================
-- RLS: a calculadora já tem uma senha de acesso na própria página
-- (só protege contra acesso casual, não é autenticação real). Por
-- isso liberamos leitura/escrita para a chave anônima (anon key) —
-- não exponha essa chave fora do link já protegido pela senha.
-- ==========================================================
alter table clients enable row level security;
alter table freight_calculations enable row level security;

create policy "allow all on clients" on clients
  for all using (true) with check (true);

create policy "allow all on freight_calculations" on freight_calculations
  for all using (true) with check (true);
