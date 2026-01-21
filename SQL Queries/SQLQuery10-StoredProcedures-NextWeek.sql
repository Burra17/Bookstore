-- Använd databasen Bookstore
USE Bookstore;
GO

-- 1. Procedur för att lägga till en order och uppdatera lager
-- Denna procedur uppfyller kraven på transaktionshantering (Rollback)
CREATE OR ALTER PROCEDURE sp_ProcessCustomerOrder
    @CustomerID INT,
    @BookID INT,
    @Quantity INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Variabler för att hålla temporär data
    DECLARE @CurrentPrice DECIMAL(10, 2);
    DECLARE @CurrentStock INT;
    DECLARE @NewOrderID INT;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Steg A: Kontrollera lagerstatus och hämta pris
        SELECT @CurrentStock = StockQuantity, @CurrentPrice = Price 
        FROM Books WHERE BookID = @BookID;

        IF @CurrentStock < @Quantity
        BEGIN
            RAISERROR('Otillräckligt lager för att genomföra köpet.', 16, 1);
        END

        -- Steg B: Skapa ordern
        INSERT INTO Orders (CustomerID, OrderDate)
        VALUES (@CustomerID, GETDATE());
        
        SET @NewOrderID = SCOPE_IDENTITY(); -- Hämtar ID på den nyskapade ordern

        -- Steg C: Lägg till i kopplingstabellen OrderItems (Kopplar ihop Order och Bok)
        INSERT INTO OrderItems (OrderID, BookID, Quantity, UnitPrice)
        VALUES (@NewOrderID, @BookID, @Quantity, @CurrentPrice);

        -- Steg D: Automatisera lageruppdatering (sp_UpdateStockAfterSale logik)
        UPDATE Books
        SET StockQuantity = StockQuantity - @Quantity
        WHERE BookID = @BookID;

        -- Om allt gick bra, bekräfta ändringarna permanent
        COMMIT TRANSACTION;
        PRINT 'Order genomförd framgångsrikt och lager har uppdaterats.';
    END TRY
    BEGIN CATCH
        -- Om något gick fel (t.ex. slut på lager eller databasfel), återställ allt
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        PRINT 'TRANSAKTION AVBRUTEN: ' + @ErrorMessage;
    END CATCH
END;
GO

-- TESTA PROCEDUREN (Exempel: Kund 2 köper 1 Pippi Långstrump):
EXEC sp_ProcessCustomerOrder @CustomerID = 2, @BookID = 1, @Quantity = 1;