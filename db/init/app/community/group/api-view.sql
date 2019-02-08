set search_path to api, public;

-- schema api
create or replace view api.groups as
	select * from data.groups;

-- restful api
revoke all on api.groups from public;

select public.rest_get('groups');
select app_user.rest_post('groups');
select app_user.rest_patch('groups');
select app_user.rest_delete('groups');
select app_admin.rest_delete('groups');
