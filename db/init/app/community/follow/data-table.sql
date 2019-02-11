set search_path to data, public;

-- table
create table data.follows (
	id                   serial primary key,
	created_at					 timestamptz not null default now(),

	from_id              int references data.users(id) not null default request.user_id(),
	to_id                int references data.users(id) not null
);
create index "data.follows_from_id_index" on data.follows(from_id);
create index "data.follows_to_id_index" on data.follows(to_id);

-- Row level policy
alter table data.follows force row level security;
-- GET
select app_user.rls_select('follows', 'from_id = request.user_id() or to_id = request.user_id()');

-- POST
select app_user.rls_insert('follows');

-- DELETE
select app_user.rls_delete('follows', 'from_id = request.user_id()');

-- notify
create trigger follows_notify after insert or update or delete on data.follows
	for each row execute procedure data.notify_trigger('id');
