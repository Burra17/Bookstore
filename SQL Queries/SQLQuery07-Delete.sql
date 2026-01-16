-- Använd Bookstore databasen
USE Bookstore;
GO

-- 1. Enkel Delete (Inga beroenden)
-- Vi tar bort en kund som vi nyss skapade men som inte hunnit lägga någon order än.
-- Detta fungerar direkt eftersom ingen annan tabell refererar till detta CustomerID.
DELETE FROM Customers
WHERE Email = 'andre@gmail.com';


-- 2. Hantera Delete med beroenden (Delete-ordning)
-- Scenario: Vi ska ta bort en hel order (OrderID 1).
-- Vi kan inte bara ta bort ordern, för då blir raderna i OrderItems "föräldralösa".
-- Vi måste radera i rätt ordning:

-- Steg A: Ta först bort alla rader i kopplingstabellen som hör till ordern.
DELETE FROM OrderItems
WHERE OrderID = 1;

-- Steg B: Nu kan vi ta bort själva ordern.
DELETE FROM Orders
WHERE OrderID = 1;


-- 3. Förhindra Delete (Dokumentation av FK-skydd)
/*
    FÖRSÖK TILL RADERING:
    DELETE FROM Authors WHERE AuthorID = 1;

    RESULTAT: 
    Detta kommer att misslyckas och ge ett "Foreign Key Constraint Error" 
    eftersom Astrid Lindgren (ID 1) har böcker kopplade till sig i tabellen 'Books'.
    
    Hantering: 
    I en riktig produkt raderar man sällan master-data. Istället för att radera 
    författaren kan man t.ex. ha en kolumn 'IsActive' som sätts till false.
*/

-- 4. Ta bort en specifik bok från en order (Kopplingstabell)
-- Detta är en vanlig CRUD-operation i en varukorg.
DELETE FROM OrderItems
WHERE OrderID = 3 AND BookID = 8;

GO