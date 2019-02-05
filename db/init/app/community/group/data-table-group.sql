set search_path to data, public;

-- schema data
CREATE TABLE IF NOT EXISTS data.groups (
	id                   serial primary key,
	created_at					 timestamptz not null default now(),
	updated_at					 timestamptz not null default now(),

	name                 text not null,
	user_id              int references data.users(id) default public.app_user_id()s
);

-- Row Level Policy
-- 注意，RLP并不会影响到view的查询，即使Select增加了限制，View也仍然被暴露
ALTER TABLE data.groups ENABLE ROW LEVEL SECURITY;

CREATE POLICY groups_admin_SIUD ON data.groups TO app_admin
  USING ( id = app_group_id() );

CREATE POLICY groups_user_S ON data.groups
  FOR SELECT TO app_user
  USING ( id = app_group_id() );

CREATE POLICY groups_anonym_S ON data.groups
  FOR SELECT TO app_anonym
  USING ( true );
