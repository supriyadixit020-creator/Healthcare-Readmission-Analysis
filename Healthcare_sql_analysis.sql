


------------------------------------------------- PHASE 1 : DATABASE SETUP & Data Exploration


-- Create Database
CREATE DATABASE Healthcare_Readmission_DB;


USE Healthcare_Readmission_DB;



select * from  healthcare_data

SELECT TOP 10 *
FROM healthcare_data;

-- Total Records
SELECT COUNT(*) AS Total_Records
FROM healthcare_data;

-- Total Columns
SELECT COUNT(*)
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME='healthcare_data';

-- Duplicate Patient Check
SELECT COUNT(DISTINCT patient_nbr)
FROM healthcare_data;


-- Readmission Distribution
SELECT
readmitted,
COUNT(*) AS Total_Patients,
ROUND(
COUNT(*)*100.0/
SUM(COUNT(*)) OVER(),2
) AS Percentage
FROM healthcare_data
GROUP BY readmitted
ORDER BY Total_Patients DESC;

-- Gender Distribution

SELECT
gender,
COUNT(*) AS Total_Patients,
ROUND(
COUNT(*)*100.0/
SUM(COUNT(*)) OVER(),2
) AS Percentage
FROM healthcare_data
GROUP BY gender;

-- Age Distribution

SELECT
age,
COUNT(*) AS Total_Patients
FROM healthcare_data
GROUP BY age
ORDER BY age;

-------------------------------------------------- Phase 2: Business Questions


-- ============================================
-- Business Question 1
-- Overall Hospital Readmission Distribution
-- ============================================

SELECT
    readmitted AS Readmission_Status,
    COUNT(*) AS Total_Patients,

    ROUND(
        COUNT(*) * 100.0 /
        SUM(COUNT(*)) OVER (),
        2
    ) AS Percentage

FROM healthcare_data

GROUP BY readmitted

ORDER BY Total_Patients DESC;

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
Business Insight:
- 53.69% of diabetic patients were not readmitted.
- 46.31% experienced at least one hospital readmission.
- Reducing readmissions represents a significant opportunity to improve patient outcomes and optimize healthcare resources.
*/
/*
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Business Recommendation:

- Develop comprehensive discharge planning programs for diabetic patients.
- Schedule follow-up appointments within 30 days after discharge for high-risk patients.
- Implement patient education programs focusing on diabetes self-management and medication adherence.
- Monitor hospital readmission rates regularly as a key performance indicator (KPI) to evaluate quality of care.
*/

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ============================================
-- Business Question 2
-- Patient Distribution by Age
-- ============================================

SELECT

    age AS Age_Group,

    COUNT(*) AS Total_Patients,

    ROUND(
        COUNT(*) * 100.0 /
        SUM(COUNT(*)) OVER (),
        2
    ) AS Percentage

FROM healthcare_data

GROUP BY age

ORDER BY age;

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
Business Insight:
- Patients aged 70–80 years accounted for the largest share of hospital admissions (25.83%).
- Nearly half of all admissions involved patients aged 60–80 years.
- Younger patients represented only a small proportion of diabetic hospitalizations.
- Hospitals should prioritize preventive care and chronic disease management for older adults.
*/
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
Business Recommendation:

- Allocate additional healthcare resources for older adults (60–80 years), as they represent the largest patient population.
- Design age-specific diabetes management and preventive care programs.
- Encourage regular health screenings and early intervention for elderly patients to reduce future complications.
- Plan hospital staffing and chronic disease management services based on the age distribution of patients.
*/
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


-- ============================================
-- Business Question 3
-- Patient Distribution by Gender
-- ============================================

SELECT

    gender,

    COUNT(*) AS Total_Patients,

    CAST(
        ROUND(
            COUNT(*) * 100.0 /
            SUM(COUNT(*)) OVER(),2
        )
    AS DECIMAL(5,2)) AS Percentage

FROM healthcare_data

GROUP BY gender

ORDER BY Total_Patients DESC;
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
Business Insight:
- Female patients represented 53.79% of the diabetic patient population.
- Male patients accounted for 46.21%.
- The gender distribution is relatively balanced, suggesting that diabetes-related hospitalizations affect both genders similarly.
*/
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
Business Recommendation:

- Continue providing equitable healthcare services for both male and female patients.
- Focus care strategies on clinical risk factors rather than gender alone, as the gender distribution is relatively balanced.
- Monitor gender-based healthcare outcomes periodically to ensure consistent quality of care across all patients.
*/
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ============================================
-- Business Question 4
-- Readmission by Age Group
-- ============================================

