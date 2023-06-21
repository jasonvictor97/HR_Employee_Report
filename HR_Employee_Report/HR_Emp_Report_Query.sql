Create database HRDB;
Select * from hr_tbl;

/*DATA CLEANING*/
Alter table hr_tbl
change column id emp_id VARCHAR(50) NULL;

Describe hr_tbl;

SET sql_safe_updates = 0;  /* this is to switch off the protection to update some values*/

Update hr_tbl
Set birthdate = CASE 
When birthdate LIKE '%/%' then date_format(str_to_date(birthdate,'%m/%d/%Y'),'%Y-%m-%d')
When birthdate LIKE '%-%' then date_format(str_to_date(birthdate,'%m-%d-%Y'),'%Y-%m-%d')
ELSE null 
END;                     /*Changing the date formate for the column birthdate*/


Alter table hr_tbl
Modify column birthdate DATE; /*Changing the datatype of the column birthdate*/

Update hr_tbl
Set hire_date = CASE 
When hire_date LIKE '%/%' then date_format(str_to_date(hire_date,'%m/%d/%Y'),'%Y-%m-%d')
When hire_date LIKE '%-%' then date_format(str_to_date(hire_date,'%m-%d-%Y'),'%Y-%m-%d')
ELSE null 
END;     /*Changing the date formate for the column hire_date*/


Alter table hr_tbl
Modify column hire_date DATE; /*Changing the datatype of the column hire_date*/

Update hr_tbl
SET termdate = date(str_to_date(termdate,'%Y-%m-%d %H:%i:%s UTC'))
WHERE termdate is NOT null and termdate != '';  /*Changed the format for termdate*/

Update hr_tbl 
SET termdate = NULL WHERE termdate ='0000-00-00'  or termdate = ''; /*Insering null in every empty record*/

Select termdate from hr_tbl;

Alter table hr_tbl
Modify column termdate DATE; /*Chaging the datatype for termdate column*/

Alter table hr_tbl Add column age INT; /*adding a new column age*/

Update hr_tbl
Set age = timestampdiff(year, birthdate, curdate()); 
/*This function subtracts the birth year from current year and gives us the age*/

Select Min(age) as Youngest, max(age) as Eldest from hr_tbl;

Select * from hr_tbl;




/*DATA ANALYSING*/
/*QUESTIONS

-- 1. What is the gender breakdown of employees in the company?
-- 2. What is the race/ethnicity breakdown of employees in the company?
-- 3. What is the age distribution of employees in the company?
-- 4. How many employees work at headquarters versus remote locations?
-- 5. What is the average length of employment for employees who have been terminated?
---6. What is the distribution of employees across locations by city and state? */

Select gender,count(*) as total_count from hr_tbl
Where age >= 18 and termdate is NULL
GROUP BY gender order by total_count desc;

Select race, count(*) as race_count from hr_tbl 
Where age >= 18 and termdate is NULL
Group by race order by race_count desc;

Select 
CASE 
When age >= 18 and age <= 24 Then '18-24'
When age >= 25 and age <= 34 Then '25-34'
When age >= 35 and age <= 44 Then '35-44'
When age >= 45 and age <= 54 Then '45-54'
When age >= 55 and age <= 64 Then '55-64'
else '65+'
END as age_group, gender, count(*) age_count from hr_tbl
Where age >= 18 and termdate is NULL
GROUP by age_group, gender Order by age_group, gender asc;

Select location, count(*) as loc_count from hr_tbl
Where age >= 18 and termdate is NULL
Group by location order by loc_count;

Select round(avg(datediff(termdate,hire_date))/365,0) as avg_leg_employment
from hr_tbl
Where termdate <= curdate() and termdate is not null and age >= 18;

Select location_state, count(*) as state_count from hr_tbl
Where age >= 18 and termdate is NULL
GROUP By location_state order by state_count DESC;





