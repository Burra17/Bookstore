-- Använd Bookstore databasen
USE Bookstore; 
GO

-- 1. Skapa tabellen Authors (Författare)
CREATE TABLE Authors (
    AuthorID INT PRIMARY KEY IDENTITY(1,1),
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    BirthYear INT NULL
);

-- 2. Skapa tabellen Genres (Kategorier)
CREATE TABLE Genres (
    GenreID INT PRIMARY KEY IDENTITY(1,1),
    GenreName NVARCHAR(30) NOT NULL UNIQUE -- Krav: UNIQUE constraint
);

-- 3. Skapa tabellen Customers (Kunder)
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY IDENTITY(1,1),
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Email NVARCHAR(100) NOT NULL UNIQUE,   -- Krav: UNIQUE constraint alla kunder behöver unika email
    RegistrationDate DATETIME DEFAULT GETDATE() -- Krav: DEFAULT constraint
);

-- 4. Skapa tabellen Books (Böcker)
-- Denna tabell har Foreign Keys till både Authors och Genres.
CREATE TABLE Books (
    BookID INT PRIMARY KEY IDENTITY(1,1),
    Title NVARCHAR(100) NOT NULL,
    ISBN NVARCHAR(20) NOT NULL UNIQUE, -- Unik international standard book number
    Price DECIMAL(10,2) NOT NULL CHECK (Price > 0), -- Krav: CHECK constraint kollar så att pris är över 0
    StockQuantity INT NOT NULL DEFAULT 0,          -- Krav: DEFAULT constraint
    AuthorID INT NOT NULL,
    GenreID INT NOT NULL,
    CONSTRAINT FK_Books_Authors FOREIGN KEY (AuthorID) REFERENCES Authors(AuthorID), -- Foreign Key
    CONSTRAINT FK_Books_Genres FOREIGN KEY (GenreID) REFERENCES Genres(GenreID) -- Foreign Key
);

-- 5. Skapa tabellen Orders (Beställningar)
-- Kopplad till en Customer.
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY IDENTITY(1,1),
    OrderDate DATETIME NOT NULL DEFAULT GETDATE(),
    CustomerID INT NOT NULL,
    CONSTRAINT FK_Orders_Customers FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID) -- Foreign Key
);

-- 6. Skapa tabellen OrderItems (Kopplingstabell / Orderrader)
-- Hanterar Många-till-många relationen mellan Orders och Books.
CREATE TABLE OrderItems (
    OrderItemID INT PRIMARY KEY IDENTITY(1,1), 
    OrderID INT NOT NULL,
    BookID INT NOT NULL,
    Quantity INT NOT NULL CHECK (Quantity > 0), -- Krav: CHECK constraint
    UnitPrice DECIMAL(10,2) NOT NULL,           -- Priset vid köptillfället
    CONSTRAINT FK_OrderItems_Orders FOREIGN KEY (OrderID) REFERENCES Orders(OrderID), -- Foreign Key
    CONSTRAINT FK_OrderItems_Books FOREIGN KEY (BookID) REFERENCES Books(BookID) -- Foreign Key
);
GO