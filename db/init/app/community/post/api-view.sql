set search_path to api, public;

-- schema api
create or replace view api.posts as
  select * from data.posts;

-- restful api
revoke all on api.posts from public;

select create_rest(array['public'], 'GET', 'posts');
select create_rest(array['app_user', 'app_admin'], 'POST', 'posts');
select create_rest(array['app_user', 'app_admin'], 'PATCH', 'posts');
select create_rest(array['app_user', 'app_admin'], 'DELETE', 'posts');
