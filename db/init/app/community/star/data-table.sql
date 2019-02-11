set search_path to data, public;

-- table
create table data.stars (
	id                   serial primary key,
	created_at					 timestamptz not null default now(),

	user_id              int references data.users(id) not null default request.user_id(),
	post_id              int references data.posts(id) not null
);
create index "data.stars_user_id_index" on data.stars(user_id);
create index "data.stars_post_id_index" on data.stars(post_id);

-- Row level policy
alter table data.stars force row level security;
-- GET
select public.rls_select('stars');

-- POST
select app_user.rls_insert('stars');

-- DELETE
select app_user.rls_delete('stars', 'user_id = request.user_id()');

-- notify
create trigger stars_notify after insert or update or delete on data.stars
	for each row execute procedure data.notify_trigger('id');
