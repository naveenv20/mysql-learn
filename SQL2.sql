use `mytest1`;
/*
2. Insert the rows into the created tables (User, Circle, User_Circle, and Messages).
3. Fetch the row from User table based on Id and Password.
4. Fetch all the rows from Circle table based on the field created_by.
5. Fetch all the Circles created after the particular Date.
6. Fetch all the User Ids from UserCircle table subscribed to particular Circle.
7. Write upDate query to unsubscribe to particular Circle for the given User Id.
8. Fetch all the Messages from the Messages table sent by a particular User.
9. Fetch all the Messages from the Messages table received by a particular User.
10. Fetch all the Messages from the Messages table sent/received by a particular User. (both the Messages)
11. Write a query to send Message from particular User to another User(Use Message table - insert statement).
12. Write a query to send Message from particular User to particular Circle(Use Message table - insert statement)
13. Write a query to delete particular Message which you received from User(User Inbox table - delete statement)
14. Write a query to delete particular Message which you received from particular Circle(User Inbox table - delete statement)
*/



/*
 2. Insert the rows into the created tables (User, Circle, User_Circle, and Messages)
*/

insert into  mytest1.user_info (firstname,lastname,password,userid)
values 
('Chris','Mathew','pass1','m123')
,('Mary','Holt','pass2','m124')
,('John','Riggi','pass3','m125');

--
insert into mytest1.circle (createdby,created_date_time,circle_name) 
values 
(1,NOW(),'COMEDY')
,(1,'2018-11-08','ACTION')
,(2,'2018-09-08','SPORTS')
,(3,'2018-10-08','NATURE')
;

--
insert into mytest1.user_circle (circle_id,user_id,subscribe) values (1,1,TRUE),(1,2,TRUE),(2,2,TRUE),(2,3,TRUE),(3,1,FALSE),(3,2,TRUE),(3,3,TRUE);
--

insert into mytest1.message_info (message,received_date_time,sender_id,receiver_id,iscircle) 
values 
('Hello how are you ?? ',NOW(),1,2,false)
,('HOWDY you there!!!','2018-10-08',2,3,false)
,('WHATSUP !!!!','2018-09-08',2,1,false)
,('Learning goos stuff','2019-10-08',1,3,false);



/*
3.Fetch the row from User table based on Id and Password
*/
select * from user_info where userid='m123' and password='pass1';




/*
4. Fetch all the rows from Circle table based on the field created_by.
*/
select c.circle_name, concat(u.firstname,' ',u.lastname)as 'User_Created' ,c.created_date_time ,u.userid
from circle c inner join user_info u 
on c.createdby=u.id
where u.firstname = 'Chris' and u.lastname='Mathew'
-- where u.userid='m123'
;

/*
5. Fetch all the Circles created after the particular Date.
*/
select c.*  
from circle c 
where c.created_date_time >= '2018-11-01'
;

/*
6. Fetch all the User Ids from UserCircle table subscribed to particular Circle.
*/
select concat(u.firstname,' ',u.lastname)as 'User_Name', c.circle_name, uc.subscribe
from user_circle uc inner join user_info u inner join circle c
on uc.user_id=u.id and  uc.circle_id=c.id
where 
uc.subscribe in(true)
and 
uc.circle_id in (3)
;

/*
7. Write upDate query to unsubscribe to particular Circle for the given User Id.

*/
SET SQL_SAFE_UPDATES=0;

update user_circle uc
set uc.subscribe=false
-- select uc.* from user_circle uc
where
uc.user_id in ( select id from user_info u where u.firstname='John' and u.lastname='Riggi')
-- uc.user_id in ( select id from user_info u where u.userid='m123')
and uc.circle_id in ( select id from circle c where c.circle_name='ACTION')
;




