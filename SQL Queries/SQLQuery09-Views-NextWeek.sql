-- Använd Bookstore databasen
USE Bookstore;
GO

-- PLANERING FÖR NÄSTA VECKA:
-- Jag planerar att skapa följande vyer för att förenkla datahämtning:

/*
    1. View_BookDetails:
       En vy som kombinerar tabellerna Books, Authors och Genres. 
       Syftet är att kunna se bokens titel, författarens fullständiga namn 
       och genren utan att behöva skriva komplexa JOIN-frågor varje gång.
*/

/*
    2. View_SalesSummary:
       En vy som visar en sammanställning av försäljningen. 
       Den ska visa OrderID, kundens namn och det totala beloppet för ordern.
*/

PRINT 'Planering för Views är dokumenterad.';
GO