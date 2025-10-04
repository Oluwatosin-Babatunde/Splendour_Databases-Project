/*****************************************************************************************************************
    Databases Project 1 Submission
    Consultant: Agbaakin Oluwatosin
    Date: October 4, 2025
*****************************************************************************************************************/

--================================================================================
-- PART 1: ENVIRONMENT SETUP AND DATABASE CREATION
--================================================================================
USE master;
GO

IF DB_ID('EcommerceDB') IS NOT NULL
BEGIN
    ALTER DATABASE EcommerceDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE EcommerceDB;
    PRINT 'Previous instance of EcommerceDB found and dropped for a clean installation.';
END
GO

CREATE DATABASE EcommerceDB;
GO

USE EcommerceDB;
GO

PRINT 'Database EcommerceDB created successfully and is now the active context.';
GO

--================================================================================
-- PART 2: SCHEMA DEFINITION AND TABLE CREATION
--================================================================================
CREATE TABLE dbo.Categories (
    CategoryID INT IDENTITY(1,1) PRIMARY KEY,
    CategoryName NVARCHAR(50) NOT NULL UNIQUE,
    Description NVARCHAR(255)
);
PRINT 'Table dbo.Categories created.';

CREATE TABLE dbo.Suppliers (
    SupplierID INT IDENTITY(1,1) PRIMARY KEY,
    SupplierName NVARCHAR(100) NOT NULL,
    ContactName NVARCHAR(100),
    Country NVARCHAR(50) NOT NULL
);
PRINT 'Table dbo.Suppliers created.';

CREATE TABLE dbo.Customers (
    CustomerID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Email NVARCHAR(100) NOT NULL UNIQUE,
    BirthDate DATE NOT NULL
);
PRINT 'Table dbo.Customers created.';

CREATE TABLE dbo.Products (
    ProductID INT IDENTITY(1,1) PRIMARY KEY,
    ProductName NVARCHAR(100) NOT NULL,
    SupplierID INT,
    CategoryID INT,
    UnitPrice DECIMAL(10, 2) NOT NULL,
    UnitsInStock INT NOT NULL DEFAULT 0,
    CONSTRAINT FK_Products_Suppliers FOREIGN KEY (SupplierID) REFERENCES dbo.Suppliers(SupplierID),
    CONSTRAINT FK_Products_Categories FOREIGN KEY (CategoryID) REFERENCES dbo.Categories(CategoryID),
    CONSTRAINT CK_Products_UnitPrice CHECK (UnitPrice > 0) -- Fulfills Task 2 requirement
);
PRINT 'Table dbo.Products created.';

CREATE TABLE dbo.Orders (
    OrderID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT,
    OrderDate DATETIME NOT NULL DEFAULT GETDATE(),
    OrderStatus NVARCHAR(20) NOT NULL DEFAULT 'Pending',
    CONSTRAINT FK_Orders_Customers FOREIGN KEY (CustomerID) REFERENCES dbo.Customers(CustomerID),
    CONSTRAINT CK_OrderStatus CHECK (OrderStatus IN ('Pending', 'Processing', 'Shipped', 'Delivered', 'Cancelled'))
);
PRINT 'Table dbo.Orders created.';

CREATE TABLE dbo.OrderDetails (
    OrderDetailID INT IDENTITY(1,1) PRIMARY KEY,
    OrderID INT NOT NULL,
    ProductID INT NOT NULL,
    UnitPrice DECIMAL(10, 2) NOT NULL,
    Quantity INT NOT NULL,
    CONSTRAINT FK_OrderDetails_Orders FOREIGN KEY (OrderID) REFERENCES dbo.Orders(OrderID),
    CONSTRAINT FK_OrderDetails_Products FOREIGN KEY (ProductID) REFERENCES dbo.Products(ProductID)
);
PRINT 'Table dbo.OrderDetails created.';

CREATE TABLE dbo.Reviews (
    ReviewID INT IDENTITY(1,1) PRIMARY KEY,
    ProductID INT NOT NULL,
    CustomerID INT NOT NULL,
    Rating INT NOT NULL,
    ReviewText NVARCHAR(1000),
    ReviewDate DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_Reviews_Products FOREIGN KEY (ProductID) REFERENCES dbo.Products(ProductID),
    CONSTRAINT FK_Reviews_Customers FOREIGN KEY (CustomerID) REFERENCES dbo.Customers(CustomerID),
    CONSTRAINT CK_Rating CHECK (Rating BETWEEN 1 AND 5)
);
PRINT 'Table dbo.Reviews created.';
GO

