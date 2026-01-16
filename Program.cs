using Microsoft.Extensions.Configuration;
using Microsoft.EntityFrameworkCore;
using Bookstore.Models; // Säkerställ att detta matchar ditt namespace från scaffolding

namespace BookstoreApp;

class Program
{
    static void Main(string[] args)
    {
        // 1. KONFIGURATION: Läs in appsettings.json
        var builder = new ConfigurationBuilder()
            .SetBasePath(Directory.GetCurrentDirectory())
            .AddJsonFile("appsettings.json", optional: false, reloadOnChange: true);

        IConfiguration configuration = builder.Build();
        string connectionString = configuration.GetConnectionString("DefaultConnection")
            ?? throw new InvalidOperationException("Anslutningssträngen 'DefaultConnection' hittades inte.");

        // 2. SETUP: Konfigurera DbContextOptions
        var optionsBuilder = new DbContextOptionsBuilder<BookstoreContext>();
        optionsBuilder.UseSqlServer(connectionString);

        // 3. KÖRNVÄG: Starta huvudloopen
        using var context = new BookstoreContext(optionsBuilder.Options);
        RunMenu(context);
    }

    static void RunMenu(BookstoreContext context)
    {
        bool isRunning = true;
        while (isRunning)
        {
            Console.Clear();
            Console.WriteLine("========================================");
            Console.WriteLine("       THE MINIMALIST BOOKSTORE        ");
            Console.WriteLine("========================================");
            Console.WriteLine("1. Lista alla böcker (inkl. författare)");
            Console.WriteLine("2. Visa alla kunder");
            Console.WriteLine("3. Lägg till en ny bok (INSERT)");
            Console.WriteLine("4. Avsluta");
            Console.WriteLine("========================================");
            Console.Write("Välj ett alternativ: ");

            switch (Console.ReadLine())
            {
                case "1":
                    ListAllBooks(context);
                    break;
                case "2":
                    ListAllCustomers(context);
                    break;
                case "3":
                    AddNewBook(context);
                    break;
                case "4":
                    isRunning = false;
                    break;
                default:
                    Console.WriteLine("Ogiltigt val, försök igen.");
                    break;
            }

            if (isRunning)
            {
                Console.WriteLine("\nTryck på valfri tangent för att gå tillbaka till menyn...");
                Console.ReadKey();
            }
        }
    }

    // VG-KRAV: SELECT med relationer (.Include motsvarar JOIN)
    static void ListAllBooks(BookstoreContext context)
    {
        Console.WriteLine("\n--- BOKLISTA ---");
        var books = context.Books
            .Include(b => b.Author)
            .Include(b => b.Genre)
            .ToList();

        foreach (var b in books)
        {
            Console.WriteLine($"ID: {b.BookId} | Titel: {b.Title} | Författare: {b.Author.FirstName} {b.Author.LastName} | Pris: {b.Price:C}");
        }
    }

    // VG-KRAV: Enkel SELECT
    static void ListAllCustomers(BookstoreContext context)
    {
        Console.WriteLine("\n--- KUNDREGISTER ---");
        var customers = context.Customers.ToList();

        foreach (var c in customers)
        {
            Console.WriteLine($"ID: {c.CustomerId} | Namn: {c.FirstName} {c.LastName} | E-post: {c.Email}");
        }
    }

    // VG-KRAV: INSERT (Bonus)
    static void AddNewBook(BookstoreContext context)
    {
        Console.WriteLine("\n--- LÄGG TILL NY BOK ---");

        Console.Write("Titel: ");
        string title = Console.ReadLine() ?? "Okänd titel";

        Console.Write("ISBN: ");
        string isbn = Console.ReadLine() ?? "000-000";

        Console.Write("Pris: ");
        decimal price = decimal.Parse(Console.ReadLine() ?? "0");

        // För enkelhetens skull hårdkodar vi GenreID och AuthorID här 
        // I en riktig app skulle användaren få välja från en lista
        Console.Write("Ange Författar-ID (t.ex. 1 för Astrid Lindgren): ");
        int authorId = int.Parse(Console.ReadLine() ?? "1");

        Console.Write("Ange Genre-ID (t.ex. 1 för Barnlitteratur): ");
        int genreId = int.Parse(Console.ReadLine() ?? "1");

        var newBook = new Book
        {
            Title = title,
            Isbn = isbn,
            Price = price,
            AuthorId = authorId,
            GenreId = genreId,
            StockQuantity = 10
        };

        context.Books.Add(newBook);
        context.SaveChanges();

        Console.WriteLine($"\nKLART! '{title}' har lagts till i databasen.");
    }
}