--3
select e.last_name,e.job_id,e.hire_date
from employees e
where e.hire_date between date '2001-02-12' and  date '2005-01-05';
--4
select e.last_name,e.job_id
from employees e
where e.department_id = 20 or e.department_id = 50;
--5
select *
from employees e
where extract(year from e.hire_date) = 2004;
--6
select e.last_name,e.job_id
from employees e
where e.manager_id is null;
--7
select e.employee_id,
       e.first_name,
       e.last_name,
       e.email,
       e.phone_number,
       e.hire_date,
       e.job_id,
       e.salary,
       e.commission_pct,
       e.manager_id,
       e.department_id
from employees e
where e.commission_pct > 0
order by e.salary desc, e.commission_pct desc;
--8
select * 
from employees e
where e.last_name like '__a%';
--9
select *
from employees e
where e.last_name like '%e%'
and e.last_name like '%a%';
--10
select e.last_name,e.job_id,e.salary
from employees e
join jobs j 
on e.job_id = j.job_id
where (j.job_title = 'Sales Representative' or j.job_title = 'Stock Clerk')
and e.salary not in (2500,3500,7000);

--11
select e.employee_id,e.last_name,round((e.salary*1.15),1) "New Salary"
from employees e;

--12
select initcap(e.last_name),length(e.last_name),substr(initcap(e.last_name),1,1)
from employees e
where substr(initcap(e.last_name),1,1) in ('J','A','L','M');

--13
SELECT e.employee_id,e.last_name, round(months_between(sysdate,e.hire_date),0)
from employees e
order by round(months_between(sysdate,e.hire_date),0);


SELECT e.employee_id,e.last_name, round((months_between(sysdate,e.hire_date)/12),0)
from employees e
order by round((months_between(sysdate,e.hire_date)/12),0)


--14
select e.last_name ||' earns ' || e.salary ||' monthly but wants ' || e.salary *3 "Dream Salaries"
from employees e;

--15
select e.last_name,nvl(to_char(e.commission_pct),'No commission')
from employees e;

--16
SELECT
  DECODE(1, 1, 'One',  2, 'Two')
FROM
  dual;
  
select e.job_id,decode(e.job_id, 
       'AD_PRES' , 'A',
       'ST_MAN' , 'B',
       'IT_PROG' , 'C',
       'SA_REP' , 'D',
       'ST_CLERK' ,'E',
       '0' ) GRADE
from employees e;

--17
select e.last_name,e.department_id,d.department_name
from employees e
join departments d 
on e.department_id = d.department_id
join locations l 
on d.location_id = l.location_id
where l.city = 'Toronto';

--18
select e.employee_id,e.last_name,m.employee_id,m.last_name
from employees e 
join employees m
on e.manager_id = m.employee_id;

--19
SELECT e.last_name, d.department_name
FROM employees e
JOIN departments d ON e.department_id = d.department_id
WHERE e.department_id = (SELECT department_id FROM employees WHERE employee_id = 100);


select e.*
from employees e join departments d
on e.department_id = d.department_id
where d.department_id = (select department_id from employees where employee_id = 100 );

--20
select *
from employees e
where e.hire_date >  (select hire_Date from employees where last_name = 'Davies')
order by hire_Date;

select *
from employees e
where months_between(e.hire_date,(select hire_Date from employees where last_name = 'Davies')) > 0
order by e.hire_date;

--21
select e.employee_id,e.last_name,e.hire_date
from employees e
join employees m 
on e.manager_id = m.employee_id
where e.hire_date > m.hire_date;

--22
select e.job_id, max(e.salary),min(e.salary),avg(e.salary),sum(e.salary)
from employees e
group by e.job_id;

--23
select d.department_id,d.department_name,count(e.employee_id)
from employees e 
join departments d 
on e.department_id = d.department_id
group by d.department_id,d.department_name;

--24
select  extract(year from e.hire_date), count(e.employee_id)
from employees e
group by extract(year from e.hire_date)
having extract(year from e.hire_date) in ('2001','2002','2003','2004');

--25
select e.last_name,e.hire_date
from employees e
where e.department_id = (select d.department_id from employees d where d.last_name = 'Zlotkey');

--26
select e.last_name,e.department_id,e.job_id
from employees e
join departments d on e.department_id = d.department_id
where d.location_id = 1700;

