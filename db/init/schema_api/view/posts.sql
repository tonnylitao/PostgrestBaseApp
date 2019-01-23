set search_path to api, public;

-- schema api
create or replace view api.posts as
select id, title, body, user_id, company_id from data.posts
with local check option;

-- ROLE
GRANT SELECT ON api.posts TO public;

GRANT INSERT ON api.posts TO app_admin, app_user;

GRANT UPDATE ON api.posts TO app_admin, app_user;
