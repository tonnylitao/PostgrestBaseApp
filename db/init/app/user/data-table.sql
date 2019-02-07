set search_path to data, public;

alter table data.users add column
  group_id int references data.groups(id) default public.app_group_id();

create index if not exists "data.users_group_id_index" on data.users(group_id);

ALTER TABLE data.users ENABLE ROW LEVEL SECURITY;

select create_row_policy(array['public'], 'select', 'users', 'true');
select create_row_policy(array['app_anonym'], 'insert', 'users', '');
select create_row_policy(array['app_user', 'app_admin'], 'update', 'users', 'id = app_user_id()');

-- notify

CREATE TRIGGER users_notify AFTER INSERT OR UPDATE OR DELETE ON data.users
FOR EACH ROW EXECUTE PROCEDURE data.notify_trigger (
  'id'
);
