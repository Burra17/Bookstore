using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;

namespace Bookstore.Models;

public partial class BookstoreContext : DbContext // DbContext för Bookstore-databasen
{
    public BookstoreContext() // Parameterlös konstruktor
    {
    }

    public BookstoreContext(DbContextOptions<BookstoreContext> options) // Konstruktor med DbContextOptions
        : base(options)
    {
    }

    public virtual DbSet<Author> Authors { get; set; } // DbSet för författare

    public virtual DbSet<Book> Books { get; set; } // DbSet för böcker

    public virtual DbSet<Customer> Customers { get; set; } // DbSet för kunder

    public virtual DbSet<Genre> Genres { get; set; } // DbSet för genrer

    public virtual DbSet<Order> Orders { get; set; } // DbSet för ordrar

    public virtual DbSet<OrderItem> OrderItems { get; set; } // DbSet för orderrader

    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder) // Konfiguration av DbContext
    {
        // Vi lämnar denna tom eller låter den vara if-kontrollerad.
        // Konfigurationen kommer nu ske utifrån (i Program.cs).
        if (!optionsBuilder.IsConfigured)
        {
            // Denna kan lämnas tom nu när vi skickar in options via konstruktorn
        }
    }

    protected override void OnModelCreating(ModelBuilder modelBuilder) // Modellskapande och konfiguration
    {
        modelBuilder.Entity<Author>(entity => // Konfiguration för Author-entiteten
        {
            entity.HasKey(e => e.AuthorId).HasName("PK__Authors__70DAFC1416A7A631");

            entity.Property(e => e.AuthorId).HasColumnName("AuthorID");
            entity.Property(e => e.FirstName).HasMaxLength(50);
            entity.Property(e => e.LastName).HasMaxLength(50);
        });

        modelBuilder.Entity<Book>(entity => // Konfiguration för Book-entiteten
        {
            entity.HasKey(e => e.BookId).HasName("PK__Books__3DE0C227CA1B16BA");

            entity.HasIndex(e => e.Isbn, "UQ__Books__447D36EAC24ED1D9").IsUnique();

            entity.Property(e => e.BookId).HasColumnName("BookID");
            entity.Property(e => e.AuthorId).HasColumnName("AuthorID");
            entity.Property(e => e.GenreId).HasColumnName("GenreID");
            entity.Property(e => e.Isbn)
                .HasMaxLength(20)
                .HasColumnName("ISBN");
            entity.Property(e => e.Price).HasColumnType("decimal(10, 2)");
            entity.Property(e => e.Title).HasMaxLength(100);

            entity.HasOne(d => d.Author).WithMany(p => p.Books)
                .HasForeignKey(d => d.AuthorId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Books_Authors");

            entity.HasOne(d => d.Genre).WithMany(p => p.Books)
                .HasForeignKey(d => d.GenreId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Books_Genres");
        });

        modelBuilder.Entity<Customer>(entity => // Konfiguration för Customer-entiteten
        {
            entity.HasKey(e => e.CustomerId).HasName("PK__Customer__A4AE64B8FC5D7B8B");

            entity.HasIndex(e => e.Email, "UQ__Customer__A9D10534500496A7").IsUnique();

            entity.Property(e => e.CustomerId).HasColumnName("CustomerID");
            entity.Property(e => e.Email).HasMaxLength(100);
            entity.Property(e => e.FirstName).HasMaxLength(50);
            entity.Property(e => e.LastName).HasMaxLength(50);
            entity.Property(e => e.RegistrationDate)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime");
        });

        modelBuilder.Entity<Genre>(entity => // Konfiguration för Genre-entiteten
        {
            entity.HasKey(e => e.GenreId).HasName("PK__Genres__0385055E9811E7AE");

            entity.HasIndex(e => e.GenreName, "UQ__Genres__BBE1C3393335B899").IsUnique();

            entity.Property(e => e.GenreId).HasColumnName("GenreID");
            entity.Property(e => e.GenreName).HasMaxLength(30);
        });

        modelBuilder.Entity<Order>(entity => // Konfiguration för Order-entiteten
        {
            entity.HasKey(e => e.OrderId).HasName("PK__Orders__C3905BAF1A207328");

            entity.Property(e => e.OrderId).HasColumnName("OrderID");
            entity.Property(e => e.CustomerId).HasColumnName("CustomerID");
            entity.Property(e => e.OrderDate)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime");

            entity.HasOne(d => d.Customer).WithMany(p => p.Orders)
                .HasForeignKey(d => d.CustomerId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Orders_Customers");
        });

        modelBuilder.Entity<OrderItem>(entity => // Konfiguration för OrderItem-entiteten
        {
            entity.HasKey(e => e.OrderItemId).HasName("PK__OrderIte__57ED06A18E9F9160");

            entity.Property(e => e.OrderItemId).HasColumnName("OrderItemID");
            entity.Property(e => e.BookId).HasColumnName("BookID");
            entity.Property(e => e.OrderId).HasColumnName("OrderID");
            entity.Property(e => e.UnitPrice).HasColumnType("decimal(10, 2)");

            entity.HasOne(d => d.Book).WithMany(p => p.OrderItems)
                .HasForeignKey(d => d.BookId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_OrderItems_Books");

            entity.HasOne(d => d.Order).WithMany(p => p.OrderItems)
                .HasForeignKey(d => d.OrderId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_OrderItems_Orders");
        });

        OnModelCreatingPartial(modelBuilder); // Anropar den partiella metoden för ytterligare konfiguration
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder); // Partiell metod för ytterligare modellkonfiguration
}
