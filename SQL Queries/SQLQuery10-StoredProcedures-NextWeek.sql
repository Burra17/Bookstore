-- Använd Bookstore databasen
USE Bookstore;
GO

-- PLANERING FÖR NÄSTA VECKA:
-- Jag planerar att skapa följande procedurer för att automatisera flöden:

/*
    1. sp_AddNewOrder:
       En procedur som tar in CustomerID och en lista på böcker, 
       skapar en ny rad i Orders och därefter lägger till rader i OrderItems. 
       Denna ska även kunna hantera transaktioner (Rollback) om något går fel.
*/

/*
    2. sp_UpdateStockAfterSale:
       En procedur som automatiskt minskar StockQuantity i tabellen Books 
       när en ny försäljning genomförs.
*/

/*
    3. Password Hashing & Security:
       Jag planerar även att titta på hur man hanterar användarsäkerhet 
       och lagring av lösenord på ett säkert sätt i databasen.
*/

PRINT 'Planering för Stored Procedures är dokumenterad.';
GO