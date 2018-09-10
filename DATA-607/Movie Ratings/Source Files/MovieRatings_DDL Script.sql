## Create Database/Schema 
CREATE DATABASE IF NOT EXISTS movieratings; 

Use movieratings;

## Create Movies Dimension Table
CREATE TABLE IF NOT EXISTS movieratings.Movies (
Movie_ID INT NOT NULL,
Movie_Title VARCHAR(500) NOT NULL,
Movie_Genre VARCHAR(100) NOT NULL,
Movie_Year INT NOT NULL,
Director_Name VARCHAR(500) NOT NULL,
PRIMARY KEY (Movie_ID)
);

## Create Users Dimension Table
CREATE TABLE IF NOT EXISTS movieratings.Users (
User_ID INT NOT NULL,
First_Name VARCHAR(500) NOT NULL,
Last_Name VARCHAR(500) NOT NULL,
Gender VARCHAR(1) NOT NULL,
Age INT NOT NULL,
PRIMARY KEY(User_ID)
);

## Create Movie Ratings Table
CREATE TABLE IF NOT EXISTS movieratings.Ratings (
User_ID INT NOT NULL,
Movie_ID INT  NOT NULL,
Rating DECIMAL(9,2) NOT NULL,
 
PRIMARY KEY(User_ID,Movie_ID),
FOREIGN KEY (Movie_ID) REFERENCES Movies(Movie_ID),
FOREIGN KEY (User_ID) REFERENCES Users(User_ID)
);

