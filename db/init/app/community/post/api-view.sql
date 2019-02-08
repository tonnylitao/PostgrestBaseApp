set search_path to api, public;

-- schema api
create or replace view api.posts as
  select * from data.posts;

-- restful api
revoke all on api.posts from public;

select public.rest_get('posts');
select app_user.rest_post('posts');
select app_user.rest_patch('posts');
select app_user.rest_delete('posts');
select app_admin.rest_delete('posts');