--================================================================================
-- PART 3: DATA POPULATION
--================================================================================
INSERT INTO dbo.Categories (CategoryName, Description) VALUES
('Electronics', 'Devices, gadgets, and accessories'),
('Books', 'Classic literature and non-fiction'),
('Apparel', 'Clothing and fashion accessories'),
('Premium', 'High-end luxury items');

INSERT INTO dbo.Suppliers (SupplierName, ContactName, Country) VALUES
('Techtronics Inc.', 'Alex Ray', 'USA'),
('Page Turners Ltd.', 'Ben Carter', 'UK'),
('Vogue Fabrics', 'Chloe Dubois', 'France'),
('Luxury Goods Co.', 'Isabella Rossi', 'Italy');

INSERT INTO dbo.Customers (FirstName, LastName, Email, BirthDate) VALUES
('John', 'Smith', 'john.smith@example.com', '1975-05-20'), -- Older than 40
('Jane', 'Doe', 'jane.doe@example.com', '1990-08-15'),
('Peter', 'Jones', 'peter.jones@example.com', '1968-01-30'), -- Older than 40
('Mary', 'Williams', 'mary.w@example.com', '2001-11-10');

INSERT INTO dbo.Products (ProductName, SupplierID, CategoryID, UnitPrice, UnitsInStock) VALUES
('4K Ultra HD Monitor', 1, 1, 799.99, 50),
('Pride and Prejudice', 2, 2, 12.50, 200),
('Leather Jacket', 3, 3, 250.00, 75),
('Luxury Watch', 4, 4, 2500.00, 10), -- Premium category
('Wireless Mouse', 1, 1, 49.99, 150);

-- Order 1 (Delivered Electronics)
INSERT INTO dbo.Orders (CustomerID, OrderDate, OrderStatus) VALUES (1, '2025-09-01', 'Delivered');
DECLARE @OrderID1 INT = SCOPE_IDENTITY();
INSERT INTO dbo.OrderDetails(OrderID, ProductID, UnitPrice, Quantity) VALUES (@OrderID1, 1, 799.99, 1);
INSERT INTO dbo.Reviews (ProductID, CustomerID, Rating, ReviewText) VALUES (1, 1, 5, 'Excellent monitor!');

-- Order 2 (Delivered Premium for customer older than 40)
INSERT INTO dbo.Orders (CustomerID, OrderDate, OrderStatus) VALUES (3, '2025-09-05', 'Delivered');
DECLARE @OrderID2 INT = SCOPE_IDENTITY();
INSERT INTO dbo.OrderDetails(OrderID, ProductID, UnitPrice, Quantity) VALUES (@OrderID2, 4, 2500.00, 1);
INSERT INTO dbo.Reviews (ProductID, CustomerID, Rating, ReviewText) VALUES (4, 3, 5, 'Stunning timepiece.');

-- Order 3 (Cancelled Order to test trigger)
INSERT INTO dbo.Orders (CustomerID, OrderDate, OrderStatus) VALUES (2, '2025-09-10', 'Processing');
DECLARE @OrderID3 INT = SCOPE_IDENTITY();
INSERT INTO dbo.OrderDetails(OrderID, ProductID, UnitPrice, Quantity) VALUES (@OrderID3, 5, 49.99, 2);
UPDATE dbo.Products SET UnitsInStock = UnitsInStock - 2 WHERE ProductID = 5; -- Manually reduce stock for trigger test

