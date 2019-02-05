set search_path to data, public;

alter table data.users add column
  group_id int references data.groups(id) default public.app_group_id();

create index if not exists "data.users_group_id_index" on data.users(group_id);


create policy users_admin_SIUD on data.users
  to app_admin
  using ( group_id = public.app_group_id() );
