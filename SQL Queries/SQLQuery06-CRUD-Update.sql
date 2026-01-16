-- Använd Bookstore databasen
USE Bookstore;
GO

-- 1. Uppdatera priset på en bok (Huvudtabell 1)
-- Realistiskt scenario: En bok går på rea eller får ett nytt pris.
UPDATE Books
SET Price = 129.00
WHERE Title = 'Pippi Långstrump';


-- 2. Uppdatera lagerstatus (Huvudtabell 1)
-- Realistiskt scenario: Vi har fått in en ny leverans av en bok.
UPDATE Books
SET StockQuantity = StockQuantity + 20
WHERE ISBN = '9789172218154'; -- Harry Potter och de vises sten


-- 3. Ändra en kunds e-postadress (Huvudtabell 2)
-- Realistiskt scenario: Kunden har bytt mailadress.
UPDATE Customers
SET Email = 'maria.lundin.new@example.com'
WHERE CustomerID = 4;


-- 4. Uppdatera antal i en order (Kopplingstabell)
-- Realistiskt scenario: Kunden ringer och vill ändra antal av en bok i sin beställning
-- innan den har skickats. Vi ändrar Quantity för en specifik bok i en specifik order.
UPDATE OrderItems
SET Quantity = 5
WHERE OrderID = 1 AND BookID = 1;

GO