using System;
using System.Collections.Generic;

namespace Bookstore.Models;

public partial class Author // Representerar en författare i bokhandeln 
{
    public int AuthorId { get; set; } 

    public string FirstName { get; set; } = null!;

    public string LastName { get; set; } = null!;

    public int? BirthYear { get; set; }

    public virtual ICollection<Book> Books { get; set; } = new List<Book>(); // Navigationsegenskap till böcker skrivna av författaren
}
