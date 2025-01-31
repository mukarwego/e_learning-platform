-- 2409001023_e_learning platform
show databases;
create database e_learning_platform;
use e_learning_platform;
-- creation of table users
create table users(userid int primary key,
firstname varchar(50),
lastname varchar(50),
email varchar(100));

-- creation of table course
create table course(courseid int primary key,
coursename varchar(50)not null,
coursedescription text,
courseduration int);

-- creation of table modules

create table modules(moduleid int primary key,
moduletitle varchar(50),
modulediscription varchar(100),
modulecantent int,
courseid int,
foreign key(courseid) references course(courseid));
show tables;
insert into users(userid,firstname,lastname,email)values
(1,'sabine','ishimwe','sabine@gmail.com'),
(2,'aline','irambona','aline@gmail.com');
select*from users;

insert into course(courseid,coursename,coursedescription,courseduration)
values(1,'biology','intro to computer',4),
(2,'chemistry','intro to web desgin',5),
(3,'math','intro to ict',6);
select*from course;

alter table modules drop column modulediscription;
desc modules;
insert into modules(moduleid,moduletitle,modulecantent,courseid)
values(1,'introduction to databases',60,1),
(2,'advanced sql queries',30,2);
select*from modules;

-- Update
 update users
SET email = 'john.doe@newdomain.com'
WHERE userid = 1;
select *from users;

-- delete
DELETE FROM Users
WHERE userid = 1;

-- count
SELECT COUNT(*) AS total_users FROM Users;
-- Average
SELECT AVG(firstname) AS avg_firstname FROM Users;
-- sum
SELECT SUM(email) AS total_email FROM Users;

-- update
UPDATE Course
SET name = 'busines'
WHERE course_id = 1;
select *from course;

-- Delete
DELETE FROM Course
WHERE course_id = 1;
-- Count
SELECT COUNT(*) AS total_course FROM Course;
-- Average
SELECT AVG(courseduration) AS avg_course_duration FROM Course;
-- Sum
SELECT SUM(courseduration) AS total_course_duration  FROM Course;
SELECT * FROM Modules
WHERE courseid = 1;
-- UPDATE
UPDATE Modules
SET modulecontent = 70
WHERE moduleid = 1;
-- DELETE
DELETE FROM Modules
WHERE moduleid = 2;
-- COUNT 
SELECT COUNT(*) AS total_modules FROM Modules;
SELECT COUNT(*) AS total_modules_course_1
FROM Modules
WHERE courseid = 1;
--  AVG
SELECT AVG(modulecontent) AS avg_module_content FROM Modules;
SELECT AVG(modulecontent) AS avg_module_content_course_1
FROM Modules
WHERE courseid = 1;

SELECT SUM(courseduration) AS total_course_duration FROM Course;

-- PL/SQL Views

create view listofcourse as select * from course;
select * from listofcourse;

create view listofusers as select *from users;
select *from listofusers;
create view listofmodules as select *from modules;
select *from listofmodules;

create view listofstudent_who_study_chemistry as select * from course where coursename="chemistry";
select * from listofstudent_who_study_chemistry;
create view listofstudent_who_study_biology as select * from course where coursename="biology";
select * from listofstudent_who_study_biology;
create view listofstudent_who_study_math as select *from course where coursename="math";

select *from listofstudent_who_study_math;
-- store procedures

DELIMITER //
CREATE PROCEDURE add_new_user(
    IN p_firstname VARCHAR(50),
    IN p_lastname VARCHAR(50),
    IN p_email VARCHAR(100)
)
BEGIN
    INSERT INTO users(firstname, lastname, email)
    VALUES (p_firstname, p_lastname, p_email);
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE update_course_duration(
    IN p_courseid INT,
    IN p_new_duration INT
)
BEGIN
    UPDATE course
    SET courseduration = p_new_duration
    WHERE courseid = p_courseid;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE get_courses_by_duration(
    IN p_min_duration INT
)
BEGIN
    SELECT * FROM course
    WHERE courseduration > p_min_duration;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER before_user_insert
BEFORE INSERT ON users
FOR EACH ROW
BEGIN
    DECLARE email_count INT;
    SELECT COUNT(*) INTO email_count
    FROM users
    WHERE email = NEW.email;
    
    IF email_count > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Email already exists.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER after_module_insert
AFTER INSERT ON modules
FOR EACH ROW
BEGIN
    INSERT INTO module_log(moduleid, log_message, log_date)
    VALUES (NEW.moduleid, CONCAT('Module "', NEW.moduletitle, '" inserted.'), NOW());
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER after_course_delete
AFTER DELETE ON course
FOR EACH ROW
BEGIN
    INSERT INTO course_deletion_log(courseid, log_message, log_date)
    VALUES (OLD.courseid, CONCAT('Course "', OLD.coursename, '" deleted.'), NOW());
END //
DELIMITER ;

-- call procedures

CALL update_course_duration(2, 6);

CALL get_courses_by_duration(4);

create user'mukarweg'@'127.0.0.1' identified by '2409001023';
grant all privileges on e_learning_platform.*to'mukarweg'@'127.0.0.1';
flush privileges;


















