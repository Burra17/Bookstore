-- Använd databasen Bookstore
USE Bookstore;
GO

-- 1. Vy för bokdetaljer
-- Kombinerar bok, författare och genre så vi slipper joina varje gång.

-- Gör scriptet omkörningsbart
IF OBJECT_ID('View_BookDetails', 'V') IS NOT NULL DROP VIEW View_BookDetails;
GO

CREATE VIEW View_BookDetails AS
SELECT 
    B.BookID,
    B.Title,
    A.FirstName + ' ' + A.LastName AS AuthorName,
    G.GenreName,
    B.Price,
    B.StockQuantity
FROM Books B
JOIN Authors A ON B.AuthorID = A.AuthorID
JOIN Genres G ON B.GenreID = G.GenreID;
GO

-- 2. Vy för orderöversikt
-- Visar vem som köpt vad och totalsumman för varje order.

-- Gör scriptet omkörningsbart
IF OBJECT_ID('View_OrderSummary', 'V') IS NOT NULL DROP VIEW View_OrderSummary;
GO

CREATE VIEW View_OrderSummary AS
SELECT 
    O.OrderID,
    O.OrderDate,
    C.FirstName + ' ' + C.LastName AS CustomerName,
    SUM(OI.Quantity * OI.UnitPrice) AS TotalOrderValue,
    COUNT(OI.BookID) AS UniqueBooksOrdered
FROM Orders O
JOIN Customers C ON O.CustomerID = C.CustomerID
JOIN OrderItems OI ON O.OrderID = OI.OrderID
GROUP BY O.OrderID, O.OrderDate, C.FirstName, C.LastName;
GO

-- TESTA VYERNA:
SELECT * FROM View_BookDetails;
SELECT * FROM View_OrderSummary;