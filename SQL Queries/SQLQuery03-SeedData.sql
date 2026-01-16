-- Använd Bookstore databasen
USE Bookstore;
GO

-- 1. Lägg till Författare
INSERT INTO Authors (FirstName, LastName, BirthYear) VALUES 
('Astrid', 'Lindgren', 1907),
('Fredrik', 'Backman', 1981),
('J.K.', 'Rowling', 1965),
('Stephen', 'King', 1947),
('Karin', 'Smirnoff', 1964);

-- 2. Lägg till Genrer
INSERT INTO Genres (GenreName) VALUES 
('Barnlitteratur'),
('Skönlitteratur'),
('Fantasy'),
('Skräck'),
('Kriminalroman');

-- 3. Lägg till Kunder
INSERT INTO Customers (FirstName, LastName, Email) VALUES 
('Erik', 'Eriksson', 'erik@example.com'),
('Anna', 'Svensson', 'anna@example.com'),
('Karl', 'Karlsson', 'karl@example.com'),
('Maria', 'Lundin', 'maria@example.com'),
('Sven', 'Nilsson', 'sven@example.com');

-- 4. Lägg till Böcker (Kopplade till Authors och Genres)
-- Vi antar att IDs börjar på 1 pga IDENTITY
INSERT INTO Books (Title, ISBN, Price, StockQuantity, AuthorID, GenreID) VALUES 
('Pippi Långstrump', '9789129672343', 149.00, 50, 1, 1),
('Bröderna Lejonhjärta', '9789129688313', 179.00, 30, 1, 1),
('En man som heter Ove', '9789175031743', 129.00, 100, 2, 2),
('Folk med ångest', '9789178870110', 135.00, 40, 2, 2),
('Harry Potter och de vises sten', '9789172218154', 199.00, 80, 3, 3),
('Harry Potter och hemligheternas kammare', '9789172218161', 199.00, 60, 3, 3),
('The Shining', '9780307743657', 159.00, 25, 4, 4),
('It', '9781501142970', 189.00, 15, 4, 4),
('Jag for ner till bror', '9789177951384', 145.00, 20, 5, 2),
('Vi for upp med mor', '9789177952046', 145.00, 22, 5, 2);

-- 5. Lägg till Ordrar (Kopplade till Customers)
INSERT INTO Orders (OrderDate, CustomerID) VALUES 
(GETDATE(), 1),
(GETDATE(), 2),
(GETDATE(), 3),
(GETDATE(), 4),
(GETDATE(), 5);

-- 6. Lägg till Orderrader (Kopplar ihop Ordrar med Böcker)
-- Här ser vi till att priset sparas i UnitPrice för historik
INSERT INTO OrderItems (OrderID, BookID, Quantity, UnitPrice) VALUES 
(1, 1, 2, 149.00), -- Erik köper 2 Pippi
(1, 5, 1, 199.00), -- Erik köper 1 Harry Potter
(2, 3, 1, 129.00), -- Anna köper Ove
(3, 7, 1, 159.00), -- Karl köper The Shining
(4, 9, 3, 145.00), -- Maria köper 3 st av Smirnoff
(5, 2, 1, 179.00), -- Sven köper Lejonhjärta
(5, 6, 1, 199.00), -- Sven köper Harry Potter 2
(1, 10, 1, 145.00), -- Erik köper en till bok
(2, 4, 1, 135.00), -- Anna köper en till
(3, 8, 2, 189.00); -- Karl köper 2 st IT
GO