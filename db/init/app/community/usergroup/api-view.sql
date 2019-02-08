set search_path to api, public;

-- schema api
create or replace view api.usergroups as
	select * from data.usergroups;

-- restful api
revoke all on api.usergroups from public;

select public.rest_get('usergroups');
select app_user.rest_post('usergroups');
