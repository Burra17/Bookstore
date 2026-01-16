using System;
using System.Collections.Generic;

namespace Bookstore.Models;

public partial class Book // Representerar en bok i bokhandeln
{
    public int BookId { get; set; }

    public string Title { get; set; } = null!;

    public string Isbn { get; set; } = null!;

    public decimal Price { get; set; }

    public int StockQuantity { get; set; }

    public int AuthorId { get; set; }

    public int GenreId { get; set; }

    public virtual Author Author { get; set; } = null!; // Navigationsegenskap till författaren

    public virtual Genre Genre { get; set; } = null!; // Navigationsegenskap till genren

    public virtual ICollection<OrderItem> OrderItems { get; set; } = new List<OrderItem>(); // Navigationsegenskap till orderrader som innehåller denna bok
}
