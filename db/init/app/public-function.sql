set search_path to public;

create function is_group_admin(table_name text, id integer) returns boolean as $$
begin
  if table_name = 'group' then
    return exists(select id from data.groups where user_id=request.user_id());
  elsif table_name = 'posts' then
    return exists(
      select id from data.groups as a
        inner join data.posts as b
          on b.id = $2 and a.id = b.group_id
      where a.user_id = request.user_id()
    );
  end if;
end;
$$ language plpgsql;
revoke all privileges on function is_group_admin(text, integer) from public;

grant execute on function public.is_group_admin(text, integer) to app_user; --RLS session user
grant execute on function public.is_group_admin(text, integer) to app_admin; --RLS session user, policy2 or policy1 
