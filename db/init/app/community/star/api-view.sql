set search_path to api, public;

-- /api/stars
create or replace view api.stars as
  select * from data.stars order by id desc;

-- Row Security Policies :: view -> view's owner -> table
alter view api.stars owner to view_owner;
grant select, insert, update, delete on data.stars to view_owner;

-- restful api
revoke all on api.stars from public;

select public.rest_get('stars');

select app_user.rest_post('stars');

select app_user.rest_delete('stars');
