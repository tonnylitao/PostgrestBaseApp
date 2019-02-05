set search_path to data, public;

-- Posts
CREATE TABLE IF NOT EXISTS data.follows (
	id                   serial primary key,
	created_at					 timestamptz not null default now(),

	follower_id          int references data.users(id) default public.app_user_id(),
	following_id         int references data.users(id)
);
CREATE INDEX IF NOT EXISTS "data.follows_follower_id_index" on data.follows(follower_id);
CREATE INDEX IF NOT EXISTS "data.follows_following_id_index" on data.follows(following_id);

-- Row level policy
ALTER TABLE data.follows ENABLE ROW LEVEL SECURITY;

CREATE POLICY follows_admin_SIUD ON data.follows TO app_admin
  USING ( group_id = app_group_id() );

CREATE POLICY follows_user_SIUD ON data.follows TO app_user
  USING ( user_id = app_user_id() );

CREATE POLICY follows_anonym_S ON data.follows
  FOR SELECT
  TO app_anonym
  USING ( true );

--

CREATE TRIGGER follows_notify AFTER INSERT OR UPDATE OR DELETE ON data.follows
FOR EACH ROW EXECUTE PROCEDURE notify_trigger (
  'id'
);
