set search_path to data, public;

create table data.settings (
	key    text primary key,
	value  text not null
);

create or replace function data.getSetting(text) returns text as $$
    select value from data.settings where key = $1
$$ security definer stable language sql;

create or replace function data.setSetting(text, text) returns void as $$
	insert into data.settings (key, value) values ($1, $2)
		on conflict (key) do update set value = $2;
$$ security definer language sql;
