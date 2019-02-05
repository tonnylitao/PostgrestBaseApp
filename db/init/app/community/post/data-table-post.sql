set search_path to data, public;

-- Posts
CREATE TABLE IF NOT EXISTS data.posts (
	id                   serial primary key,
	created_at					 timestamptz not null default now(),
	updated_at					 timestamptz not null default now(),

	title                text not null,
  body                 text,
	user_id              int references data.users(id) default public.app_user_id(),
	group_id             int references data.groups(id) default public.app_group_id()
);
CREATE INDEX IF NOT EXISTS "data.posts_group_id_index" on data.posts(group_id);

-- Row level policy
ALTER TABLE data.posts ENABLE ROW LEVEL SECURITY;

CREATE POLICY posts_admin_SIUD ON data.posts TO app_admin
  USING ( group_id = app_group_id() );

CREATE POLICY posts_user_SIUD ON data.posts TO app_user
  USING ( user_id = app_user_id() );

CREATE POLICY posts_anonym_S ON data.posts
  FOR SELECT
  TO app_anonym
  USING ( true );

--

CREATE TRIGGER posts_notify AFTER INSERT OR UPDATE OR DELETE ON data.posts
FOR EACH ROW EXECUTE PROCEDURE notify_trigger (
  'id'
);
