set search_path to public;

create function rls_select(table_name text, using_expression text default 'true', role text default 'public') returns void as $$
begin
  if role = 'public' then
    execute format('create policy %1$s_select_%3$s on data.%1$s
      for select
      to public
      using ( %2$s )', $1, $2, $3);
  else
    execute format('create policy %1$s_select_%3$s on data.%1$s
      for select
      to view_owner
      using ( request.role()=%3$L and ( %2$s ) )', $1, $2, $3);
  end if;
end;
$$ language plpgsql;
revoke all privileges on function rls_select(text, text, text) from public;

--
create function rls_insert(table_name text, check_expression text default 'true', role text default 'public') returns void as $$
begin
  if role = 'public' then
    execute format('create policy %1$s_insert_%3$s on data.%1$s
      for insert
      to public
      with check ( %2$s )', $1, $2, $3);
  else
    --session user
    if exists (SELECT 0 FROM pg_class where relname = table_name || '_id_seq') then
      execute format('grant usage, select on sequence data.%1$s_id_seq to %2$s', $1, $3);
    end if;

    execute format('create policy %1$s_insert_%3$s on data.%1$s
      for insert
      to view_owner
      with check ( request.role()=%3$L and ( %2$s ) )', $1, $2, $3);
  end if;
end;
$$ language plpgsql;
revoke all privileges on function rls_insert(text, text, text) from public;

--
create function rls_update(table_name text, using_expression text default 'true', role text default 'public') returns void as $$
begin
  if role = 'public' then
    execute format('create policy %1$s_update_%3$s on data.%1$s
      for update
      to public
      using ( %2$s )', $1, $2, $3);
  else
    execute format('create policy %1$s_update_%3$s on data.%1$s
      for update
      to view_owner
      using ( request.role()=%3$L and ( %2$s ) )', $1, $2, $3);
  end if;
end;
$$ language plpgsql;
revoke all privileges on function rls_update(text, text, text) from public;

--
create function rls_delete(table_name text, using_expression text default 'true', role text default 'public') returns void as $$
begin
  if role = 'public' then
    execute format('create policy %1$s_delete_%3$s on data.%1$s
      for delete
      to public
      using ( %2$s )', $1, $2, $3);
  else
    execute format('create policy %1$s_delete_%3$s on data.%1$s
      for delete
      to view_owner
      using ( request.role()=%3$L and ( %2$s ) )', $1, $2, $3);
  end if;
end;
$$ language plpgsql;
revoke all privileges on function rls_delete(text, text, text) from public;
