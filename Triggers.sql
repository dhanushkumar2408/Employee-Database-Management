use employees;
commit;

delimiter $$
create trigger before_salaries_insert
before insert on salaries
for each row
begin
if new.salary < 0
then set new.salary = 0;
end if;
end $$
delimiter ;


INSERT INTO salaries VALUES ('10001', -92891, '2010-06-22', '9999-01-01');

SELECT *FROM
salaries
WHERE emp_no = '10001';



delimiter $$

create trigger trig_upd_salary
before update on salaries
for each row
begin
IF NEW.salary < 0 THEN 
		SET NEW.salary = OLD.salary; 
END IF; 
end $$

delimiter ;


UPDATE salaries 
SET salary = 50000
WHERE emp_no = '10001'
AND from_date = '2010-06-22';

SELECT *
FROM salaries
WHERE emp_no = '10001'
AND from_date = '2010-06-22';


rollback;
