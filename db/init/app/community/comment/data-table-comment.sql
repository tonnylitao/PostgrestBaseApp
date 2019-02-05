set search_path to data, public;

-- Posts
CREATE TABLE IF NOT EXISTS data.comments (
	id                   serial primary key,
	created_at					 timestamptz not null default now(),
	updated_at					 timestamptz not null default now(),

  body                 text,
	user_id              int references data.users(id) default public.app_user_id(),
	post_id          		 int references data.posts(id) default public.app_post_id()
);
CREATE INDEX IF NOT EXISTS "data.comments_post_id_index" on data.comments(post_id);

-- Row level policy
ALTER TABLE data.comments ENABLE ROW LEVEL SECURITY;

CREATE POLICY comments_user_SIUD ON data.comments TO app_user
  USING ( user_id = app_user_id() );

CREATE POLICY comments_user_SIUD ON data.comments TO app_admin
  USING ( user_id = app_user_id() );

CREATE POLICY comments_anonym_S ON data.comments
  FOR SELECT
  TO app_anonym
  USING ( true );

--

CREATE TRIGGER comments_notify AFTER INSERT OR UPDATE OR DELETE ON data.comments
FOR EACH ROW EXECUTE PROCEDURE notify_trigger (
  'id'
);
