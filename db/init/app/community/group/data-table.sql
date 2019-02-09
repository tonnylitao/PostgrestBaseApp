set search_path to data, public;

-- schema data
create table if not exists data.groups (
	id                   serial primary key,
	created_at					 timestamptz not null default now(),
	updated_at					 timestamptz not null default now(),

	name                 text not null,
	user_id              int references data.users(id) not null default public.app_user_id()
);

-- row level policy
-- 注意，rlp并不会影响到view的查询，即使select增加了限制，view也仍然被暴露
alter table data.groups enable row level security;

select app_user.rlp_insert('groups');
select app_user.rlp_update('groups', 'user_id = app_user_id()');
select app_user.rlp_delete('groups', 'user_id = app_user_id()');
select app_admin.rlp_delete('groups', 'true');