--27
select e.employee_id,e.last_name,e.manager_id
from employees e 
where e.manager_id = (select m.employee_id from employees m where m.last_name='King' and m.manager_id is null);

--28
select *
from employees e 
where e.salary > (select avg(e1.salary) from employees e1)
and e.department_id in (select e2.department_id from employees e2 where e2.last_name like '%n');


select e2.* from employees e2 where e2.last_name like '%n';

--29
select *
from departments d
where d.department_id in (
      select e.department_id
from employees e
group by e.department_id
having count(e.employee_id) < 3);

--30
select max(count(e.employee_id)) "Max",min(count(e.employee_id)) "Min"
from employees e
group by e.department_id;

--31
select * from employees e
where to_char(hire_Date,'Day') = (
      select to_char(e1.hire_Date,'Day')
      from employees e1
      group by to_char(e1.hire_Date,'Day')
      having count(e1.employee_id) = (
             select max(count(e2.employee_id))
             from employees e2
             group by to_char(hire_date,'day')
      )
);

--32
select * 
from employees e
order by e.salary desc 
FETCH FIRST 3 ROWS ONLY;


--33
select e.*
from employees e
join departments d on e.department_id = d.department_id
join locations l on l.location_id = d.location_id
where l.state_province = 'California'

--35
select * 
from employees e 
where e.salary < (
  select avg(e1.salary)
  from employees e1
  where e.department_id = e1.department_id
  group by e1.department_id
);

select * from employees e where e.department_id = 90;
select e1.department_id,avg(e1.salary)
  from employees e1
  group by e1.department_id

--39
create view Country_Asia as
select c.*
from countries c join regions r
on c.region_id = r.region_id
where r.region_name = 'Asia';

select * from Country_Asia;

--40
create view No_Manager_v as
select e.*
from employees e 
where e.manager_id is null;

--41

SELECT *
FROM departments d
WHERE NOT EXISTS (
   SELECT 1
   FROM employees e
   WHERE e.department_id = d.department_id
);

insert into departments(department_id,department_name,location_id) values(999,'AAA','1700');


--42
select e.employee_id,e.last_name,e.job_id,e.department_id,round((months_between(sysdate,e.hire_date)/12),1) "year" 
from employees e
where e.salary > (
      select avg(e1.salary)
      from employees e1
)

--43
set serveroutput on;

select * from departments;

create or replace procedure dept_info(dep_ID number)
is
    r_dep departments%ROWTYPE;
begin
    select *
    into r_dep
    from departments
    where department_id = dep_ID;
    
    dbms_output.put_line(r_dep.department_id ||' '||r_dep.department_name||' '||
    r_dep.manager_id||' '||r_dep.location_id);
    
    exception
        when others then 
            dbms_output.put_line(SQLERRM);         
END;

exec dept_info(20);

--44
select * from jobs

create or replace procedure add_job(p_jobId in varchar2,p_jobName in varchar2)
is
begin
    insert into jobs(job_id,job_title) values(p_jobId,p_jobName);
    commit;
    dbms_output.put_line('Done');
    
    exception
        when others then
            rollback;
            dbms_output.put_line('Erros');
end add_job;

exec add_job();

--45
select * from employees;

create or replace procedure update_comm(p_employee_id int)
is
begin
    update employees 
    set commission_pct = commission_pct*1.05 
    where employee_id = p_employee_id and commission_pct is not null;
    commit;
    dbms_output.put_line('Done');
    
    exception 
        when others then
        rollback;
        dbms_output.put_line('Error'); 
end;

--46
select * from employees;

create or replace procedure add_employee(
    p_employee_id in number,
    p_first_name in varchar2,
    p_last_name in varchar2,
    p_email in varchar2,
    p_phone in varchar2,
    p_hire_date in date,
    p_job_id in varchar2,
    p_salary in number,
    p_commission_pct in float,
    p_manager_id in number,
    p_department_id in number
    )
is
begin
    insert into employees(employee_id,first_name,last_name,email,phone_number,hire_date,job_id,salary,commission_pct,manager_id,department_id)
    values(p_employee_id,p_first_name,p_last_name,p_email,p_phone,p_hire_date,p_job_id,p_salary,p_commission_pct,p_manager_id,p_department_id);
    commit;
    dbms_output.put_line('Done');
    
    exception 
        when others then
        rollback;
        dbms_output.put_line('Error'); 
    
