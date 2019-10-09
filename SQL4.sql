use `mytest1`;


/*
11. Write a query to send Message from particular User to another User(Use Message table - insert statement).
12. Write a query to send Message from particular User to particular Circle(Use Message table - insert statement)
13. Write a query to delete particular Message which you received from User(User Inbox table - delete statement)
14. Write a query to delete particular Message which you received from particular Circle(User Inbox table - delete statement)

*/

/*
11. Write a query to send Message from particular User to another User(Use Message table - insert statement).
*/
insert into mytest1.message_info (message,received_date_time,sender_id,receiver_id,iscircle) 
values 
('ONE TO   ONE   MESSAGE',NOW(),3,2,false);

/*
12. Write a query to send Message from particular User to particular Circle(Use Message table - insert statement)
Message sent to Circle , inturn through triggers , all the users who are subscribed or unsubscribed to that cirlce will receive emails from the circle. 
*/
insert into mytest1.message_info (message,received_date_time,sender_id,receiver_id,iscircle) 
values 
('first group ?? ',NOW(),1,3,true);



