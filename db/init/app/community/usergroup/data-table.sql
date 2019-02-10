set search_path to data, public;

-- alter table data.users add column
--   group_id int references data.groups(id) default public.app_group_id();

-- table
create table data.usergroups (
	created_at					 timestamptz not null default now(),

	user_id              int references data.users(id) not null default request.user_id(),
	group_id             int references data.groups(id) not null,

  primary key (user_id, group_id)
);

-- Row Security Policies
alter table data.usergroups force row level security;
-- GET
select public.rls_select('usergroups');

-- POST
select app_user.rls_insert('usergroups', 'user_id = request.user_id()');

-- DELETE
select app_user.rls_delete('usergroups', 'user_id = request.user_id() or is_group_admin(''groups'', group_id)');

-- notify
create trigger usergroups_notify after insert or update or delete on data.usergroups
	for each row execute procedure data.notify_trigger('id');