end;

--47
create or replace procedure delete_employee(p_employee_id number)
is
begin
    delete from employees where employee_id = p_employee_id;
    commit;
    dbms_output.put_line('Done');
    
    exception 
        when others then
        rollback;
        dbms_output.put_line('Error'); 
end;

--48


CREATE OR REPLACE PROCEDURE find_emp AS
    min_salary NUMBER;
    max_salary NUMBER;
BEGIN
    -- L?y m?c l??ng th?p nh?t t? b?ng l??ng
    SELECT MIN(salary) INTO min_salary FROM employees;

    -- L?y m?c l??ng cao nh?t t? b?ng l??ng
    SELECT MAX(salary) INTO max_salary FROM employees;

    -- Tìm ki?m nhân viên có l??ng n?m trong kho?ng t? min_salary ??n max_salary
    FOR emp_record IN (SELECT * FROM employees WHERE salary > min_salary AND salary < max_salary) LOOP
        DBMS_OUTPUT.PUT_LINE('Employee ID: ' || emp_record.employee_id || ', Name: ' || emp_record.last_name || ', Salary: ' || emp_record.salary);
    END LOOP;
END find_emp;

exec find_emp

create or replace procedure find_emp as
    min_salary number;
    max_salary number;
begin
    select min(salary) into min_salary from employees;
    select max(salary) into max_salary from employees;
    
    for employee_rec in (select * from employees where salary > min_salary and salary < max_salary)
    loop
        dbms_output.put_line('EMPLOYEE ID: ' || employee_rec.employee_id || 'EMPLOYEE_NAME: ' || employee_rec.last_name || 'SALARY: '||employee_rec.salary);      
    end loop;
end find_emp;

--48

SELECT e.employee_id, round((months_between(sysdate,e.hire_date)/12),0) from employees e
order by round((months_between(sysdate,e.hire_date)/12),0);

SELECT
  DECODE(3, 1, 'One',  2, 'Two', 'Not one or two')
FROM
  dual; 
  
create or replace procedure update_comm as
    p_employee_id number;
    p_year number;
begin
    for employee_rec in (SELECT e.employee_id, round((months_between(sysdate,e.hire_date)/12),0) as year_work from employees e)
    loop
        p_employee_id := employee_rec.employee_id;
        p_year :=  employee_rec.year_work;
        
--        case p_year
--        when p_year > 21 then
--            update employees set salary = salary + 200 where employee_id = p_employee_id;
--        when p_year > 20 then
--            update employees set salary = salary + 100 where employee_id = p_employee_id;
--        when p_year < 20 then
--            update employees set salary = salary + 50 where employee_id = p_employee_id;
--        else
--            null;
--        end case;    
    IF p_year > 21 THEN
            UPDATE employees SET salary = salary + 200 WHERE employee_id = p_employee_id;
        ELSIF p_year > 20 THEN
            UPDATE employees SET salary = salary + 100 WHERE employee_id = p_employee_id;
        ELSIF p_year = 20 THEN
            UPDATE employees SET salary = salary + 50 WHERE employee_id = p_employee_id;
        ELSE
            -- Handle other cases if needed
            NULL;
        END IF;
    end loop;
    commit;
    dbms_output.put_line('Hoan thanh');
    
     exception 
        when others then
        rollback;
        dbms_output.put_line('Error');
end;


CREATE OR REPLACE PROCEDURE update_comm AS
    p_employee_id NUMBER;
    p_year NUMBER;
BEGIN
    FOR employee_rec IN (SELECT e.employee_id, ROUND((MONTHS_BETWEEN(SYSDATE, e.hire_date)/12), 0) AS years_worked FROM employees e)
    LOOP
        p_employee_id := employee_rec.employee_id;
        p_year := employee_rec.years_worked;

        IF p_year > 21 THEN
            UPDATE employees SET salary = salary + 200 WHERE employee_id = p_employee_id;
        ELSIF p_year > 20 THEN
            UPDATE employees SET salary = salary + 100 WHERE employee_id = p_employee_id;
        ELSIF p_year = 20 THEN
            UPDATE employees SET salary = salary + 50 WHERE employee_id = p_employee_id;
        ELSE
            -- Handle other cases if needed
            NULL;
        END IF;
    END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Hoàn thành');
