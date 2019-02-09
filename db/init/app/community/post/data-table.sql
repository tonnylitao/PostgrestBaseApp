set search_path to data, public;

-- table
create table data.posts (
	id                   serial primary key,
	created_at					 timestamptz not null default now(),
	updated_at					 timestamptz not null default now(),

	title                text not null,
  body                 text,
	user_id              int references data.users(id) not null default public.app_user_id(),
	group_id             int references data.groups(id) not null
);
create index "data.posts_user_id_index" on data.posts(user_id);
create index "data.posts_group_id_index" on data.posts(group_id);

-- Row level policy
alter table data.posts enable row level security;

select app_user.rlp_insert('posts');
select app_user.rlp_update('posts', 'user_id = app_user_id()');
select app_user.rlp_delete('posts', 'user_id = app_user_id() or is_group_admin(group_id)');
select app_admin.rlp_delete('posts', 'true');

-- notify

create trigger posts_notify after insert or update or delete on data.posts
for each row execute procedure data.notify_trigger (
  'id'
);
