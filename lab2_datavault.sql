CREATE DATABASE emergency_admission_dv;

-- Создание Хабов (Hubs)
CREATE TABLE Hub_Patients (
    patient_id INT PRIMARY KEY
);

CREATE TABLE Hub_Doctors (
    doctor_id INT PRIMARY KEY
);

CREATE TABLE Hub_Wards (
    ward_id INT PRIMARY KEY
);

CREATE TABLE Hub_Diagnoses (
    diagnosis_id INT PRIMARY KEY
);

-- Создание Связей (Links)
CREATE TABLE Lnk_Admissions (
    admission_id INT PRIMARY KEY,
    patient_id INT NOT NULL REFERENCES Hub_Patients(patient_id),
    doctor_id INT NOT NULL REFERENCES Hub_Doctors(doctor_id),
    ward_id INT REFERENCES Hub_Wards(ward_id),
    admission_datetime TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE Lnk_AdmissionDiagnosis (
    admission_diagnosis_id SERIAL PRIMARY KEY,
    admission_id INT NOT NULL REFERENCES Lnk_Admissions(admission_id),
    diagnosis_id INT NOT NULL REFERENCES Hub_Diagnoses(diagnosis_id)
);

-- Создание Спутников (Satellites)
CREATE TABLE Sat_Patients (
    patient_id INT NOT NULL REFERENCES Hub_Patients(patient_id),
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    middle_name VARCHAR(50),
    date_of_birth DATE NOT NULL,
    gender CHAR(1) CHECK (gender IN ('М', 'Ж')),
    phone VARCHAR(20),
    address TEXT
);

CREATE TABLE Sat_Doctors (
    doctor_id INT NOT NULL REFERENCES Hub_Doctors(doctor_id),
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    middle_name VARCHAR(50),
    specialization VARCHAR(100) NOT NULL,
    license_number VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE Sat_Wards (
    ward_id INT NOT NULL REFERENCES Hub_Wards(ward_id),
    ward_number INT NOT NULL UNIQUE,
    department VARCHAR(100),
    capacity INT NOT NULL CHECK (capacity > 0)
);

CREATE TABLE Sat_Diagnoses (
    diagnosis_id INT NOT NULL REFERENCES Hub_Diagnoses(diagnosis_id),
    diagnosis_code VARCHAR(20) UNIQUE NOT NULL,
    diagnosis_name VARCHAR(200) NOT NULL
);

CREATE TABLE Sat_Admissions (
    admission_id INT NOT NULL REFERENCES Lnk_Admissions(admission_id),
    discharge_datetime TIMESTAMP,
    status VARCHAR(20) NOT NULL CHECK (status IN ('в обработке', 'госпитализирован', 'отказано', 'выписан'))
);