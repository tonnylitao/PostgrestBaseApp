set search_path to data, public;

-- Posts
CREATE TABLE IF NOT EXISTS data.posts (
	id                   serial primary key,
	title                text not null,
  body                 text,
	user_id              int references data.users(id),
	company_id           int references data.companies(id) default public.app_company_id()
);
CREATE INDEX IF NOT EXISTS "data.posts_company_id_index" on data.posts(company_id);

-- Row level policy
ALTER TABLE data.posts ENABLE ROW LEVEL SECURITY;

CREATE POLICY posts_admin_SIUD ON data.posts TO app_admin
  USING ( company_id = app_company_id() );

CREATE POLICY posts_user_SIUD ON data.posts TO app_user
  USING ( user_id = app_user_id() );

CREATE POLICY posts_anonym_S ON data.posts
  FOR SELECT
  TO app_anonym
  USING ( true );
