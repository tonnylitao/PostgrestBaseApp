set search_path to api, public;

-- schema api
create view api.users as
	select id,name,email,role from data.users;

-- role privilege
grant select on api.users to public; --public get

grant update on api.users to app_user; --user patch

grant insert on api.users to app_admin; --admin post
grant update on api.users to app_admin; --admin patch




-- schema api
create or replace view api.users_only_get as -- api不支持post, 因为password不能为空
	select id, name, email, role from data.users;

-- role privilege
grant select on api.users_only_get to public;

-- schema api
create or replace view api.users_only_admin_get as
	select * from data.users;

-- role privilege
grant select on api.users_only_admin_get to app_admin;
