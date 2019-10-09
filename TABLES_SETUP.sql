DROP SCHEMA IF EXISTS `mytest1`;

CREATE SCHEMA `mytest1`;

use `mytest1`;

SET FOREIGN_KEY_CHECKS = 0;

/*
****** USER TABLE*****
*/

DROP TABLE IF EXISTS `user_info`;

CREATE TABLE `user_info` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `firstname` varchar(128) DEFAULT NULL,
  `lastname` varchar(128) DEFAULT NULL,
  `password` varchar(128) DEFAULT NULL,
 `userid` varchar(128) NOT NULL UNIQUE,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;



/*
****** MESSAGE TABLE*****
*/
DROP TABLE IF EXISTS `message_info`;

CREATE TABLE `message_info` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `message` varchar(256) DEFAULT NULL,
  `received_date_time` DATE ,
  `sender_id` int(11) NOT NULL,
  `receiver_id` int(11) NOT NULL,
	`iscircle`	boolean NOT NULL,
 
  PRIMARY KEY (`id`)

,
  KEY `sender_key` (`sender_id`),
  CONSTRAINT `fk_sender` FOREIGN KEY (`sender_id`) 
  REFERENCES `user_info` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION 
 
  
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;



/*
****** CIRCLE TABLE*****
*/
DROP TABLE IF EXISTS `circle`;

CREATE TABLE `circle` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `createdby` int(11) NOT NULL,
  `created_date_time` DATE,
  `circle_name` varchar(128) DEFAULT NULL,
  PRIMARY KEY (`id`),
  
  KEY `createdby_key` (`createdby`),
  CONSTRAINT `fk_createdby` FOREIGN KEY (`createdby`) 
  REFERENCES `user_info` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
  
  
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;


/*
****** USERCIRCLE TABLE*****
*/

DROP TABLE IF EXISTS `user_circle`;

CREATE TABLE `user_circle` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `circle_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `subscribe` boolean NOT NULL,
  
  PRIMARY KEY (`id`),
  
  KEY `user_key` (`user_id`),
  CONSTRAINT `fk_user` FOREIGN KEY (`user_id`) 
  REFERENCES `user_info` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  
  KEY `circle_key` (`circle_id`),
  CONSTRAINT `fk_circle` FOREIGN KEY (`circle_id`) 
  REFERENCES `circle` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
  
  
  
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;


/*
****** USERINBOX TABLE*****
*/

DROP TABLE IF EXISTS `user_inbox`;
CREATE TABLE `user_inbox` (
 `id` int(11) NOT NULL AUTO_INCREMENT,
  `message` varchar(256) DEFAULT NULL,
  `received_date_time` DATE ,
  `sender_id` int(11) NOT NULL,
  `receiver_id` int(11) NOT NULL,
  `iscircle`	boolean NOT NULL,

  
  PRIMARY KEY (`id`)


  
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;




/*
PROCEDURE FOR INSERTING RECORD INTO MESSAGE TABLE --USED BY TRIGGER 

*/
DROP PROCEDURE  IF EXISTS `testProc`;
DELIMITER $$

CREATE PROCEDURE testProc( 
IN receiver_id_i int,
IN message_i VARCHAR(256),
IN sender_id_i INT, 
IN received_date_time_i DATE,
IN iscircle_i boolean) 
begin

INSERT INTO user_inbox
 SET receiver_id =receiver_id_i,
    message=message_i,
	received_date_time= received_date_time_i,
	sender_id = sender_id_i,
	iscircle =iscircle_i;
end $$
DELIMITER ;


/*
INCASE OF MESSAGE SENT TO CIRCLE--ALL THE MEMBERS OF THE CIRCLE WILL GET MESSAGE INSERTED --FUNCTION FOR THAT--USED BY TRIGGER
 

*/


DROP PROCEDURE  IF EXISTS `foo`;

DELIMITER $$

CREATE PROCEDURE foo(
IN receiver_id_i int,
IN message_i VARCHAR(256),
IN sender_id_i INT, 
IN received_date_time_i DATE,
IN iscircle_i boolean
) BEGIN
  DECLARE done BOOLEAN DEFAULT false;
  DECLARE _id BIGINT UNSIGNED;
  DECLARE cur CURSOR FOR select user_id from user_circle  where circle_id =receiver_id_i;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done := TRUE;

  OPEN cur;

  testLoop: LOOP
    FETCH cur INTO _id;
    IF done THEN
      LEAVE testLoop;
    END IF;
    CALL testProc(_id,message_i,receiver_id_i,received_date_time_i,iscircle_i);
  END LOOP testLoop;

  CLOSE cur;
END$$

DELIMITER ;

/*
TRIGGER -- WHEN USER INSERTS RECORD IN MESSAGE TABLE--TRIGGER WILL INSERT DATA INTO USER_INBOX TABLE--BOTH FOR PERSON MESSAGE AND CIRCLE MESSAGE

*/

DROP TRIGGER  IF EXISTS `before_message_info_insert`;
DELIMITER $$

CREATE TRIGGER before_message_info_insert 
    AFTER INSERT ON message_info
    FOR EACH ROW begin
IF(NEW.iscircle is false) THEN
CALL testProc(NEW.receiver_id,NEW.message,NEW.sender_id,NEW.received_date_time,NEW.iscircle);
else
CALL foo(NEW.receiver_id,NEW.message,NEW.sender_id,NEW.received_date_time,NEW.iscircle);

END IF;
END $$
DELIMITER ;


SET FOREIGN_KEY_CHECKS = 1;












