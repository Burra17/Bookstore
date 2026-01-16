using System;
using System.Collections.Generic;

namespace Bookstore.Models;

public partial class Order // Representerar en order i bokhandeln
{
    public int OrderId { get; set; }

    public DateTime OrderDate { get; set; }

    public int CustomerId { get; set; }

    public virtual Customer Customer { get; set; } = null!; // Navigationsegenskap till kunden som gjorde ordern

    public virtual ICollection<OrderItem> OrderItems { get; set; } = new List<OrderItem>(); // Navigationsegenskap till orderrader i denna order
}