EXCEPTION 
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('L?i');
END;
/


CREATE OR REPLACE PROCEDURE update_comm AS
BEGIN
    FOR employee_rec IN (SELECT e.employee_id, ROUND((MONTHS_BETWEEN(SYSDATE, e.hire_date)/12), 0) AS years_worked FROM employees e)
    LOOP
        CASE
            WHEN employee_rec.years_worked > 21 THEN
                UPDATE employees SET salary = salary + 200 WHERE employee_id = employee_rec.employee_id;
            WHEN employee_rec.years_worked > 20 THEN
                UPDATE employees SET salary = salary + 100 WHERE employee_id = employee_rec.employee_id;
            WHEN employee_rec.years_worked = 20 THEN
                UPDATE employees SET salary = salary + 50 WHERE employee_id = employee_rec.employee_id;
            ELSE
                NULL; -- X? lý các tr??ng h?p khác n?u c?n
        END CASE;
    END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Hoàn thành');
EXCEPTION 
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('L?i');
END;
/

--50
select * from job_history

create or replace procedure job_his(p_employee_id number) as
begin
    for employee_rec in (select * from job_history where employee_id = p_employee_id) 
    loop
        dbms_output.put_line('EMPLOYEE_ID: ' || employee_rec.employee_id || ', START_DATE: '|| employee_rec.start_date || ', END_DATE: ' || employee_rec.end_Date ||
        ', JOB_ID: '|| employee_rec.job_id || ', DEPARTMENT_ID: '|| employee_rec.department_id );
    end loop;
end;

exec job_his(102);

--51
create or replace function sum_salary(p_department_id NUMBER)
return number
is
    l_sum_salary NUMBER := 0;
begin
    select sum(salary) 
    into l_sum_salary
    from employees e 
    join departments d 
    on e.department_id = d.department_id
    where d.department_id = p_department_id;
    
    return l_sum_salary;
end;

SELECT * FROM DEPARTMENTS;

DECLARE
    l_salary_10 NUMBER := 0;
BEGIN
    l_salary_10 := sum_salary(40);
    DBMS_OUTPUT.PUT_LINE('SALARY IN DEPARTMENT 10: ' || l_salary_10);
END;

--52
select * from countries;
CREATE or replace function name_con(p_coun_id in varchar2)
return varchar2
is
    l_name_coun varchar2(100) :='';
begin
    select country_name 
    into l_name_coun 
    from countries
    where country_id = p_coun_id;
    
    return l_name_coun;
end;

declare
    l_name varchar2(100);
begin
    l_name := name_con('AR');
    dbms_output.put_line('Country name by id AR: '|| l_name);
end;

--53
select * from employees;

create or replace function annual_comp(p_salary number,p_comm float)
return number
is
    l_salary_of_year number :=0;
begin
    select (p_salary*12 + (p_comm*p_salary*12)) as sal_year
    into l_salary_of_year
    from dual;
    
    return l_salary_of_year;
end;

declare
    l_sal number;
begin
    l_Sal := annual_comp(14000,0.4);
    dbms_output.put_line('Salary: '|| l_sal);
end;

--54
create or replace function avg_salary(p_dep_id number)
return float
is
    l_avg_sal float :=0;
begin
    SELECT avg(e.salary)
    into l_avg_sal
    FROM employees e
    where e.department_id = p_dep_id;
    
    return l_avg_sal;
end;

declare
    l_sal float;
begin
    l_sal :=avg_salary(10) ;
    dbms_output.put_line('Avage Salary: '|| l_sal);
end;

select * from departments;
SELECT avg(e.salary)
    FROM employees e
    where e.department_id = 10;
    
    
--55
create or replace function time_work(p_employee_id number)
return float
is
    l_time float :=0;
begin
    select round(months_between(sysdate,e.hire_date),1)
    into l_time
    from employees e
    where e.employee_id = p_employee_id;
    
    return l_time;
end;


CREATE OR REPLACE FUNCTION time_work(p_employee_id NUMBER)
RETURN FLOAT
IS
    l_time FLOAT := 0;
BEGIN
    SELECT ROUND(MONTHS_BETWEEN(SYSDATE, e.hire_date), 1)
    INTO l_time
    FROM employees e
    WHERE e.employee_id = p_employee_id;

    RETURN l_time;
