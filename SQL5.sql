
use `mytest1`;

/*


13. Write a query to delete particular Message which you received from User(User Inbox table - delete statement)
14. Write a query to delete particular Message which you received from particular Circle(User Inbox table - delete statement)
*/


/*
13. Write a query to delete particular Message which you received from User(User Inbox table - delete statement)
*/
delete from user_inbox  
where  
receiver_id in  ( select id from user_info where userid='m125')
and 
sender_id in (select id from user_info where userid='m124')
;


/*
14. Write a query to delete particular Message which you received from particular Circle(User Inbox table - delete statement)
*/
delete from user_inbox  
where  
receiver_id in  ( select id from user_info where userid='m125')
and 
sender_id in (select id from circle where circle_name='SPORTS')
and 
iscircle=true
;

