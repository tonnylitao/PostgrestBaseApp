set search_path to data, public;

-- table
create table data.posts (
	id                   serial primary key,
	created_at					 timestamptz not null default now(),
	updated_at					 timestamptz not null default now(),

	title                text not null,
  body                 text not null,
	user_id              int references data.users(id) not null default request.user_id(),
	group_id             int references data.groups(id) not null
);
create index "data.posts_user_id_index" on data.posts(user_id);
create index "data.posts_group_id_index" on data.posts(group_id);

-- Row Security Policies
alter table data.posts force row level security;
-- GET
select public.rls_select('posts');

-- POST
select app_user.rls_insert('posts', 'user_id = request.user_id()');

-- PATCH
select app_user.rls_update('posts', 'user_id = request.user_id()');

-- DELETE
select app_user.rls_delete('posts', 'user_id = request.user_id() or is_group_admin(''groups'', group_id)');
select app_admin.rls_delete('posts', 'true');

-- notify
create trigger posts_notify after insert or update or delete on data.posts
	for each row execute procedure data.notify_trigger('id');

create trigger posts_updated_at before update on data.posts
	for each row execute procedure data.trigger_update_update_at();
