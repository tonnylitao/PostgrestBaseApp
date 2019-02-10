set search_path to api, public;

-- schema api
create or replace view api.posts as
  select * from data.posts;

-- Row Security Policies :: view -> view's owner -> table
alter view api.posts owner to view_owner;
grant select, insert, update, delete on data.posts to view_owner;

-- restful api
revoke all on api.posts from public;

-- GET
select public.rest_get('posts');

-- POST
select app_user.rest_post('posts');

-- PATCH
select app_user.rest_patch('posts', '(title, body)');

-- DELETE
select app_user.rest_delete('posts');
select app_admin.rest_delete('posts');
