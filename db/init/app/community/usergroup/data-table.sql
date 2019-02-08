set search_path to data, public;

-- alter table data.users add column
--   group_id int references data.groups(id) default public.app_group_id();

-- table
create table data.usergroups (
	created_at					 timestamptz not null default now(),

	user_id              int references data.users(id) not null default public.app_user_id(),
	group_id             int references data.groups(id) not null,

  primary key (user_id, group_id)
);

-- rest
alter table data.usergroups enable row level security;

select public.rlp_select('usergroups', 'true');
select app_user.rlp_insert('usergroups');
select app_user.rlp_delete('usergroups', 'user_id = app_user_id()');

-- notify
create trigger users_notify after insert or update or delete on data.usergroups
for each row execute procedure data.notify_trigger (
  'id'
);