WITH Age_Readmission AS
(
    SELECT
        age,
        readmitted,
        COUNT(*) AS Total_Patients
    FROM healthcare_data
    GROUP BY age, readmitted
)

SELECT

    age AS Age_Group,

    readmitted AS Readmission_Status,

    Total_Patients,

    CAST(
        ROUND(
            Total_Patients * 100.0 /
            SUM(Total_Patients) OVER(PARTITION BY age),
        2)
    AS DECIMAL(5,2)) AS Percentage

FROM Age_Readmission

ORDER BY age, readmitted;

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
Business Insight:

- Patients aged 70–80 years had the highest proportion of readmissions after 30 days (36.41%).
- Patients aged 80–90 years also experienced a high readmission rate (>30 days: 36.21%).
- Younger age groups represented a much smaller share of hospital admissions and readmissions.
- Elderly diabetic patients should be considered a high-risk population requiring enhanced discharge planning and follow-up care.
*/
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
Business Recommendation:

Hospitals should prioritize follow-up care, medication counseling, and discharge planning for elderly diabetic patients (60–90 years) to reduce avoidable hospital readmissions.
*/
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- ============================================
-- Business Question 5
-- Rank Age Groups by 30-Day Readmission
-- ============================================

WITH Readmission30 AS
(
    SELECT
        age,
        COUNT(*) AS Readmission_Count
    FROM healthcare_data
    WHERE readmitted = '<30'
    GROUP BY age
)

SELECT

    age AS Age_Group,

    Readmission_Count,

    DENSE_RANK() OVER(
        ORDER BY Readmission_Count DESC
    ) AS Readmission_Rank

FROM Readmission30

ORDER BY Readmission_Rank;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
Business Insight:

- Patients aged 70–80 years ranked first in 30-day hospital readmissions.
- Patients aged 60–70 and 80–90 years also recorded high readmission counts.
- The majority of early readmissions occurred among elderly diabetic patients.
- Age should be considered an important factor when identifying patients at high risk of readmission.
*/
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
Business Recommendation:

Hospitals should implement risk-based discharge planning and follow-up programs for elderly diabetic patients, particularly those aged 60–80 years, to reduce early hospital readmissions.
*/
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ============================================
-- Business Question 6
-- Readmission by Admission Type
-- ============================================

WITH Admission_Readmission AS
(
    SELECT
        admission_type,
        readmitted,
        COUNT(*) AS Total_Patients
    FROM healthcare_data
    GROUP BY admission_type, readmitted
)

SELECT

    admission_type,

    readmitted,

    Total_Patients,

    CAST(
        ROUND(
            Total_Patients * 100.0 /
            SUM(Total_Patients) OVER(PARTITION BY admission_type),
        2)
    AS DECIMAL(5,2)) AS Percentage

FROM Admission_Readmission

ORDER BY admission_type, readmitted;

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
Business Insight:

- Emergency admissions recorded the highest proportion of readmissions compared with elective admissions.
- Elective admissions had the highest percentage of patients with no readmission (59.01%).
- Unknown admission types showed the highest readmission after 30 days (42.35%), but this category should be interpreted cautiously due to data quality limitations.
- Emergency admissions represent a higher-risk patient group and may require additional post-discharge support.
*/
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
Business Recommendation:

- Strengthen discharge planning for emergency admissions.
- Schedule follow-up appointments within 30 days for patients admitted through emergency services.
- Improve documentation to reduce records classified as "Unknown" admission types.
- Develop targeted care pathways for high-risk emergency diabetic patients.
*/
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ============================================
-- Business Question 7
-- Readmission by Stay Category
-- ============================================

WITH Stay_Readmission AS
(
    SELECT
        stay_category,
        readmitted,
        COUNT(*) AS Total_Patients
    FROM healthcare_data
    GROUP BY stay_category, readmitted
)

SELECT

    stay_category,

    readmitted,

    Total_Patients,

    CAST(
        ROUND(
            Total_Patients * 100.0 /
            SUM(Total_Patients) OVER(PARTITION BY stay_category),
        2)
    AS DECIMAL(5,2)) AS Percentage

FROM Stay_Readmission

ORDER BY stay_category, readmitted;

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
Business Insight:

- Long-stay patients had the highest 30-day readmission rate (13.40%).
- Short-stay patients recorded the highest percentage of no readmission (56.50%).
- Readmission risk increased as the duration of hospital stay increased.
- Length of stay can be considered an important indicator of patient complexity and future readmission risk.
*/
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
Business Recommendation:

- Prioritize discharge planning for patients with medium and long hospital stays.
- Implement post-discharge monitoring for patients hospitalized for extended periods.
- Use hospital stay duration as a risk factor when planning follow-up care.
- Enhance discharge education and medication counseling for long-stay patients.
*/
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ============================================
-- Business Question 8
-- Readmission by Medication Load
-- ============================================

WITH Medication_Readmission AS
(
    SELECT
        medication_load,
        readmitted,
        COUNT(*) AS Total_Patients
    FROM healthcare_data
    GROUP BY medication_load, readmitted
)

SELECT

    medication_load,

    readmitted,

    Total_Patients,

    CAST(
        ROUND(
            Total_Patients * 100.0 /
            SUM(Total_Patients) OVER(PARTITION BY medication_load),
        2)
    AS DECIMAL(5,2)) AS Percentage

FROM Medication_Readmission

ORDER BY medication_load, readmitted;
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
Business Insight:

- Patients with a low medication load had the highest percentage of no readmission (60.04%).
- Patients with medium and high medication loads experienced higher readmission rates than those with low medication loads.
- Higher medication burden may indicate greater disease severity, multiple chronic conditions, or more complex treatment plans.
- Medication load can serve as an important indicator for identifying patients at higher risk of hospital readmission.
*/
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
Business Recommendation:

- Prioritize medication reconciliation before discharge for patients with medium and high medication loads.
- Increase pharmacist involvement in discharge planning.
- Provide medication counseling and adherence support for patients prescribed multiple medications.
- Schedule follow-up reviews to ensure medication compliance after discharge.
*/
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ============================================
-- Business Question 9
-- Rank Medication Load by 30-Day Readmission
-- ============================================

WITH Medication30 AS
(
    SELECT
        medication_load,
        COUNT(*) AS Readmission_Count
    FROM healthcare_data
    WHERE readmitted = '<30'
    GROUP BY medication_load
)

SELECT

    medication_load,

    Readmission_Count,

    DENSE_RANK() OVER(
        ORDER BY Readmission_Count DESC
    ) AS Readmission_Rank

FROM Medication30;
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
Business Insight:

- Patients with a medium medication load ranked first in 30-day hospital readmissions.
- High medication load patients ranked second, while low medication load patients ranked third.
- Patients taking a larger number of medications are more likely to require additional clinical monitoring after discharge.
*/
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
Business Recommendation:

- Develop risk-based medication management programs for patients prescribed multiple medications.
- Flag medium and high medication load patients for early follow-up after discharge.
- Monitor medication adherence to reduce preventable hospital readmissions.
*/
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- ============================================
-- Business Question 10
-- Top Medical Specialties
-- ============================================

SELECT TOP 10

    medical_specialty,

    COUNT(*) AS Total_Patients,

    CAST(
        ROUND(
            COUNT(*) * 100.0 /
            SUM(COUNT(*)) OVER(),
        2)
    AS DECIMAL(5,2)) AS Percentage

FROM healthcare_data

GROUP BY medical_specialty

ORDER BY Total_Patients DESC;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
Business Insight:

- Nearly half of all patient records (49.36%) have an unknown medical specialty, indicating a significant data quality issue.
- Among the recorded specialties, Internal Medicine managed the highest number of diabetic patients.
- Emergency/Trauma and Family/General Practice were the next most common specialties.
- Improving specialty documentation would enable more accurate clinical performance analysis and resource planning.
*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
Business Recommendation:

- Improve hospital documentation practices to reduce missing medical specialty information.
- Allocate sufficient healthcare resources to Internal Medicine and Emergency departments, as they manage a large proportion of diabetic patients.
- Regularly audit missing specialty records to improve data quality for future clinical and operational analysis.
*/
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ============================================
-- Business Question 11
-- Top Medical Specialties by 30-Day Readmission
-- ============================================

SELECT TOP 10

    medical_specialty,

    COUNT(*) AS Readmission_Count

FROM healthcare_data

WHERE readmitted='<30'

GROUP BY medical_specialty

ORDER BY Readmission_Count DESC;
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
Business Insight:

