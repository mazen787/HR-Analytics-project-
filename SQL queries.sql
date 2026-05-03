select*from dbo.Dim_Employees_Final
select*from dbo.Dim_Job_Roles_Final
select*from dbo.Fact_Attendance_Final
select*from dbo.Fact_Compensation_Final
select*from dbo.Fact_Engagement_Final
select*from dbo.Fact_Performance_Final;
------------------------------------------------------------
with latest_performance as (
select employee_id, performance_score , promoted_this_year,
ROW_NUMBER() over(partition by employee_id order by review_date desc) as rn
from dbo.Fact_Performance_Final
),

latest_compensation as (
select employee_id , monthly_salary_egp,
ROW_NUMBER() over(partition by employee_id order by effective_date desc) as rn
from dbo.Fact_Compensation_Final
),

departments_avg as (
select department , AVG(monthly_salary_egp) as avg_dept_salary
from latest_compensation C join dbo.Dim_Employees_Final E on C.employee_id = E.employee_id 
join dbo.Dim_Job_Roles_Final J on E.role_id = J.role_id 
where rn = 1
group by department
)

select E.employee_id ,
E.first_name + ' ' + E.last_name as Employee_Name ,
J.department,
J.job_title,
P.performance_score ,
C.monthly_salary_egp as actual_salary ,
D.avg_dept_salary as Department_Avg_Salary ,
CAST((C.monthly_salary_egp / D.avg_dept_salary) * 100 AS DECIMAL(5,2)) AS Salary_vs_Avg_Pct

from Dim_Employees_Final E join latest_performance P on E.employee_id = P.employee_id and P.rn = 1
join latest_compensation C on E.employee_id = C.employee_id and C.rn = 1
join dbo.Dim_Job_Roles_Final J on E.role_id = J.role_id
join departments_avg D on J.department = D.department 

where E.attrition_flag = 0 and P.performance_score >= 4 and P.promoted_this_year = 0 
and c.monthly_salary_egp < D.avg_dept_salary;
--------------------------------------------------
--------------------------------------------------
--------------------------------------------------
;WITH latest_engagment AS (
    SELECT employee_id, manager_satisfaction_score, 
    ROW_NUMBER() OVER(PARTITION BY employee_id ORDER BY survey_date DESC) AS rn
    FROM dbo.Fact_Engagement_Final
    WHERE manager_satisfaction_score IS NOT NULL
),

manager_stats AS (
    SELECT E.manager_id, 
    COUNT(E.employee_id) AS Total_Team_Size,
    SUM(CAST(E.attrition_flag AS INT)) AS Total_Leavers,
    CAST(SUM(CAST(E.attrition_flag AS INT)) * 100.0 / COUNT(E.employee_id) AS DECIMAL(5,2)) AS Team_Attrition_Rate,
    CAST(AVG(ENG.manager_satisfaction_score) AS DECIMAL(5,2)) AS Avg_Manager_Satisfaction
    FROM dbo.Dim_Employees_Final E 
    LEFT JOIN latest_engagment ENG ON E.employee_id = ENG.employee_id AND ENG.rn = 1
    WHERE E.manager_id IS NOT NULL
    AND E.is_ghost_manager_flag = 0
    GROUP BY E.manager_id
)

SELECT M.manager_id, MGR_INFO.first_name + ' ' + MGR_INFO.last_name AS Manager_Name,
M.Total_Team_Size, M.Total_Leavers, M.Team_Attrition_Rate, M.Avg_Manager_Satisfaction
FROM manager_stats M  
JOIN Dim_Employees_Final MGR_INFO ON M.manager_id = MGR_INFO.employee_id
WHERE M.Total_Team_Size >= 5 
AND M.Team_Attrition_Rate > 20.0 
AND M.Avg_Manager_Satisfaction < 3.0 
ORDER BY M.Team_Attrition_Rate DESC, M.Avg_Manager_Satisfaction ASC;
---------------------------------------------------
---------------------------------------------------
---------------------------------------------------
with LatestAttendance AS (
select employee_id , overtime_ratio_pct, sick_leaves_taken, month_year,
ROW_NUMBER() over(partition by employee_id order by month_year desc) as rn
from dbo.Fact_Attendance_Final
),