END time_work;

select employee_id, round(months_between(sysdate,hire_date),1)
    from employees
    
    
set serveroutput on;
declare
    l_time number;
    l_id number := &x;
begin
    l_time := time_work(l_id);
    dbms_output.put_line('TIME: '||  l_time);
end;


--56
create or replace package employee_info as
    procedure salary_table;
    function sum_salary(dept_id in number) return number;
end employee_info;

create or replace package body employee_info as
    procedure salary_table is
    begin
        for employee_rec in (select employee_id,last_name,salary from employees) loop
            dbms_output.put_line('Employee ID: '||employee_rec.employee_id ||', employee_name: '||employee_rec.last_name||', salary: '||employee_rec.salary);
        end loop;
    end salary_table;
    
    function sum_salary(dept_id in number) return number is
        total_salary number :=0;
    begin
        select sum(salary) into total_salary from employees where department_id = dept_id;
        return total_salary;
    end sum_salary;
end employee_info;

begin
    employee_info.salary_table;
end;

declare
    dept_total_salary number;
begin
    dept_total_salary := employee_info.sum_salary(10);
    DBMS_OUTPUT.PUT_LINE('Total salary for department 10:' || dept_total_salary);
end;

--57
create or replace package employ_info as
    procedure employ_info(emp_id number);
end employ_info;

create or replace package body employ_info as
    procedure employ_info(emp_id number) is
    begin
        for employee_rec in (select e.employee_id,
                                    e.last_name,
                                    e.salary,
                                    e.commission_pct,
                                    m.last_name as manager_last_name,
                                    j.job_title,
                                    d.department_name
        from employees e join departments d on e.department_id = d.department_id
        join employees m on e.manager_id = m.employee_id
        join jobs j on e.job_id = j.job_id
        where e.employee_id = emp_id
        ) loop
            dbms_output.put_line('ID: '||employee_rec.employee_id||' ,Name: '||employee_rec.last_name||' ,Salary: '|| employee_rec.salary ||
            ' ,Commission: '||employee_rec.commission_pct||' ,Manager Name: ' || employee_rec.manager_last_name ||' ,Job Name: '||employee_rec.job_title||
            ' ,department name: '|| employee_rec.department_name );
        end loop;
    end;
end employ_info;



set serveroutput on;
 

select * from employees;

--58
create or replace package job_pack as
    procedure add_job(p_job_id number, p_job_title in varchar2,p_min_sal number,p_max_sal number);
    procedure update_job(p_job_id number, p_job_title in varchar2,p_min_sal number,p_max_sal number);
    procedure delete_job(p_job_id number);
    function q_job(p_job_id number)
    return  varchar2;
end job_pack;

create replace package body job_pack as
begin
    procedure add_job(p_job_id number, p_job_title in varchar2,p_min_sal number,p_max_sal number) is
    begin
        insert into jobs(job_id,job_title,min_Salary,max_salary) values(p_job_id,p_job_title,p_min_Sal,p_max_sal);
        commit;
        dbms_output.put_line('Done');
        
    EXCEPTION 
            WHEN OTHERS THEN
            ROLLBACK;
            DBMS_OUTPUT.PUT_LINE('Error');
    end add_job;
    
    procedure update_job(p_job_id number, p_job_title in varchar2,p_min_sal number,p_max_sal number) is
    begin
        update jobs set job_title = p_job_title,min_salary=p_min_sal,max_salary=p_max_sal where job_id = p_job_id;
        commit;
        dbms_output.put_line('Done');
        
    exception
        when others then
            rollback;
            dbms_output.put_line('Error');
    end update_job;
    
    procedure delete_job(p_job_id number) is
    begin
        delete from jobs where job_id = p_job_id;
        commit;
        
        dbms_output.put_line('Done');
        
    exception
        when others then
            rollback;
            dbms_output.put_line('Error');
    end delete_job;
    
    function q_job(p_job_id number) return varchar2 is
        l_title varchar2(100) :='';
    begin
        select job_title 
        into l_title
        from jobs
        where job_id = p_job_id;
        
        return l_title;
        
        EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN NULL;
        WHEN OTHERS THEN
            RETURN NULL;
    end q_job;
    
end job_pack;

select * from jobs;