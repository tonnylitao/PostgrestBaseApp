set search_path to api, public;

-- schema api
create or replace view api.comments as
select id, body, user_id, group_id from data.comments
with local check option;

-- ROLE
GRANT SELECT ON api.comments TO public;

GRANT INSERT ON api.comments TO app_admin, app_user;

GRANT UPDATE ON api.comments TO app_admin, app_user;
