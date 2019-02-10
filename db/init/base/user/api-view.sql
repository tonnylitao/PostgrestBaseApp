set search_path to api, public;

-- schema api
create view api.users as
	select id, created_at, updated_at, name, role from data.users;

-- Row Security Policies :: view -> view's owner -> table
alter view api.users owner to view_owner;
grant select, insert, update on data.users to view_owner;

-- restful api
revoke all on api.users from public;

select public.rest_get('users');




-- me
create view api.me as
	select id, created_at, updated_at, name, email, role from data.users
	where id = request.user_id() and role = request.role()::public.user_role
	with local check option;

-- Row Security Policies :: view -> view's owner -> table
alter view api.me owner to view_owner;

-- restful api
revoke all on api.me from public;

select app_user.rest_get('me');
select app_admin.rest_get('me');

select app_user.rest_patch('me', '(name)');
select app_admin.rest_patch('me', '(name)');
