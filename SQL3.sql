use `mytest1`;

/*
8. Fetch all the Messages from the Messages table sent by a particular User.
9. Fetch all the Messages from the Messages table received by a particular User.
10. Fetch all the Messages from the Messages table sent/received by a particular User. (both the Messages)
11. Write a query to send Message from particular User to another User(Use Message table - insert statement).
12. Write a query to send Message from particular User to particular Circle(Use Message table - insert statement)
13. Write a query to delete particular Message which you received from User(User Inbox table - delete statement)
14. Write a query to delete particular Message which you received from particular Circle(User Inbox table - delete statement)
*/

/*
8. Fetch all the Messages from the Messages table sent by a particular User.
*/
select m.message, concat(u.firstname,' ',u.lastname)as 'User_Created' 
from message_info m inner join user_info u 
on m.sender_id=u.id
where u.firstname = 'Chris' and u.lastname='Mathew'
-- where u.userid='m123'
;

/*
9. Fetch all the Messages from the Messages table received by a particular User.
ignoring  messages send to a circle, we can get that info in user_inbox table
*/
select m.message, concat(u.firstname,' ',u.lastname)as 'User_Received' 
from message_info m inner join user_info u 
on m.receiver_id=u.id
where u.firstname ='Chris' and  u.lastname='Mathew' and m.iscircle=false
-- where u.userid='m123'
;


/*
10. Fetch all the Messages from the Messages table sent/received by a particular User. (both the Messages)
ignoring  messages send to a circle, we can get that info in user_inbox table
*/
SET @VAR1='Chris';
SET @VAR2='Mathew';

select m.message , concat(u.firstname,' ',u.lastname)as 'User'
from message_info m inner join  user_info u
on 
m.sender_id=u.id 
where
m.sender_id in ( select id from user_info where firstname = (@VAR1) and lastname=@VAR2) 
union
select m.message , concat(u.firstname,' ',u.lastname)as 'User'
from message_info m inner join  user_info u
on 
m.receiver_id=u.id 
where
m.receiver_id in ( select id from user_info where firstname = (@VAR1))  and lastname=@VAR2 and m.iscircle =false;
