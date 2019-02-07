insert into data.users( id, name, email, "password", role) values
( 1, 'Michael Scott', '1@admin.com', 'pass', 'app_admin'),
( 2, 'Dwight Schrute', '2@user.com', 'pass', 'app_user'),
( 3, 'Jim Halpert', '3@user.com', 'pass', 'app_user');

insert into data.groups( id, name, user_id ) values
( 1, 'Dunder Mifflin', 1),
( 2, 'Wernham Hogg', 2);

update data.users set group_id=1 where id=1;
update data.users set group_id=2 where id=2;

insert into data.posts( id, title, body, user_id, group_id ) values
( 1, 'Microsoft', 'Redmond', 1, 1 ),
( 2, 'Oracle', 'Redwood Shores', 1, 2 ),
( 3, 'Apple', 'Cupertino', 2, 2 );