-- Order 4 (For today's date)
INSERT INTO dbo.Orders (CustomerID, OrderDate, OrderStatus) VALUES (1, GETDATE(), 'Processing');
DECLARE @OrderID4 INT = SCOPE_IDENTITY();
INSERT INTO dbo.OrderDetails(OrderID, ProductID, UnitPrice, Quantity) VALUES (@OrderID4, 2, 12.50, 1);

PRINT 'Sample data populated.';
GO

--================================================================================
-- PART 4: T-SQL OBJECT DEVELOPMENT
--================================================================================

-- TRIGGER FOR TASK 6
CREATE TRIGGER trg_RestockOnCancel ON dbo.Orders AFTER UPDATE AS
BEGIN
    SET NOCOUNT ON;
    IF UPDATE(OrderStatus)
    BEGIN
        DECLARE @OrderID INT, @OldStatus NVARCHAR(20), @NewStatus NVARCHAR(20);
        SELECT @OrderID = i.OrderID, @NewStatus = i.OrderStatus, @OldStatus = d.OrderStatus
        FROM inserted i JOIN deleted d ON i.OrderID = d.OrderID;
        IF @NewStatus = 'Cancelled' AND @OldStatus <> 'Cancelled'
        BEGIN
            UPDATE p SET p.UnitsInStock = p.UnitsInStock + od.Quantity
            FROM dbo.Products p JOIN dbo.OrderDetails od ON p.ProductID = od.ProductID
            WHERE od.OrderID = @OrderID;
            PRINT 'Trigger Fired: Stock levels updated for cancelled OrderID: ' + CAST(@OrderID AS VARCHAR);
        END
    END
END;
GO
PRINT 'Trigger trg_RestockOnCancel created.';
GO

-- STORED PROCEDURES/FUNCTIONS FOR TASK 4
CREATE PROCEDURE sp_SearchProductsByName @SearchString NVARCHAR(100) AS
BEGIN
    SET NOCOUNT ON;
    SELECT p.ProductName, p.UnitPrice, o.OrderDate
    FROM dbo.Products p JOIN dbo.OrderDetails od ON p.ProductID = od.ProductID
    JOIN dbo.Orders o ON od.OrderID = o.OrderID
    WHERE p.ProductName LIKE '%' + @SearchString + '%'
    ORDER BY o.OrderDate DESC;
END;
GO
PRINT 'Stored Procedure sp_SearchProductsByName created.';
GO

CREATE FUNCTION fn_GetProductsForCustomerToday (@CustomerID INT) RETURNS TABLE AS RETURN
(
    SELECT p.ProductName, s.SupplierName
    FROM dbo.Orders o JOIN dbo.OrderDetails od ON o.OrderID = od.OrderID
    JOIN dbo.Products p ON od.ProductID = p.ProductID
    JOIN dbo.Suppliers s ON p.SupplierID = s.SupplierID
    WHERE o.CustomerID = @CustomerID AND CONVERT(DATE, o.OrderDate) = CONVERT(DATE, GETDATE())
);
GO
PRINT 'Function fn_GetProductsForCustomerToday created.';
GO

CREATE PROCEDURE sp_UpdateSupplier @SupplierID INT, @NewContactName NVARCHAR(100), @NewCountry NVARCHAR(50) AS
BEGIN
    SET NOCOUNT ON;
    UPDATE dbo.Suppliers SET ContactName = @NewContactName, Country = @NewCountry
    WHERE SupplierID = @SupplierID;
    PRINT 'Procedure Executed: Supplier details updated for SupplierID: ' + CAST(@SupplierID AS VARCHAR);
END;
GO
PRINT 'Stored Procedure sp_UpdateSupplier created.';
GO

CREATE PROCEDURE sp_DeleteDeliveredOrder @OrderID INT AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (SELECT 1 FROM dbo.Orders WHERE OrderID = @OrderID AND OrderStatus = 'Delivered')
    BEGIN
        DELETE FROM dbo.OrderDetails WHERE OrderID = @OrderID;
        DELETE FROM dbo.Orders WHERE OrderID = @OrderID;
        PRINT 'Procedure Executed: Successfully deleted delivered OrderID: ' + CAST(@OrderID AS VARCHAR);
    END
    ELSE
    BEGIN
        PRINT 'Error: Order does not exist or status is not ''Delivered''.';
    END
END;
GO
PRINT 'Stored Procedure sp_DeleteDeliveredOrder created.';
GO


-- VIEW FOR TASK 5
CREATE VIEW vw_CustomerOrderHistory AS
SELECT o.OrderDate, (od.UnitPrice * od.Quantity) AS TotalCost, cat.CategoryName, s.SupplierName,
       r.Rating AS ProductRating, r.ReviewText
FROM dbo.Orders o JOIN dbo.OrderDetails od ON o.OrderID = od.OrderID
JOIN dbo.Products p ON od.ProductID = p.ProductID
JOIN dbo.Categories cat ON p.CategoryID = cat.CategoryID
JOIN dbo.Suppliers s ON p.SupplierID = s.SupplierID
LEFT JOIN dbo.Reviews r ON p.ProductID = r.ProductID AND o.CustomerID = r.CustomerID;
GO
PRINT 'View vw_CustomerOrderHistory created.';
GO

PRINT 'All database objects created successfully.';
GO