set search_path to api, public;

-- schema api
create or replace view api.users as
	select id,name,email,role, group_id from data.users;
