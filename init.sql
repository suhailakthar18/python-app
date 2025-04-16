CREATE DATABASE IF NOT EXISTS railway_system;

USE railway_system;

-- Create users table with case-sensitive username
CREATE TABLE IF NOT EXISTS users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(100) NOT NULL UNIQUE COLLATE utf8_bin,  -- Case-sensitive collation
  password VARCHAR(255) NOT NULL
);

-- Create bookings table
CREATE TABLE IF NOT EXISTS bookings (
  id INT AUTO_INCREMENT PRIMARY KEY,
  train_no VARCHAR(20),
  departure_time TIME,
  source VARCHAR(100),
  destination VARCHAR(100),
  username VARCHAR(100)
);

