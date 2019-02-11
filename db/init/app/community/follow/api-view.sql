set search_path to api, public;

-- /api/follows
create or replace view api.follows as
  select * from data.follows order by id desc;

-- Row Security Policies :: view -> view's owner -> table
alter view api.follows owner to view_owner;
grant select, insert, update, delete on data.follows to view_owner;

-- restful api
revoke all on api.follows from public;

select app_user.rest_get('follows');

select app_user.rest_post('follows', '(to_id)');

select app_user.rest_delete('follows');
