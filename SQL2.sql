/*19.What is the role (Manager or Employee) of employees with an emp_no greater than 109990, 
based on whether they appear in the dept_manager table?*/

select
e.emp_no,
e.first_name,
e.last_name,
case 
when dm.emp_no is not null then 'Manager'
else 'Employee'
end as role
from 
employees e 
left join
dept_manager dm using(emp_no)
where e.emp_no > 109990;

/*20.What is the difference between the maximum and minimum salaries of each department manager, 
and whether the salary was raised by more than $30,000?*/

select
dm.emp_no,
e.first_name,
e.last_name,
max(s.salary)-min(s.salary) as salary_difference,
case when
max(s.salary)-min(s.salary)> 30000 then 'Salary was raised by more than $30,000'
else 'Salary was not raised by more than $30,000'
end as salary_status
from dept_manager dm
join employees e using(emp_no)
join salaries s using(emp_no)
group by 1,2,3 ;

/*21.
What is the current employment status of employees based on the latest department assignment end date?*/

select
e.emp_no,
concat(e.first_name,' ' , e.last_name) as full_name,
case when
max(de.to_date) > sysdate()then 'Is still employeed'
else 'Not an employee anymore'
end as employee_status
from employees e
join
dept_emp de using(emp_no)
group by de.emp_no
limit 100;



/*22.Creating an index on the ‘salary’ column  where salary is greater than 89000*/

create index ind_salary on salaries(salary);
select*from salaries where salary > 89000;

/*23.The query below retrieves each department manager's employee number and salary, assigning two row numbers: 
one sequential across all results and another within each employee group ordered by salary*/

select
dm.emp_no,
salary,
row_number()over() as row_num1,
row_number()over(partition by emp_no order by salary asc)as row_num2
from dept_manager dm
join salaries s using(emp_no)
order by row_num1,emp_no,salary asc;


/*24.What is the minimum salary for each employee based on their salary history*/

select a.emp_no,
min(salary)as min_salary from
(select
emp_no,
salary,
row_number()over(partition by emp_no order by salary) as row_num
from salaries) a
group by 1;

/*Method2*/

select a.emp_no,
a.salary as min_salary from(
select emp_no,
salary,
row_number() over(partition by emp_no order by salary) as row_num
from salaries) a
where a.row_num = 1;

/*25.Finding second -lowest salary */

select a.emp_no,
a.salary as min_salary from(
select
emp_no,
salary,
row_number()over(partition by emp_no order by salary) as row_num
from salaries) as a
where a.row_num = 2;

/*26.What are the different salary amounts for employee number 10560, 
ranked in descending order by salary*/

select
emp_no,
salary,
rank()over(partition by emp_no order by salary desc) as rank_num
from salaries
where emp_no = 10560;


/*27.Ranking employees (with employee numbers between 10500 and 10600) based on their highest salaries, 
showing each employee's salary and their rank relative to other salaries they've received   */

select 
e.emp_no,
s.salary,
rank()over(partition by e.emp_no order by s.salary desc) as employee_sal_ranking
from employees e
join salaries s using(emp_no)
where e.emp_no between 10500 and 10600;


/* 28.Retrieve the contracts signed by employees with IDs between 10500 and 10600,
 considering only those signed at least 4 years after their hire date,
 and rank their salaries without gaps for identical salary values */
 
select
e.emp_no,
s.salary,
e.hire_date,
s.from_date,
(year(s.from_date) - year(e.hire_date)) as year_from_start,
dense_rank()over(partition by e.emp_no order by s.salary desc) as emp_sal_ranking
from employees e
join salaries s on s.emp_no = e.emp_no
and (year(s.from_date) - year(e.hire_date))>=5
where e.emp_no between 10500 and 10600;


/*29.How have employees' salaries evolved over time(prev , next , differences between salaries)
 specifically for employees with salaries greater than 80,000 and employee numbers between 10,500 and 10,600?  */
 

select
emp_no,
salary,
lag(salary)over(partition by emp_no order by salary) as prev_salary,
lead(salary)over(partition by emp_no order by salary) as next_salary,
salary - lag(salary)over(partition by emp_no order by salary) as diff_salary_current_previous,
lead(salary)over(partition by emp_no order by salary)- salary as diff_salary_next_current
from salaries
where salary > 80000 and 
emp_no between 10500 and 10600;

use employees;


/* 30. How do employees' current salaries compare with their previous and next salary levels over time for those earning above $80,000,
 within a specific employee number range (between 10500 and 10600)?  */

select
emp_no,
salary,
lag(salary)over(partition by emp_no order by salary) as prev_salary,
lag(salary,2)over(partition by emp_no order by salary) as before_prev_salary,
lead(salary)over(partition by emp_no order by salary) as next_salary,
lead(salary,2)over(partition by emp_no order by salary) as after_next_salary
from 
salaries
where salary > 80000 and 
emp_no between 10500 and 10600
limit 100;


/* 31."How many male employees have their highest salary recorded below the average salary of all employees in the company?"  */

with cte_avg_salary as(
select
avg(salary) as avg_salary from salaries),
salary_data as(
select s.emp_no,
 max(s.salary) as max_salary
from salaries s 
join employees e
on e.emp_no = s.emp_no 
and e.gender = 'M'
group by s.emp_no
)
select sum(case when sd.max_salary < cte.avg_salary then 1 else 0 end) as no_of_highest_salaries_below_avg
from salary_data sd
join cte_avg_salary cte;


 /*MySQL - Tableau*/
 
/*32.Create a visualization that provides a breakdown between the
 male and female employees working in the company each year, starting from 1990.*/
 
 select 
 year(d.from_date) as calendar_year,
 e.gender,
 count(e.emp_no) as num_of_employees
 from employees e 
 join
 dept_emp d using(emp_no)
 group by 1,2
 having calendar_year >= 1990
 order by 1;


 
 /* 33. Compare the average salary of female versus male employees in the entire company until year 2002, 
 and add a filter allowing you to see that per each department */


select 
d.dept_name,
e.gender,
round(avg(s.salary),2) as salary,
year(s.from_date)as calendar_year
from salaries s
join
employees e using(emp_no)
join dept_emp de using(emp_no)
join departments d using(dept_no)
group by d.dept_no,e.gender,calendar_year
having calendar_year <=2002
order by d.dept_no;


/*34. average male and female salary per department within a certain salary range. Let this range be defined by two values the user can insert when calling the procedure*/

delimiter $$

create procedure salary_filter(IN p_min_salary float , in p_max_salary float)
begin
select 
e.gender,
d.dept_name,
round(avg(s.salary),2)as avg_salary
from 
salaries s 
join 
employees e using(emp_no)
join dept_emp de using(emp_no)
join departments d using(dept_no)
where s.salary between p_min_salary and p_max_salary
group by d.dept_no,e.gender;
end $$

delimiter ;


CALL salary_filter(50000, 90000);


