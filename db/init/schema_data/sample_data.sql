insert into data.companies( id, name ) values
( 1, 'Dunder Mifflin'),
( 2, 'Wernham Hogg');

insert into data.users( id, name, email, "password", role, company_id ) values
( 1, 'Michael Scott', '1@admin.com', 'pass', 'app_admin', 1),
( 2, 'Dwight Schrute', '2@user.com', 'pass', 'app_user', 1),
( 3, 'Jim Halpert', '3@user.com', 'pass', 'app_user', 1);

insert into data.posts( id, title, body, user_id, company_id ) values
( 1, 'Microsoft', 'Redmond', 1, 1 ),
( 2, 'Oracle', 'Redwood Shores', 1, 2 ),
( 3, 'Apple', 'Cupertino', 2, 2 );
