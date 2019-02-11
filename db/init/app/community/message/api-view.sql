set search_path to api, public;

-- /api/messages
create or replace view api.messages as
  select * from data.messages order by id desc;

-- Row Security Policies :: view -> view's owner -> table
alter view api.messages owner to view_owner;
grant select, insert, update, delete on data.messages to view_owner;

-- restful api
revoke all on api.messages from public;

select app_user.rest_get('messages');

select app_user.rest_post('messages', '(body, to_id)');

select app_user.rest_delete('messages');
