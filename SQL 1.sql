/*1.How many departments are there*/

select
count(distinct dept_no) as Distinct_Dept
 from dept_emp;
 
 /* 2.What is the total amount of money spent on salaries for all contracts starting after the 1st of January 1997*/
 
 select
 sum(salary)
 from salaries
 where from_date > ' 1997-01-01';
 
 /* 3.Find the lowest employee no. & highest employee no*/
 
 select
 min(emp_no),
 max(emp_no)
 from employees;
 
 /*4.What is the average annual salary paid to employees who started after the 1st of January 1997*/
 
 select
 round(avg(salary),2) from salaries
 where from_date > '1997-01-01';
 
 
 /*5. Extract a list containing information about all managers’ employee number, first and last name, department number, and hire date. */
 
 select
 e.emp_no,
 e.first_name,
 e.last_name,
 dm.dept_no,
 e.hire_date
 from employees e 
 join dept_manager dm using(emp_no);

/* 6. Return a subset of all the employees whose last name is Markovitch. */

select
e.emp_no,
e.first_name,
e.last_name,
dm.dept_no,
dm.from_date
from 
employees e
left join
dept_manager dm using(emp_no)
where e.last_name = 'Markovitch'
order by dm.dept_no desc , e.emp_no;

/*7.Retrieve first name , last name , hire_date & job title of all employees whose first name is “Margareta” and have the last name “Markovitch*/

select
e.first_name,
e.last_name,
e.hire_date,
t.title
from employees e
join titles t 
using (emp_no)
where first_name = 'Margareta'
and last_name = 'Markovitch'
order by e.emp_no;

 /*8. Return a list with all possible combinations between managers from the dept_manager table and department number 9. */
 
 select dm.*,d.*
 from departments d
 cross join dept_manager dm
 where d.dept_no = 'd009'
 order by d.dept_no;
 
 
 /* 9.Return a list with the first 10 employees with all the departments they can be assigned to  */
 
 select
 e.*,d.*
 from employees e
 cross join departments d
 order by e.emp_no , d.dept_name
 limit 10;
 
 
 /*10.Select all 'managers' first and last name, hire date, job title, start date, and department name. */
 
 select
 e.first_name,
 e.last_name,
 e.hire_date,
 t.title,
 dm.from_date,
 d.dept_name
 from employees e
 join dept_manager dm
 using(emp_no)
 join departments d
 using(dept_no)
 join titles t 
 using(emp_no)
 where t.title = 'Manager'
 order by e.emp_no;
 
 
 /*11.How many male and how many female managers do we have */
 
 select
 e.gender,
 count(dm.emp_no)as no_of_managers
 from
 employees e
 join
 dept_manager dm using(emp_no)
 group by e.gender;
 
 
 
 /* 12.Extract the information about all department managers who were hired between the 1st of January 1990 and the 1st of January 1995.*/
 
 select*from dept_manager
 where emp_no in(
 select 
 emp_no
 from 
 employees
 where
 hire_date between '1990-01-01' and '1995-01-01');
 
 /*13. Retrieve entire information for all employees whose job title is “Assistant Engineer */
 
 select*from employees e where exists(
 select* from 
 titles join employees
 using(emp_no)
 where title = 'Assistant Engineer');
 
 
 /* 14. Create a view that will extract the average salary of all managers registered  */
 
 create view manager_avg_salary as 
 select round(avg(salary),2)
 from salaries s 
 join dept_manager dm
 using(emp_no);
 
 /*15. Create a view on latest dates  of employees*/
 
 create view dept_emp_latest_date as
 select 
 emp_no,
 max(from_date) as from_date,
 max(to_date) as to_date
 from dept_emp
 group by emp_no
 
 /*16.Creating a procedure that will provide the average salary of all employees.*/
 
 delimiter $$
 create procedure avg_salary()
 begin
 select avg(salary)  from salaries;
 end $$
 
 delimiter ;
 
  
 /*17.Creating a procedure , that uses  parameters as emp_no of an individual,
 and returns their salary detaials.*/
 
 delimiter $$
 create procedure emp_salary (in p_emp_no integer)
 begin
 select
 e.first_name, e.last_name ,s.salary, s.from_date , s.to_date
 from employees e
 join salaries s 
 using(emp_no)
 where e.emp_no = p_emp_no;
 end$$
 
 delimiter ;

 
 /*18.Creating a procedure , that uses  parameters as the first and the last name of an individual,
 and returns their employee number.*/
 
 delimiter $$
 create procedure emp_info(in p_first_name varchar(255),in p_last_name varchar(255),out p_emp_no integer)
 begin
 select e.emp_no 
 into p_emp_no from employees e
 where e.first_name = p_first_name
 and e.last_name = p_last_name;
 end$$
 delimiter ;
 
 
 
