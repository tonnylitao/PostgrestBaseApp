set search_path to api, public;

-- schema api
create view api.users as
	select id,name,email,role from data.users;

-- Role privilege
GRANT SELECT ON api.users TO public; --public GET

GRANT UPDATE ON api.users TO app_user; --user PATCH

GRANT INSERT ON api.users TO app_admin; --admin POST
GRANT UPDATE ON api.users TO app_admin; --admin PATCH




-- schema api
create or replace view api.users_only_get as -- api不支持post, 因为password不能为空
	select id, name, email, role from data.users;

-- Role privilege
GRANT SELECT ON api.users_only_get TO public;

-- schema api
create or replace view api.users_only_admin_get as
	select * from data.users;

-- Role privilege
GRANT SELECT ON api.users_only_admin_get TO app_admin;
