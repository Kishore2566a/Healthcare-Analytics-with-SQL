create schema healthcare;
use healthcare;
SELECT
    p.name AS patient_name,
    d.name AS doctor_name,
    d.specialization
FROM
    appointments a
JOIN
    patients p ON a.patient_id = p.patient_id
JOIN
    doctors d ON a.doctor_id = d.doctor_id
WHERE
    a.status = 'Completed';
    #task2
   SELECT
    p.name,
    p.contact_number,
    p.address
FROM
    patients p
LEFT JOIN
    appointments a ON p.patient_id = a.patient_id
WHERE
    a.appointment_id IS NULL; 
    use healthcare
    #task3
CREATE INDEX idx_patient_id ON appointments(patient_id);
CREATE INDEX idx_doctor_id ON appointments(doctor_id);
CREATE INDEX idx_patient_id ON diagnoses(patient_id);
CREATE INDEX idx_doctor_id ON diagnoses(doctor_id);
CREATE INDEX idx_patient_id ON patients(patient_id);
CREATE INDEX idx_doctor_id ON doctors(doctor_id);
SHOW INDEXES FROM appointments;
-- Left Join to get all appointments with matching diagnoses
SELECT
    a.appointment_id,
    a.patient_id,
    a.doctor_id,
    a.appointment_date,
    a.reason AS appointment_reason,
    p.name AS patient_name,
    p.contact_number AS patient_contact,
    d.diagnosis_id,
    d.diagnosis,
    d.treatment,
    dr.name AS doctor_name,
    dr.specialization AS doctor_specialization
FROM appointments a
LEFT JOIN diagnoses d ON a.patient_id = d.patient_id AND a.doctor_id = d.doctor_id
LEFT JOIN patients p ON a.patient_id = p.patient_id
LEFT JOIN doctors dr ON a.doctor_id = dr.doctor_id

UNION

-- Right Join to get all diagnoses with matching appointments
SELECT
    a.appointment_id,
    a.patient_id,
    a.doctor_id,
    a.appointment_date,
    a.reason AS appointment_reason,
    p.name AS patient_name,
    p.contact_number AS patient_contact,
    d.diagnosis_id,
    d.diagnosis,
    d.treatment,
    dr.name AS doctor_name,
    dr.specialization AS doctor_specialization
FROM diagnoses d
RIGHT JOIN appointments a ON d.patient_id = a.patient_id AND d.doctor_id = a.doctor_id
RIGHT JOIN patients p ON d.patient_id = p.patient_id
RIGHT JOIN doctors dr ON d.doctor_id = dr.doctor_id;
SELECT
    d.name AS doctor_name,
    p.name AS patient_name,
    COUNT(a.appointment_id) AS appointment_count,
    RANK() OVER (PARTITION BY d.doctor_id ORDER BY COUNT(a.appointment_id) DESC) AS patient_rank
FROM
    appointments a
JOIN
    doctors d ON a.doctor_id = d.doctor_id
JOIN
    patients p ON a.patient_id = p.patient_id
GROUP BY
    d.doctor_id, d.name, p.patient_id, p.name
ORDER BY
    d.name, patient_rank;
SELECT
    CASE
        WHEN age BETWEEN 18 AND 30 THEN '18-30'
        WHEN age BETWEEN 31 AND 50 THEN '31-50'
        WHEN age >= 51 THEN '51+'
        ELSE 'Other'
    END AS age_group,
    COUNT(patient_id) AS patient_count
FROM
    patients
GROUP BY
    age_group;
SELECT
    UPPER(name) AS patient_name_uppercase,
    contact_number
FROM
    patients
WHERE
    contact_number LIKE '%1234';

SELECT p.patient_id, p.name
FROM patients p
WHERE p.patient_id IN (
    SELECT DISTINCT d.patient_id
    FROM diagnoses d
    JOIN medications m ON d.diagnosis_id = m.diagnosis_id
    WHERE m.medication_name = 'Insulin'
)
AND p.patient_id NOT IN (
    SELECT DISTINCT d.patient_id
    FROM diagnoses d
    JOIN medications m ON d.diagnosis_id = m.diagnosis_id
    WHERE m.medication_name != 'Insulin'
);

SELECT d.diagnosis, 
       AVG(DATEDIFF(m.end_date, m.start_date)) AS avg_duration_in_days
FROM medications m
JOIN diagnoses d ON m.diagnosis_id = d.diagnosis_id
GROUP BY d.diagnosis;
SELECT
    d.name AS doctor_name,
    d.specialization,
    COUNT(DISTINCT a.patient_id) AS unique_patient_count
FROM
    doctors d
JOIN
    appointments a ON d.doctor_id = a.doctor_id
GROUP BY
    d.doctor_id, d.name, d.specialization
ORDER BY
    unique_patient_count DESC
LIMIT 1;



















