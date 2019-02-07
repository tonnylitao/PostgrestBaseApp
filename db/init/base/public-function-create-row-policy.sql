set search_path to public;

create function create_row_policy(roles text[], command text, table_name text,
  using_expression text) returns void as $$

declare r record;
begin
  for r in
     select unnest(roles) as name
  loop

    if command = 'insert' then
      execute 'create policy '|| quote_ident(table_name) || quote_ident(r.name) || command
      || ' on data.' || quote_ident(table_name)
      || ' for ' || command
      || ' to ' || quote_ident(r.name);
    else
      execute 'create policy '|| quote_ident(table_name) || quote_ident(r.name) || command
      || ' on data.' || quote_ident(table_name)
      || ' for ' || command
      || ' to ' || quote_ident(r.name)
      || ' using ( ' || using_expression || ' )';
    end if;
  end loop;

end;
$$  language plpgsql;

revoke all privileges on function create_row_policy(text[],text,text,text) from public;
