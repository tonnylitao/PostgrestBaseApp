set search_path to api, public;

-- schema api
create or replace view api.follows as
select id, title, body, user_id, group_id from data.follows
with local check option;

-- ROLE
GRANT SELECT ON api.follows TO public;

GRANT INSERT ON api.follows TO app_admin, app_user;

GRANT UPDATE ON api.follows TO app_admin, app_user;
