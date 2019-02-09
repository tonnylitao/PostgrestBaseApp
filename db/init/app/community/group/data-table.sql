set search_path to data, public;

-- schema data
create table if not exists data.groups (
	id                   serial primary key,
	created_at					 timestamptz not null default now(),
	updated_at					 timestamptz not null default now(),

	name                 text not null,
	user_id              int references data.users(id) not null default request.user_id()
);
create index "data.groups_user_id_index" on data.groups(user_id);

-- row level policy
alter table data.groups enable row level security;
-- GET
select public.rls_select('groups');

-- POST
select app_user.rls_insert('groups', 'user_id = request.user_id()');

-- PATCH
select app_user.rls_update('groups', 'user_id = request.user_id()');

-- DELETE
select app_user.rls_delete('groups', 'user_id = request.user_id()');
select app_admin.rls_delete('groups', 'true');

-- notify
create trigger groups_notify after insert or update or delete on data.groups
	for each row execute procedure data.notify_trigger('id');

create trigger groups_updated_at before update on data.groups
	for each row execute procedure data.trigger_update_update_at();
