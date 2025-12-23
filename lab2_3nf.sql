-- Лабораторная работа №2. Часть 1: Модель в третьей нормальной форме (3NF)
-- Система функционирования торгового отдела

CREATE TABLE Employees (
    employee_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone_number VARCHAR(20)
);

CREATE TABLE Customers (
    customer_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100),
    phone_number VARCHAR(20),
    address TEXT
);

CREATE TABLE Products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL CHECK (price >= 0)
);

CREATE TABLE Orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT NOT NULL REFERENCES Customers(customer_id) ON DELETE RESTRICT,
    employee_id INT NOT NULL REFERENCES Employees(employee_id) ON DELETE RESTRICT,
    order_date DATE NOT NULL DEFAULT CURRENT_DATE,
    total_amount DECIMAL(10, 2) NOT NULL CHECK (total_amount >= 0)
);

CREATE TABLE OrderItems (
    order_item_id SERIAL PRIMARY KEY,
    order_id INT NOT NULL REFERENCES Orders(order_id) ON DELETE CASCADE,
    product_id INT NOT NULL REFERENCES Products(product_id) ON DELETE RESTRICT,
    quantity INT NOT NULL CHECK (quantity > 0),
    unit_price DECIMAL(10, 2) NOT NULL CHECK (unit_price >= 0)
);CREATE DATABASE emergency_admission;

CREATE TABLE Patients (
    patient_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    middle_name VARCHAR(50),
    date_of_birth DATE NOT NULL,
    gender CHAR(1) CHECK (gender IN ('М', 'Ж')),
    phone VARCHAR(20),
    address TEXT
);

CREATE TABLE Doctors (
    doctor_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    middle_name VARCHAR(50),
    specialization VARCHAR(100) NOT NULL,
    license_number VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE Wards (
    ward_id SERIAL PRIMARY KEY,
    ward_number INT NOT NULL UNIQUE,
    department VARCHAR(100),
    capacity INT NOT NULL CHECK (capacity > 0)
);

CREATE TABLE Diagnoses (
    diagnosis_id SERIAL PRIMARY KEY,
    diagnosis_code VARCHAR(20) UNIQUE NOT NULL,
    diagnosis_name VARCHAR(200) NOT NULL
);

CREATE TABLE Admissions (
    admission_id SERIAL PRIMARY KEY,
    patient_id INT NOT NULL REFERENCES Patients(patient_id) ON DELETE RESTRICT,
    doctor_id INT NOT NULL REFERENCES Doctors(doctor_id) ON DELETE RESTRICT,
    ward_id INT REFERENCES Wards(ward_id) ON DELETE SET NULL,
    diagnosis_id INT REFERENCES Diagnoses(diagnosis_id) ON DELETE SET NULL,
    admission_datetime TIMESTAMP NOT NULL DEFAULT NOW(),
    discharge_datetime TIMESTAMP,
    status VARCHAR(20) NOT NULL CHECK (status IN ('в обработке', 'госпитализирован', 'отказано', 'выписан'))
);