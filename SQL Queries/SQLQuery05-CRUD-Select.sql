-- Använd Bookstore databasen
USE Bookstore;
GO

-- 1. Enkel SELECT (Hämta alla böcker)
-- Visar alla kolumner och rader i tabellen Books.
SELECT * FROM Books;


-- 2. Filtrerad SELECT (Hämta en specifik kund via e-post)
-- Krav: Filtrerad select på huvudtabell.
SELECT FirstName, LastName, Email 
FROM Customers 
WHERE Email = 'erik@example.com';


-- 3. Filtrerad SELECT med villkor (Böcker som kostar mer än 150 kr)
-- Vi sorterar även resultatet så den dyraste boken kommer först.
SELECT Title, Price, StockQuantity 
FROM Books 
WHERE Price > 150 
ORDER BY Price DESC;


-- 4. SELECT på kopplingstabell (Visa rader i en specifik order)
-- Vi vill se vilka böcker som ingår i OrderID 1.
SELECT OrderID, BookID, Quantity, UnitPrice 
FROM OrderItems 
WHERE OrderID = 1;


-- 5. Sökning med LIKE (Hitta alla böcker som har "Harry Potter" i titeln)
-- % tecknet fungerar som en joker.
SELECT Title, ISBN 
FROM Books 
WHERE Title LIKE 'Harry Potter%';

GO