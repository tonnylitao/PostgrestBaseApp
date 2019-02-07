set search_path to api, public;

-- schema api
create or replace view api.users as
	select id,name,email,role, group_id from data.users;

revoke all on api.users from public;

select create_rest(array['public'], 'GET', 'users');
select create_rest(array['app_anonym'], 'POST', 'users');
select create_rest(array['app_user', 'app_admin'], 'PATCH', 'users');