- Nearly half of the 30-day readmission records belong to patients with an unknown medical specialty, indicating incomplete clinical documentation.
- Among the documented specialties, Internal Medicine recorded the highest number of 30-day readmissions.
- Family/General Practice and Emergency/Trauma also contributed substantially to early hospital readmissions.
- Better documentation of medical specialties would enable more accurate performance evaluation across hospital departments.
*/
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
Business Recommendation:

- Improve documentation practices to reduce missing medical specialty information.
- Prioritize readmission reduction initiatives within Internal Medicine and Emergency departments.
- Conduct periodic audits of specialty-wise readmission trends to identify improvement opportunities.
- Allocate additional clinical resources to departments managing the largest number of diabetic readmissions.
*/
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ============================================
-- Business Question 12
-- Patients Taking Above Average Medications
-- ============================================

SELECT

    patient_nbr,

    num_medications,

    age,

    readmitted

FROM healthcare_data

WHERE num_medications >
(
    SELECT AVG(num_medications)
    FROM healthcare_data
)

ORDER BY num_medications DESC;
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
Business Insight:

- Patients taking more than the average number of medications represent a high-risk population with complex treatment requirements.
- The highest medication count reached 81, with most high-medication patients belonging to the 50–80 years age group.
- Many of these patients also experienced early (<30 days) or late (>30 days) readmissions, indicating a possible relationship between medication burden and readmission risk.
- High medication usage may reflect multiple chronic conditions requiring closer clinical monitoring.
*/
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
Business Recommendation:

- Implement regular medication review programs for patients receiving above-average medications.
- Strengthen discharge planning and medication counselling for high-risk diabetic patients.
- Schedule post-discharge follow-up calls for patients with complex medication regimens.
- Develop a high-risk patient monitoring dashboard using medication count as one of the key indicators.
*/
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ============================================
-- Business Question 13
-- High-Risk Patient Segmentation
-- ============================================

SELECT

    patient_nbr,
    age,
    num_medications,
    total_visits,
    time_in_hospital,
    readmitted,

    CASE

        WHEN total_visits >=5
             AND num_medications>=20
             AND time_in_hospital>=7
        THEN 'High Risk'

        WHEN total_visits>=2
             AND num_medications>=10
        THEN 'Medium Risk'

        ELSE 'Low Risk'

    END AS Risk_Level

FROM healthcare_data

ORDER BY
Risk_Level DESC,
num_medications DESC;
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
Business Insight:

- Patients were categorized into High, Medium, and Low Risk based on hospital visits, medication count, and length of hospital stay.
- High-Risk patients generally had frequent hospital visits, longer admissions, and higher medication usage.
- Medium-Risk patients formed a large portion of the population, indicating many diabetic patients require continuous monitoring.
- Risk segmentation helps hospitals prioritize patients who are more likely to require additional care after discharge.
*/
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
Business Recommendation:

- Implement automated risk scoring during patient admission and discharge.
- Schedule follow-up consultations for High-Risk patients within 7 days of discharge.
- Assign care coordinators to monitor High-Risk diabetic patients.
- Integrate risk segmentation into hospital dashboards for continuous monitoring.
*/
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ============================================
-- Business Question 14
-- Top High-Risk Age Groups
-- ============================================

WITH Risk_Group AS
(
    SELECT

        age,

        COUNT(*) AS High_Risk_Patients

    FROM healthcare_data

    WHERE
        total_visits>=5
        AND num_medications>=20
        AND time_in_hospital>=7

    GROUP BY age
)

SELECT

    age,

    High_Risk_Patients,

    DENSE_RANK() OVER
    (
        ORDER BY High_Risk_Patients DESC
    ) AS Risk_Rank

FROM Risk_Group

ORDER BY Risk_Rank;
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
Business Insight:

- Patients aged 70–80 years had the highest number of High-Risk cases (213), followed closely by the 60–70 years age group (206).
- Individuals between 50–80 years represented the majority of High-Risk diabetic patients.
- Younger patients contributed very few High-Risk cases, indicating that severe diabetic complications are more common among older adults.
- Age is a significant factor in identifying patients who require intensive clinical monitoring.
*/
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
Business Recommendation:

- Prioritize patients aged 50 years and above for chronic disease management programs.
- Increase post-discharge follow-up frequency for elderly diabetic patients.
- Provide personalized care plans for patients aged 60–80 years to reduce readmission risk.
- Include age-based risk indicators in hospital performance dashboards for proactive decision-making.
*/
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
