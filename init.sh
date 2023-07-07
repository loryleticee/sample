#! /bin/bash

/opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P YourStrong_Passw0rd << EOF
CREATE DATABASE TestDB;
GO
SELECT Name from sys.databases;
GO
USE TestDB;
GO
CREATE TABLE Inventory (id INT, name NVARCHAR(50), quantity INT);
GO
INSERT INTO Inventory VALUES (1, 'banana', 150); INSERT INTO Inventory VALUES (2, 'orange', 154);
GO
EOF
