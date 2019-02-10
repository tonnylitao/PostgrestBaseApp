set search_path to api, public;

-- schema api
create view api.users as
	select id, created_at, updated_at, name, email, role from data.users;

-- Row Security Policies :: view -> view's owner -> table
alter view api.users owner to view_owner;
grant select, insert, update, delete on data.users to view_owner;

-- restful api
revoke all on api.users from public;

select public.rest_get('users');

select app_user.rest_patch('users', '(name)');
