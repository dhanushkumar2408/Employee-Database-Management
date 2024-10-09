create table departments_dup(
select*from departments);

insert into departments_dup 
values ( 'd009','Customer Service');



DROP TABLE IF EXISTS dept_manager_dup;

CREATE TABLE dept_manager_dup (
emp_no int(11) NOT NULL,
dept_no char(4) NULL,
from_date date NOT NULL,
to_date date NULL
);



 

INSERT INTO dept_manager_dup
select * from dept_manager;

 

INSERT INTO dept_manager_dup (emp_no, from_date)

VALUES (999904, '2017-01-01'),
(999905, '2017-01-01'),
(999906, '2017-01-01'),
(999907, '2017-01-01');

 

DELETE FROM dept_manager_dup
WHERE
dept_no = 'd001';
    
   
   
   
/*dept_dup*/
   
ALTER TABLE departments_dup
CHANGE COLUMN dept_no dept_no CHAR(4) NULL;

ALTER TABLE departments_dup
CHANGE COLUMN dept_name dept_name VARCHAR(40) NULL;







    