LatestEngagement AS (
select employee_id , work_life_balance_score , environment_satisfaction , 
ROW_NUMBER() over(partition by employee_id order by survey_date desc) as rn
from dbo.Fact_Engagement_Final
)

select E.employee_id , E.first_name + ' ' + E.last_name as Employee_Name , 
JR.department , JR.job_title, 
LA.overtime_ratio_pct as Overtime_Percentage , 
LA.sick_leaves_taken as Recent_Sick_Leaves , 
LE.work_life_balance_score as WLB_Score
from dbo.Dim_Employees_Final E Join LatestAttendance LA on E.employee_id = LA.employee_id and LA.rn = 1
join LatestEngagement LE on E.employee_id = LE.employee_id and LE.rn = 1
join dbo.Dim_Job_Roles_Final JR on E.role_id = JR.role_id 

where 
E.attrition_flag = 0 and LA.overtime_ratio_pct > 20.0 and LA.sick_leaves_taken >= 3 and LE.work_life_balance_score <= 2
order by LA.overtime_ratio_pct desc , LA.sick_leaves_taken desc

------------------------------------
------------------------------------
------------------------------------
-- 5. Salary Compression (The Loyalty Penalty): New Hires vs. Veterans

WITH LatestCompensation AS (
    SELECT employee_id, monthly_salary_egp,
    ROW_NUMBER() OVER(PARTITION BY employee_id ORDER BY effective_date DESC) as rn
    FROM Fact_Compensation_Final
),

EmpData AS (
    SELECT 
        R.department,
        R.job_title,
        E.tenure_years,
        C.monthly_salary_egp
    FROM Dim_Employees_Final E
    JOIN LatestCompensation C ON E.employee_id = C.employee_id AND C.rn = 1
    JOIN Dim_Job_Roles_Final R ON E.role_id = R.role_id
    WHERE E.attrition_flag = 0 -- ÇáãæÙİíä Çááí áÓå ÔÛÇáíä İŞØ
)

SELECT 
    department AS Department,
    job_title AS Job_Title,
    -- ÍÓÇÈ ãÊæÓØ ÑÇÊÈ ÇáãæÙİ ÇáÌÏíÏ (ÎÈÑÉ ÃŞá ãä ÓäÉ æäÕ İí ÇáÔÑßÉ)
    CAST(AVG(CASE WHEN tenure_years <= 1.5 THEN monthly_salary_egp END) AS INT) AS Avg_New_Hire_Salary,
    
    -- ÍÓÇÈ ãÊæÓØ ÑÇÊÈ ÇáãæÙİ ÇáŞÏíã (ÔÛÇá ÈŞÇáå 4 Óäíä Ãæ ÃßÊÑ)
    CAST(AVG(CASE WHEN tenure_years >= 4.0 THEN monthly_salary_egp END) AS INT) AS Avg_Veteran_Salary,
    
    -- ÍÓÇÈ ÇáİÌæÉ (ÇáÌÏíÏ ÈíÇÎÏ ÃßÊÑ ãä ÇáŞÏíã ÈßÇã¿)
    CAST(AVG(CASE WHEN tenure_years <= 1.5 THEN monthly_salary_egp END) - 
         AVG(CASE WHEN tenure_years >= 4.0 THEN monthly_salary_egp END) AS INT) AS Loyalty_Penalty_Gap
FROM 
    EmpData
GROUP BY 
    department, job_title
-- ÇáÔÑØ Ïå ÚÔÇä äÌíÈ ÈÓ ÇáæÙÇÆİ Çááí İíåÇ "ÇáÌÏíÏ ÈíÇÎÏ ÃßÊÑ ãä ÇáŞÏíã"
HAVING 
    AVG(CASE WHEN tenure_years <= 1.5 THEN monthly_salary_egp END) > 
    AVG(CASE WHEN tenure_years >= 4.0 THEN monthly_salary_egp END)
ORDER BY 
    Loyalty_Penalty_Gap DESC;

