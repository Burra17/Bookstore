📚 Inlämning: SQL Bookstore Project
Detta projekt omfattar design och implementation av en relationsdatabas för en bokhandel, komplett med SQL-skript för struktur och data, samt en integrerad .NET 8 Console Application för administration.

🖼️ ER-Diagram
Projektets databasmodellering finns dokumenterad i mappen /ERDiagram/:

Bild: ER-Diagram-Bookstore.png

Källfil: Bookstore ER-Diagram.drawio (kan öppnas i draw.io för redigering)

🛠️ Installation & Setup
1. SQL Server
Kör skripten i mappen /SQL Queries/ i numerisk ordning för att sätta upp databasen korrekt:

01_CreateDatabase.sql

02_CreateTables.sql (Innehåller PK, FK och Constraints)

03_SeedData.sql (Initial data för testning)

04-07 (CRUD-operationer)

08_Joins.sql (Avancerade frågor för analys)

09_Views.sql (Implementerade vyer för förenklad datahämtning)

10_StoredProcedures.sql (Affärslogik och transaktioner)

2. Console Application (.NET 8)
Applikationen använder Entity Framework Core för att kommunicera med databasen.

Viktigt: Innan du kör appen, se till att Server-namnet i appsettings.json matchar din lokala SQL-instans.

Notis: Om programmet kastar en FileNotFoundException, kontrollera att appsettings.json har inställningen "Copy to Output Directory: Copy if newer" i Visual Studio.

🧠 Reflektion & VG-Funktionalitet
Databasdesign & Normalisering
Struktur: Databasen är modellerad enligt 3NF (Tredje normalformen) för att minimera redundans.

Integritet: Genom att separera Authors och Genres från Books säkerställs dataintegritet.

Foreign Keys: Används konsekvent för att förhindra "föräldralösa" rader, vilket demonstrerades vid radering av kunder med aktiva ordrar.

Avancerad SQL (VG-krav)
Vyer (Views): Jag har implementerat View_BookDetails för att dölja komplexa JOINS och förenkla rapportering.

Stored Procedures & Transaktioner: Proceduren sp_ProcessCustomerOrder hanterar orderläggning, prishämtning och lageruppdatering i en samlad transaktion. Detta garanterar att lagersaldot aldrig minskar om inte ordern faktiskt skapas (Atomicity).

Console App Integration
Applikationen visar ett fullständigt flöde:

Hämtning (Read): Visar böcker med tillhörande författare via Eager Loading (.Include).

Skapande (Create): Möjlighet att lägga till nya böcker direkt i databasen via EF Core.

Affärslogik: Anropar den lagrade proceduren för att genomföra köp, vilket visar en hybridlösning mellan C#-logik och SQL-prestanda.

💡 Framtida Förbättringar & Skalbarhet
I efterhand ser jag flera områden där systemet kan skalas upp för en produktionsmiljö:

Användarkonton och Password Hashing:

Säker lagring: Lägga till kolumner för PasswordHash och Salt. Lösenord ska aldrig lagras i klartext.

Logik i C#: Använda ett bibliotek som BCrypt.Net i Console-appen för att hasha lösenordet innan det skickas till databasen.

SQL-integration: Skapa en lagrad procedur som validerar inloggningsuppgifter genom att jämföra hashvärden.

Triggers för automatisk loggning (Audit Logs):

En trigger som automatiskt skapar en rad i en AuditLog-tabell varje gång priset på en bok ändras för att ge administratören en historik över prisförändringar.

Differentierade vyer (Admin vs. Customer):

CustomerView: Visar endast böcker som finns i lager (StockQuantity > 0).

AdminView: Innehåller även inköpspriser och leverantörsinformation som slutkunden inte ska se.

Hantering av transaktionsfel (Exception Handling):

Även om jag implementerat TRY-CATCH i mina lagrade procedurer, skulle C#-applikationen kunna förbättras genom att mer specifikt skilja på anslutningsfel (servern är nere) och logikfel (t.ex. brott mot en UNIQUE-constraint).