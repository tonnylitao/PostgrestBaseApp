set search_path to api, public;

-- schema api
create or replace view api.groups as
	select * from data.groups;

-- restful api
revoke all on api.groups from public;

select create_rest(array['public'], 'GET', 'groups');
select create_rest(array['app_user','app_admin'], 'POST', 'groups');
select create_rest(array['app_user','app_admin'], 'PATCH', 'groups');
select create_rest(array['app_user','app_admin'], 'DELETE', 'groups');
