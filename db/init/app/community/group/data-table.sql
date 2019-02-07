set search_path to data, public;

-- schema data
CREATE TABLE IF NOT EXISTS data.groups (
	id                   serial primary key,
	created_at					 timestamptz not null default now(),
	updated_at					 timestamptz not null default now(),

	name                 text not null,
	user_id              int references data.users(id) not null default public.app_user_id()
);

-- Row Level Policy
-- 注意，RLP并不会影响到view的查询，即使Select增加了限制，View也仍然被暴露
ALTER TABLE data.groups ENABLE ROW LEVEL SECURITY;

select create_row_policy(array['public'], 'select', 'groups', 'true');
select create_row_policy(array['app_user','app_admin'], 'insert', 'groups', '');
select create_row_policy(array['app_user','app_admin'], 'update', 'groups', 'user_id = app_user_id()');
select create_row_policy(array['app_user','app_admin'], 'delete', 'groups', 'user_id = app_user_id()');
