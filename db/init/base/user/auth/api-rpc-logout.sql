-- drop function api.logout(text,text);
create function api.logout() returns void as $$
begin
  set local "response.headers" = '[{"set-cookie": "access_token=; path=/; max-age=0"}]';
end;
$$ language plpgsql;

revoke all privileges on function api.logout() from public;
grant execute on function api.logout() to app_admin;
grant execute on function api.logout() to app_user;
