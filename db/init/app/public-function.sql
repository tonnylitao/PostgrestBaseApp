set search_path to public;

create function is_group_admin(group_id integer) returns boolean as $$
begin
  return exists(select id from data.groups where "user_id" = app_user_id());
end;
$$ language plpgsql;
revoke all privileges on function is_group_admin(integer) from public;
