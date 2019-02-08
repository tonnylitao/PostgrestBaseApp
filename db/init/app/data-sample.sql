insert into data.users( id, name, email, "password", role) values
( 1, 'James Andrews', 'james@app.com', 'pass', 'app_admin'),
( 2, 'George Abbot', 'george@app.com', 'pass', 'app_user'),
( 3, 'Heston Blumenthal', 'heston@app.com', 'pass', 'app_admin');

insert into data.groups( id, name, user_id ) values
( 1, 'Art', 1),
( 2, 'Cook', 2);

-- update data.users set group_id=1 where id=1;
-- update data.users set group_id=2 where id=1;
-- update data.users set group_id=3 where id=2;

insert into data.posts( title, body, user_id, group_id ) values
( 'The Sentiment of Flowers', 'This colorful Victorian book evokes an age gone by, before the days of email and overnight shipping, when communication between people was a very special occasion, made more difficult by time and space. To Victorian letter-writers of the West a new, exotic and secret language came from the East-communicating through flowers. The language of flowers became so refined in the nineteenth century that this dictionary was necessary. Using this source, one could send a message of reproach, passion, friendship, quarrel or a myriad of other sentiments singly and combined via a simple bouquet without ever penning a single word.', 1, 1),
( 'The Fat Duck', 'Blumenthal owns the restaurant Dinner in London, which has two Michelin stars, and two pubs in Bray, The Crown at Bray and The Hinds Head, which has one Michelin star. He invented recipes for triple-cooked chips and soft-centred Scotch eggs.', 3, 2),
( 'Archbishop of Canterbury', 'The register agrees in every particular with what we know of the history of the times, and there exists not the semblance of a reason for pronouncing it a forgery', 2, 1);
