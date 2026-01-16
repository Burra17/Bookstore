using System;
using System.Collections.Generic;

namespace Bookstore.Models;

public partial class Genre // Representerar en genre i bokhandeln
{
    public int GenreId { get; set; }

    public string GenreName { get; set; } = null!;

    public virtual ICollection<Book> Books { get; set; } = new List<Book>(); // Navigationsegenskap till böcker inom denna genre
}
