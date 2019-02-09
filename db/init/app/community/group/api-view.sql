set search_path to api, public;

-- schema api
create or replace view api.groups as
	select * from data.groups;

-- Row Security Policies :: view -> view's owner -> table
alter view api.groups owner to view_owner;
grant select, insert, update, delete on data.groups to view_owner;

-- restful api
revoke all on api.groups from public;

select public.rest_get('groups');

select app_user.rest_post('groups');

select app_user.rest_patch('groups');

select app_user.rest_delete('groups');
select app_admin.rest_delete('groups');
