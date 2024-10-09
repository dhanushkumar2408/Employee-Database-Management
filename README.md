## Database Schema

### Tables

1. **dept_emp**
   - `emp_no` (INT): Employee Number, references the `employees` table.
   - `dept_no` (CHAR(4)): Department Number, references the `departments` table.
   - `from_date` (DATE): The start date of the employee's assignment to the department.
   - `to_date` (DATE): The end date of the employee's assignment to the department.

2. **dept_manager**
   - `emp_no` (INT): Employee Number, references the `employees` table.
   - `dept_no` (CHAR(4)): Department Number, references the `departments` table.
   - `from_date` (DATE): The start date of the employee's tenure as manager.
   - `to_date` (DATE): The end date of the employee's tenure as manager.

3. **employees**
   - `emp_no` (INT): Primary key. Unique identifier for each employee.
   - `birth_date` (DATE): Employee's date of birth.
   - `first_name` (VARCHAR(14)): Employee's first name.
   - `last_name` (VARCHAR(16)): Employee's last name.
   - `gender` (ENUM): Employee's gender ('M' for male, 'F' for female).
   - `hire_date` (DATE): Date when the employee was hired.

4. **departments**
   - `dept_no` (VARCHAR(4)): Department number, the unique identifier for each department.
   - `dept_name` (VARCHAR(40)): The name of the department.

5. **titles**
   - `emp_no` (INT): Employee Number, references the `employees` table.
   - `title` (VARCHAR(50)): Job title of the employee.
   - `from_date` (DATE): The start date of the title.
   - `to_date` (DATE): The end date of the title.

6. **salaries**
   - `emp_no` (INT): Employee number, references the `employees` table.
   - `salary` (INT): The employee's salary.
   - `from_date` (DATE): The start date of the salary record.
   - `to_date` (DATE): The end date of the salary record.


