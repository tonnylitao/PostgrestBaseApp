set search_path to api, public;

-- schema api
create or replace view api.comments as
  select * from data.comments;

-- Row Security Policies :: view -> view's owner -> table
alter view api.comments owner to view_owner;
grant select, insert, update, delete on data.comments to view_owner;

-- restful api
revoke all on api.comments from public;

select public.rest_get('comments');

select app_user.rest_post('comments');

select app_user.rest_patch('comments', '(body)');

select app_user.rest_delete('comments');
select app_admin.rest_delete('comments');
