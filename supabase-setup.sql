-- SSC CGL Tracker 2027 - Supabase setup
-- Run this once in Supabase Dashboard -> SQL Editor.

create table if not exists public.cgl_tracker_data (
  user_id uuid primary key references auth.users(id) on delete cascade,
  data jsonb not null,
  updated_at timestamptz not null default now()
);

alter table public.cgl_tracker_data enable row level security;

revoke all on table public.cgl_tracker_data from anon;
grant select, insert, update on table public.cgl_tracker_data to authenticated;

drop policy if exists "Users can read their own tracker data" on public.cgl_tracker_data;
drop policy if exists "Users can insert their own tracker data" on public.cgl_tracker_data;
drop policy if exists "Users can update their own tracker data" on public.cgl_tracker_data;

create policy "Users can read their own tracker data"
on public.cgl_tracker_data
for select
to authenticated
using ((select auth.uid()) = user_id);

create policy "Users can insert their own tracker data"
on public.cgl_tracker_data
for insert
to authenticated
with check ((select auth.uid()) = user_id);

create policy "Users can update their own tracker data"
on public.cgl_tracker_data
for update
to authenticated
using ((select auth.uid()) = user_id)
with check ((select auth.uid()) = user_id);
