-- Använda Bookstore databas
USE Bookstore;
GO

-- 1. Lägg till en ny kund (Huvudtabell 1)
INSERT INTO Customers (FirstName, LastName, Email)
VALUES ('Niklas', 'Zennström', 'niklas@skype.com');


-- 2. Lägg till en ny bok (Huvudtabell 2)
-- Vi använder ett AuthorID och GenreID som vi vet existerar (från SeedData)
INSERT INTO Books (Title, ISBN, Price, StockQuantity, AuthorID, GenreID)
VALUES ('Tjuven', '9789170017421', 189.00, 15, 5, 2);


-- 3. Skapa en ny order och lägg till rader (Kopplingstabell)
-- Steg A: Skapa själva ordern för kunden vi nyss skapade (Niklas har förmodligen ID 6)
INSERT INTO Orders (CustomerID, OrderDate)
VALUES (6, GETDATE());

-- Steg B: Lägg till en bok i den nya ordern (Kopplingstabellen OrderItems)
-- Vi antar att den nya ordern fick ID 6
INSERT INTO OrderItems (OrderID, BookID, Quantity, UnitPrice)
VALUES (6, 1, 1, 149.00); 

GO