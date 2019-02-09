set search_path to data, public;

-- table
create table data.comments (
	id                   serial primary key,
	created_at					 timestamptz not null default now(),
	updated_at					 timestamptz not null default now(),

  body                 text,
	user_id              int references data.users(id) not null default request.user_id(),
	post_id              int references data.posts(id) not null
);
create index "data.comments_user_id_index" on data.comments(user_id);
create index "data.comments_post_id_index" on data.comments(post_id);

-- Row level policy
alter table data.comments enable row level security;
-- GET
select public.rls_select('comments');

-- POST
select app_user.rls_insert('comments', 'user_id = request.user_id()');

-- PATCH
select app_user.rls_update('comments', 'user_id = request.user_id()');

-- DELETE
select app_user.rls_delete('comments', 'user_id = request.user_id() or is_group_admin(''posts'', post_id)');
select app_admin.rls_delete('comments', 'true');

-- notify
create trigger comments_notify after insert or update or delete on data.comments
	for each row execute procedure data.notify_trigger('id');

create trigger comments_updated_at before update on data.comments
	for each row execute procedure data.trigger_update_update_at();
