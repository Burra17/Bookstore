-- Vi växlar till systemdatabasen 'master' för att säkerställa att vi 
-- inte försöker skapa databasen inifrån en databas som ska raderas eller ändras.
USE master;
GO

-- Kontrollera om databasen 'Bookstore' redan finns i systemet.
-- Detta förhindrar felmeddelanden om skriptet körs mer än en gång.
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'Bookstore')
BEGIN
    -- Om den inte finns, skapa databasen.
    CREATE DATABASE Bookstore;
    PRINT 'Databasen Bookstore har skapats framgångsrikt.';
END
ELSE
BEGIN
    -- Om den redan finns, informera användaren.
    PRINT 'Databasen Bookstore finns redan.';
END
GO