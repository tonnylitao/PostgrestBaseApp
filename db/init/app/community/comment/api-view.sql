set search_path to api, public;

-- schema api
create or replace view api.comments as
  select * from data.comments;

-- restful api
revoke all on api.comments from public;

select public.rest_get('comments');
select app_user.rest_post('comments');
select app_user.rest_patch('comments');
select app_user.rest_delete('comments');
select app_admin.rest_delete('comments');
