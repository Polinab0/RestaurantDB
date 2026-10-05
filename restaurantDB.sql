SET default_storage_engine = 'InnoDB';

DROP DATABASE IF EXISTS RestaurantDB;

CREATE DATABASE RestaurantDB;

USE RestaurantDB;


CREATE TABLE Restaurant (

    restaurantID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    address VARCHAR(255) NOT NULL,
    phone VARCHAR(20),
    email VARCHAR(100)

);


CREATE TABLE Customer (

    customerID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    firstName VARCHAR(100) NOT NULL,
    lastName VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    email VARCHAR(100)

);


CREATE TABLE Table_area (

    areaID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    areaName VARCHAR(100) NOT NULL

);


CREATE TABLE Booking_Status (

    statusID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    statusName VARCHAR(50) NOT NULL

);


CREATE TABLE Restaurant_Table (

    tableID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    restaurantID INT NOT NULL,
    areaID INT NOT NULL,
    tableNumber INT NOT NULL,
    capacity INT NOT NULL,

    FOREIGN KEY (restaurantID) REFERENCES Restaurant(restaurantID),
    FOREIGN KEY (areaID) REFERENCES Table_area(areaID)

);


CREATE TABLE Booking (

    bookingID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    customerID INT NOT NULL,
    tableID INT NOT NULL,
    statusID INT NOT NULL,
    bookingDate DATE NOT NULL,
    bookingTime TIME NOT NULL,
    numberOfGuests INT NOT NULL CHECK (numberOfGuests BETWEEN 1 AND 8),

    FOREIGN KEY (customerID) REFERENCES Customer(customerID),
    FOREIGN KEY (tableID) REFERENCES Restaurant_Table(tableID),
    FOREIGN KEY (statusID) REFERENCES Booking_Status(statusID)

);


-- Insert sample data into Restaurant
INSERT INTO Restaurant (name, address, phone, email)
VALUES
('Nordic Table', 'Main Street 10, Esbjerg', '12345678', 'info@restaurant.dk');


-- Insert sample data into Customer
INSERT INTO Customer (firstName, lastName, phone, email)
VALUES
('Line', 'Doe', '87654321', 'line.doe@example.com'),
('Emma', 'Jensen', '22334455', 'emma.jensen@example.com'),
('Lucas', 'Nielsen', '33445566', 'lucas.nielsen@example.com');


-- Insert sample data into Table_area
INSERT INTO Table_area (areaName)
VALUES
('Indoor'),
('Terrace'),
('Window Area');


-- Insert sample data into Booking_Status
INSERT INTO Booking_Status (statusName)
VALUES
('Confirmed'),
('Cancelled'),
('Completed');


-- Insert sample data into Restaurant_Table
INSERT INTO Restaurant_Table (restaurantID, areaID, tableNumber, capacity)
VALUES
(1, 1, 1, 2),
(1, 1, 2, 4),
(1, 2, 3, 4),
(1, 2, 4, 6),
(1, 3, 5, 8);


-- Insert sample data into Booking
INSERT INTO Booking
(customerID, tableID, statusID, bookingDate, bookingTime, numberOfGuests)
VALUES
(1, 2, 1, '2026-10-10', '18:00:00', 4),
(2, 5, 1, '2026-10-10', '19:30:00', 6),
(3, 1, 2, '2026-10-11', '17:00:00', 2),
(1, 3, 3, '2026-09-25', '20:00:00', 3);


-- Query 1: Get a list of all tables in the restaurant
SELECT
    rt.tableID,
    rt.tableNumber,
    rt.capacity,
    ta.areaName
FROM Restaurant_Table rt
JOIN Table_area ta ON rt.areaID = ta.areaID
ORDER BY rt.tableNumber;


-- Query 2: Get a list of all bookings for a given customer ordered by date
SELECT
    b.bookingID,
    c.firstName,
    c.lastName,
    rt.tableNumber,
    ta.areaName,
    b.bookingDate,
    b.bookingTime,
    b.numberOfGuests,
    bs.statusName
FROM Booking b
JOIN Customer c ON b.customerID = c.customerID
JOIN Restaurant_Table rt ON b.tableID = rt.tableID
JOIN Table_area ta ON rt.areaID = ta.areaID
JOIN Booking_Status bs ON b.statusID = bs.statusID
WHERE b.customerID = 1
ORDER BY b.bookingDate, b.bookingTime;;


-- Query 3: Get a list of all bookings for a given tableID,
-- including the customer, for a specific date
SELECT
    b.bookingID,
    c.firstName,
    c.lastName,
    rt.tableNumber,
    ta.areaName,
    b.bookingDate,
    b.bookingTime,
    b.numberOfGuests,
    bs.statusName
FROM Booking b
JOIN Customer c ON b.customerID = c.customerID
JOIN Restaurant_Table rt ON b.tableID = rt.tableID
JOIN Table_area ta ON rt.areaID = ta.areaID
JOIN Booking_Status bs ON b.statusID = bs.statusID
WHERE b.tableID = 2
AND b.bookingDate = '2026-10-10';