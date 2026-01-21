using Microsoft.Extensions.Configuration;
using Microsoft.EntityFrameworkCore;
using Bookstore.Models;

namespace BookstoreApp;

class Program
{
    static void Main(string[] args)
    {
        // Vi använder en try-catch för att fånga upp eventuella startfel, 
        // t.ex. om konfigurationsfilen saknas eller servern är nere.
        try
        {
            // 1. KONFIGURATION: Ställer in så att appen kan läsa appsettings.json.
            // .SetBasePath anger var filen ligger (i programmets körningsmapp).
            var builder = new ConfigurationBuilder()
                .SetBasePath(Directory.GetCurrentDirectory())
                .AddJsonFile("appsettings.json", optional: false, reloadOnChange: true);

            IConfiguration configuration = builder.Build();

            // Hämtar anslutningssträngen som vi definierat i appsettings.json.
            string connectionString = configuration.GetConnectionString("DefaultConnection")
                ?? throw new InvalidOperationException("Anslutningssträngen hittades inte i appsettings.json.");

            // 2. SETUP: Konfigurerar vår DbContext att använda SQL Server med rätt sträng.
            var optionsBuilder = new DbContextOptionsBuilder<BookstoreContext>();
            optionsBuilder.UseSqlServer(connectionString);

            // 3. START: Skapar en instans av vår context och startar menyn.
            // 'using' ser till att anslutningen stängs ordentligt när programmet avslutas.
            using var context = new BookstoreContext(optionsBuilder.Options);
            RunMenu(context);
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Ett kritiskt fel uppstod vid start: {ex.Message}");
        }
    }


    // Huvudmeny för applikationen. Hanterar användarens val.
    static void RunMenu(BookstoreContext context)
    {
        bool isRunning = true;
        while (isRunning)
        {
            Console.Clear();
            Console.WriteLine("========================================");
            Console.WriteLine("       THE MINIMALIST BOOKSTORE        ");
            Console.WriteLine("========================================");
            Console.WriteLine("1. Lista alla böcker (JOINS)");
            Console.WriteLine("2. Visa alla kunder (SELECT)");
            Console.WriteLine("3. Lägg till en ny bok (INSERT)");
            Console.WriteLine("4. Genomför ett köp (STORED PROCEDURE)");
            Console.WriteLine("5. Avsluta");
            Console.WriteLine("========================================");
            Console.Write("Välj ett alternativ: ");

            switch (Console.ReadLine())
            {
                case "1": ListAllBooks(context); break;
                case "2": ListAllCustomers(context); break;
                case "3": AddNewBook(context); break;
                case "4": PurchaseBook(context); break;
                case "5": isRunning = false; break;
                default: Console.WriteLine("Ogiltigt val."); break;
            }

            if (isRunning)
            {
                Console.WriteLine("\nTryck på valfri tangent för menyn...");
                Console.ReadKey();
            }
        }
    }


    // Hämtar alla böcker. Använder .Include för att utföra en JOIN i SQL.
    static void ListAllBooks(BookstoreContext context)
    {
        Console.WriteLine("\n--- BOKLISTA ---");

        // .Include() motsvarar en JOIN i SQL och hämtar relaterad data från Authors och Genres.
        var books = context.Books
            .Include(b => b.Author)
            .Include(b => b.Genre)
            .ToList();

        foreach (var b in books)
        {
            Console.WriteLine($"ID: {b.BookId} | Titel: {b.Title} | Författare: {b.Author.FirstName} {b.Author.LastName} | Pris: {b.Price:C}");
        }
    }


    // Enkel hämtning av alla rader i tabellen Customers.
    static void ListAllCustomers(BookstoreContext context)
    {
        Console.WriteLine("\n--- KUNDREGISTER ---");
        var customers = context.Customers.ToList();

        foreach (var c in customers)
        {
            Console.WriteLine($"ID: {c.CustomerId} | Namn: {c.FirstName} {c.LastName} | E-post: {c.Email}");
        }
    }


    // Lägger till en ny bok. Visar hur man skapar en entitet och sparar den.
    static void AddNewBook(BookstoreContext context)
    {
        Console.WriteLine("\n--- LÄGG TILL NY BOK ---");
        try
        {
            Console.Write("Titel: ");
            string title = Console.ReadLine() ?? "Okänd";

            Console.Write("ISBN: ");
            string isbn = Console.ReadLine() ?? "0";

            Console.Write("Pris: ");
            decimal price = decimal.Parse(Console.ReadLine() ?? "0");

            // Vi skapar ett nytt bok-objekt. 
            // För enkelhetens skull används ID 1 för författare/genre om inget annat anges.
            var newBook = new Book
            {
                Title = title,
                Isbn = isbn,
                Price = price,
                AuthorId = 1,
                GenreId = 1,
                StockQuantity = 10
            };

            context.Books.Add(newBook); // Lägger till i programmets minne.
            context.SaveChanges();      // Skickar faktiskt INSERT-kommandot till SQL Server.

            Console.WriteLine($"\nBoken '{title}' har sparats!");
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Kunde inte spara boken: {ex.Message}");
        }
    }


    // Genomför ett köp genom att anropa en lagrad procedur i databasen.
    static void PurchaseBook(BookstoreContext context)
    {
        Console.WriteLine("\n--- GENOMFÖR KÖP (STORED PROCEDURE) ---");
        try
        {
            Console.Write("Ange Kund-ID: ");
            int custId = int.Parse(Console.ReadLine());

            Console.Write("Ange Bok-ID: ");
            int bookId = int.Parse(Console.ReadLine());

            Console.Write("Antal: ");
            int qty = int.Parse(Console.ReadLine());

            // Här anropar vi vår Stored Procedure 'sp_ProcessCustomerOrder' som vi skapade tidigare.
            // Detta är säkert och hanterar transaktioner direkt i databasmotorn.
            context.Database.ExecuteSqlRaw("EXEC sp_ProcessCustomerOrder @p0, @p1, @p2", custId, bookId, qty);

            Console.WriteLine("\nKöp genomfört! Orderskapande och lageruppdatering skedde i en transaktion.");
        }
        catch (Exception ex)
        {
            // Fångar upp fel från SQL, t.ex. om lagret är slut (RAISERROR i proceduren).
            Console.WriteLine($"\nFel vid köp: {ex.Message}");
        }
    }
}