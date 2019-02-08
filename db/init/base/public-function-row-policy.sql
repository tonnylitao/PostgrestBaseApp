set search_path to public;

create function rlp_select(table_name text, using_expression text default 'true', role text default 'public') returns void as $$
begin
  execute format('create policy %1$s_%3$s_select on data.%1$s
    for select
    to %3$s
    using ( %2$s );', $1, $2, $3);
end;
$$ language plpgsql;
revoke all privileges on function rlp_select(text, text, text) from public;

--
create function rlp_insert(table_name text, check_expression text default 'true', role text default 'public') returns void as $$
begin
  execute format('create policy %1$s_%3$s_insert on data.%1$s
    for insert
    to %3$s
    with check ( %2$s );', $1, $2, $3);
end;
$$ language plpgsql;
revoke all privileges on function rlp_insert(text, text, text) from public;

--
create function rlp_update(table_name text, using_expression text default 'true', role text default 'public') returns void as $$
begin
  execute format('create policy %1$s_%3$s_update on data.%1$s
    for update
    to %3$s
    using ( %2$s );', $1, $2, $3);
end;
$$ language plpgsql;
revoke all privileges on function rlp_update(text, text, text) from public;

--
create function rlp_delete(table_name text, using_expression text default 'true', role text default 'public') returns void as $$
begin
  execute format('create policy %1$s_%3$s_delete on data.%1$s
    for delete
    to %3$s
    using ( %2$s );', $1, $2, $3);
end;
$$ language plpgsql;
revoke all privileges on function rlp_delete(text, text, text) from public;
