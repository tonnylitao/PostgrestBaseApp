set search_path to data, public;

-- table
create table data.messages (
	id                   serial primary key,
	created_at					 timestamptz not null default now(),

  body                 text,
	from_id              int references data.users(id) not null default request.user_id(),
	to_id                int references data.users(id) not null
);
create index "data.messages_from_id_index" on data.messages(from_id);
create index "data.messages_to_id_index" on data.messages(to_id);

-- Row level policy
alter table data.messages force row level security;
-- GET
select app_user.rls_select('messages', 'from_id = request.user_id() or to_id = request.user_id()');

-- POST
select app_user.rls_insert('messages');

-- DELETE
select app_user.rls_delete('messages', 'from_id = request.user_id()');

-- notify
create trigger messages_notify after insert or update or delete on data.messages
	for each row execute procedure data.notify_trigger('id');
