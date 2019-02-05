set search_path to api, public;

-- schema api
create or replace view api.groups as
	select * from data.groups;

-- Role
revoke all on api.groups from public;
grant select on api.groups TO public; --only view, not data

grant insert, update on api.groups TO app_admin;

grant delete on api.groups TO app_admin;
