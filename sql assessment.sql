create database diabetes;
use diabetes;
create table diabetes_prediction(
EmploueeName VARCHAR(50),
P_ID         VARCHAR(45)   PRIMARY KEY,
gender       VARCHAR(45),
DOB          VARCHAR(12),
hypertentionsion   double,
heart_disease       double,
smoking_history    VARCHAR(45),
bmi           decimal(5,2),
HBa1_level    decimal(3,1),
blood_glucose_level   decimal(5,1),
diabetes    int);

LOAD DATA INFILE 'D:\Diabetes_prediction.csv' 
#IGNORE 
INTO TABLE diabetes_prediction
FIELDS TERMINATED BY ',' 
ignore 1 lines
;
select * from diabetes_prediction;
select count(*) from diabetes_prediction;

# 1. Retrieve the Patient_id and ages of all patients.
commit;

select P_ID, Year(curdate()) - year(str_to_date(dob, '%d-%m-%Y')) AS Age  from diabetes_prediction;

#2. Select all female patients who are older than 40.
select gender from diabetes_prediction
where gender like 'female' and Year(curdate()) - year(str_to_date(dob, '%d-%m-%Y')) > 40;

#3. Calculate the average BMI of patients.
select Avg(BMI) from diabetes_prediction;

#4. List patients in descending order of blood glucose levels.
select blood_glucose_level from diabetes_prediction
order by blood_glucose_level desc ;

#5. Find patients who have hypertension and diabetes.
select hypertension, diabetes from diabetes_prediction
where hypertension=1 and diabetes=1;

#6. Determine the number of patients with heart disease.
select count(heart_disease) from diabetes_prediction 
where heart_disease=1;

#7. Group patients by smoking history and count how many smokers and non-smokers there are.
select smoking_history,count(*) from diabetes_prediction 
group by smoking_history; 
select smoking_history,count(*) from diabetes_prediction 
where smoking_history in ('ever','never') group by smoking_history;

#8. Retrieve the Patient_ids of patients who have a BMI greater than the average BMI.
select P_ID, bmi from diabetes_prediction
where bmi > (select avg(bmi) from diabetes_prediction)
order by P_ID ASC;

#9. Find the patient with the highest HbA1c level and the patient with the lowest HbA1clevel.
SELECT * FROM diabetes_prediction order by HBa1_level desc limit 1;
select * from diabetes_prediction order by HBa1_level asc limit 1;

#10. Calculate the age of patients in years (assuming the current date as of now).

select EmployeeName,P_ID, year(str_to_date(dob, '%d-%m-%Y')) AS Birth_Year, Year(curdate()) - year(str_to_date(dob, '%d-%m-%Y')) AS Age  from diabetes_prediction;

#11. Rank patients by blood glucose level within each gender group.
select EmployeeName,gender,blood_glucose_level,
RANK () OVER (PARTITION by gender order by blood_glucose_level) AS glucose_level from diabetes_prediction;


#12. Update the smoking history of patients who are Older than 50 to "Ex-smoker".
update diabetes_prediction
set smoking_history = "Ex-smoker" where dob in (
select dob from diabetes_prediction where (year(curdate()) - year(str_to_date(dob, "%d-%m-%Y"))) > 50 
);

#13. Insert a new patient into the database with sample data.
INSERT INTO diabetes_prediction(EmployeeName,P_ID,gender,DOB,hypertension,heart_disease,smoking_history,bmi,HBa1_level,blood_glucose_level,diabetes)
values('Mohanraaj','PT199998','Male',16-03-1992,1,1,'never',22.12,4.6,80.0,1),
('anurag naik','PT199994','Male',06-02-2017,0,0,'ever',88.0,7.8,88.0,0);

#14. Delete all patients with heart disease from the database.
DELETE FROM diabetes_prediction
where heart_disease=1;

#15. Find patients who have hypertension but not diabetes using the EXCEPT operator.
select EmployeeName, P_ID from diabetes_prediction where hypertension = 1 and diabetes = 0;
select EmployeeName,P_ID,hypertension,diabetes from diabetes_prediction where hypertension=1 and diabetes=0;

(select EmployeeName,P_ID,hypertension,diabetes from diabetes_prediction d1 where d1.hypertension = 1 and not exists(
select 1 from diabetes_prediction d2 where d1.P_ID = d2.P_ID and d2.diabetes = 1)) ;



select count(D.P_ID) from (select P_ID from diabetes_prediction where hypertension = 1 and diabetes = 0) D
left join
(select P_ID from diabetes_prediction d1 where d1.hypertension = 1 and not exists(
select 1 from diabetes_prediction d2 where d1.P_ID = d2.P_ID and d2.diabetes = 1)) A
ON D.P_ID = A.P_ID;

#16. Define a unique constraint on the "patient_id" column to ensure its values are unique.
ALTER TABLE diabetes_prediction
ADD constraint unique_P_ID UNIQUE  (P_ID);

#17. Create a view that displays the Patient_ids, ages, and BMI of patients.
create view petient_view AS
select P_ID,(YEAR(curdate())-year(str_to_date(dob, '%d-%m-%y'))) as age,bmi from diabetes_prediction; 
select * from petient_view;


