set search_path to api, public;

-- schema api
create or replace view api.usergroups as
	select * from data.usergroups;

-- Row Security Policies :: view -> view's owner -> table
alter view api.usergroups owner to view_owner;
grant select, insert, update, delete on data.usergroups to view_owner;

-- restful api
revoke all on api.usergroups from public;

select public.rest_get('usergroups');
select app_user.rest_post('usergroups');
select app_user.rest_delete('usergroups');
