-- revert migration
drop table if exists app_public.users;
drop function if exists app_public.current_user_id;
drop function if exists app_private.set_updated_at();

-- FUNCTIONS

-- Current ID
create function app_public.current_user_id() returns uuid as $$
  select nullif(current_setting('jwt.claims.user_id', true), '')::uuid;
$$ language sql stable;

grant execute on function app_public.current_user_id() to admin, app_user;

-- Updated AT
create function app_private.set_updated_at() returns trigger as $$
begin
  new.updated_at := current_timestamp;
  return new;
end;
$$ language plpgsql;

-- USERS

-- Table
create table app_public.users (
  id uuid default gen_random_uuid() unique not null primary key,
  first_name text,
  last_name text,
  email text unique not null check (email ~ '[^@]+@[^@]+\.[^@]+'),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

-- Grants
grant all
  on app_public.users
  to admin;

grant
  select(id, first_name, last_name, email, created_at, updated_at),
  update(first_name, last_name)
  on app_public.users
  to app_user, admin;

-- Rbac
alter table app_public.users enable row level security;

create policy admin_users
  on app_public.users
  to admin
  using (true);

create policy select_users
  on app_public.users
  for select
  to app_user
  using (id = app_public.current_user_id());

create policy update_users
  on app_public.users
  for update
  to app_user
  using (id = app_public.current_user_id());

-- TRIGGERS

-- Users : updated_at
create trigger users_updated_at before update
  on app_public.users
  for each row
  execute procedure app_private.set_updated_at();
