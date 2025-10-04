Database design and implementation project for SQLI12025.
Databases Project: E-commerce Database System
Module: Advanced Databases (SQLI12025)

Consultant: Agbaakin Oluwatosin

Date: October 4, 2025

1. Project Overview
This project contains the complete submission for the "Database Design & SQL for Data Analysis" assessment. The objective was to act as a database consultant for a large online retailer and develop a new, robust relational database system from the ground up that meets a detailed set of functional requirements.

The solution encompasses the entire database development lifecycle:

Analysis: Interpreting the client brief to gather functional requirements.

Design: Architecting a logical database schema, normalized to the Third Normal Form (3NF).

Implementation: Writing a comprehensive T-SQL script to create the database, tables, relationships, and all associated objects.

Programming: Developing advanced database objects, including Views, Stored Procedures, User-Defined Functions, and Triggers to encapsulate all required business logic.

Security & Strategy: Defining a role-based security model and providing strategic advice on data integrity, concurrency, and backup/recovery strategies.

2. Repository Contents
This repository contains the three required deliverables for the project:

Agbaakin_Oluwatosin.pdf: The formal project report. This document provides a detailed explanation of the database design, the normalization process, justifications for all technical decisions, and includes the final code and result screenshots for every required task.

Agbaakin_Oluwatosin.sql: The clean, complete T-SQL script for database creation. This single file contains all the "original code" needed to build the database schema, populate it with sample data, and create all advanced objects.

Agbaakin_Oluwatosin.bak: A full backup of the final, populated database. This file can be used to restore the database to a working state instantly on an instance of Microsoft SQL Server.

3. How to Recreate the Database
Method A: Restore from Backup (Recommended)
Open SQL Server Management Studio (SSMS).

Right-click on the Databases folder and select Restore Database....

Select Device, click the ... button, Add the Agbaakin_Oluwatosin.bak file, and click OK.

Click OK to begin the restore process.

Method B: Execute the T-SQL Script
Open SQL Server Management Studio (SSMS) and connect to your database engine.

Go to File > Open > File... and open the Agbaakin_Oluwatosin.sql script.

Click the ! Execute button on the toolbar to run the script.

4. Development Process
The final T-SQL script provided in this repository is the result of an iterative development process. Initial versions of the script were tested, revealing minor execution errors related to command batching and object dependencies. These issues were systematically diagnosed and resolved. The final script has been thoroughly vetted and is guaranteed to execute successfully from start to finish, performing a clean installation of the database and all its objects
