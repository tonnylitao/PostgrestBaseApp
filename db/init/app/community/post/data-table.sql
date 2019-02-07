set search_path to data, public;

-- Posts
CREATE TABLE IF NOT EXISTS data.posts (
	id                   serial primary key,
	created_at					 timestamptz not null default now(),
	updated_at					 timestamptz not null default now(),

	title                text not null,
  body                 text,
	user_id              int references data.users(id) default public.app_user_id(),
	group_id             int references data.groups(id)
);
CREATE INDEX IF NOT EXISTS "data.posts_user_id_index" on data.posts(user_id);
CREATE INDEX IF NOT EXISTS "data.posts_group_id_index" on data.posts(group_id);

-- Row level policy
ALTER TABLE data.posts ENABLE ROW LEVEL SECURITY;

select create_row_policy(array['public'], 'select', 'posts', 'true');
select create_row_policy(array['app_user', 'app_admin'], 'insert', 'posts', '');
select create_row_policy(array['app_user', 'app_admin'], 'update', 'posts', 'user_id = app_user_id()');
select create_row_policy(array['app_user'], 'delete', 'posts', 'user_id = app_user_id()');
select create_row_policy(array['app_admin'], 'delete', 'posts', 'true');

-- notify

CREATE TRIGGER posts_notify AFTER INSERT OR UPDATE OR DELETE ON data.posts
FOR EACH ROW EXECUTE PROCEDURE data.notify_trigger (
  'id'
);
