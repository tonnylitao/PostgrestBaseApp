set search_path to public;

--
create function rest_get(view text, columns text default '', role text default 'public') returns void as $$
begin
  execute 'grant select '|| columns ||' on api.' || quote_ident(view) || ' to ' || quote_ident(role);
end;
$$ language plpgsql;
revoke all privileges on function rest_get(text, text, text) from public;

--
create function rest_post(view text, columns text default '', role text default 'public') returns void as $$
begin
  execute 'grant insert '|| columns ||' on api.' || quote_ident(view) || ' to ' || quote_ident(role);
end;
$$ language plpgsql;
revoke all privileges on function rest_post(text, text, text) from public;

--
create function rest_patch(view text, columns text default '', role text default 'public') returns void as $$
begin
   execute 'grant update ' || columns || ' on api.' || quote_ident(view) || ' to ' || quote_ident(role);
end;
$$ language plpgsql;
revoke all privileges on function rest_patch(text, text, text) from public;

--
create function rest_delete(view text, role text default 'public') returns void as $$
begin
   execute 'grant delete on api.' || quote_ident(view) || ' to ' || quote_ident(role);
end;
$$ language plpgsql;
revoke all privileges on function rest_delete(text, text) from public;
