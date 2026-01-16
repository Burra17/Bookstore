-- Använd Bookstore databasen
USE Bookstore;
GO

-- 1. JOIN: Visa alla böcker med deras författare och genre
SELECT B.Title, A.FirstName, A.LastName, G.GenreName
FROM Books B
JOIN Authors A ON B.AuthorID = A.AuthorID
JOIN Genres G ON B.GenreID = G.GenreID;


-- 2. JOIN: Visa alla ordrar tillsammans med kundens namn
SELECT O.OrderID, O.OrderDate, C.FirstName, C.LastName
FROM Orders O
JOIN Customers C ON O.CustomerID = C.CustomerID;


-- 3. JOIN AV 3 TABELLER: Visa detaljerad orderhistorik
-- Kopplar: Customers -> Orders -> OrderItems -> Books
SELECT 
    C.FirstName + ' ' + C.LastName AS CustomerName,
    O.OrderID,
    B.Title,
    OI.Quantity,
    OI.UnitPrice
FROM Customers C
JOIN Orders O ON C.CustomerID = O.CustomerID
JOIN OrderItems OI ON O.OrderID = OI.OrderID
JOIN Books B ON OI.BookID = B.BookID;


-- 4. AGGREGATION: Beräkna totalt försäljningsvärde per kund
-- (Krav: GROUP BY)
SELECT 
    C.FirstName, 
    C.LastName, 
    SUM(OI.Quantity * OI.UnitPrice) AS TotalSpent
FROM Customers C
JOIN Orders O ON C.CustomerID = O.CustomerID
JOIN OrderItems OI ON O.OrderID = OI.OrderID
GROUP BY C.FirstName, C.LastName;


-- 5. AGGREGATION: Visa genrer som har mer än 2 böcker i lager
-- (Krav: HAVING)
SELECT G.GenreName, COUNT(B.BookID) AS BooksInGenre
FROM Genres G
JOIN Books B ON G.GenreID = B.GenreID
GROUP BY G.GenreName
HAVING COUNT(B.BookID) >= 2;


-- 6. SUBQUERY: Hitta böcker som är dyrare än genomsnittet i butiken
-- (Krav: Query med subquery eller CTE)
SELECT Title, Price
FROM Books
WHERE Price > (SELECT AVG(Price) FROM Books);


-- 7. AFFÄRSFRÅGA: "Vilka är våra Topp 3 mest säljande böcker?"
-- (Krav: Query som svarar på en affärsfråga)
SELECT TOP 3 
    B.Title, 
    SUM(OI.Quantity) AS TotalSold
FROM Books B
JOIN OrderItems OI ON B.BookID = OI.BookID
GROUP BY B.Title
ORDER BY TotalSold DESC;

GO