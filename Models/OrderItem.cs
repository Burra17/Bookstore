using System;
using System.Collections.Generic;

namespace Bookstore.Models;

public partial class OrderItem // Representerar en orderrad i en order
{
    public int OrderItemId { get; set; }

    public int OrderId { get; set; }

    public int BookId { get; set; }

    public int Quantity { get; set; }

    public decimal UnitPrice { get; set; } // Pris per enhet vid beställningstillfället

    public virtual Book Book { get; set; } = null!; // Navigationsegenskap till boken som beställts

    public virtual Order Order { get; set; } = null!; // Navigationsegenskap till ordern som innehåller denna orderrad
}
