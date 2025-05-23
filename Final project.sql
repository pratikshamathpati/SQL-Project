-- Create Database
CREATE DATABASE OnlineBookstore;

-- Switch to the database
\c OnlineBookstore;

--Create tables
DROP TABLE IF EXISTS Books;
CREATE TABLE Books(
     Book_ID SERIAL PRIMARY KEY,
	 Title VARCHAR(100),
	 Author VARCHAR(100),
	 Genre VARCHAR(50),
	 Published_Year INT,
	 Price NUMERIC(10,2),
	 Stock INT
);

DROP TABLE IF EXISTS customers;
CREATE TABLE Customers(
     Customer_ID SERIAL PRIMARY KEY,
	 Name VARCHAR(100),
	 Email VARCHAR(100),
     Phone VARCHAR(15),
	 City VARCHAR(50),
	 Country VARCHAR(150)
);

DROP TABLE IF EXISTS Orders;
CREATE TABLE Orders(
     Order_ID SERIAL PRIMARY KEY,
	 Customer_ID INT REFERENCES Customers(Customer_ID),
	 Book_ID INT REFERENCES Books(Book_ID),
	 Order_Date DATE,
	 Quantity INT,
	 Total_Amount NUMERIC(10,2)
);

SELECT * FROM Customers;
SELECT * FROM Orders;
SELECT * FROM Books;

--Import Data into Books table
COPY Books(Book_ID,	Title,	Author,	Genre,	Published_Year, Price,	Stock)
FROM 'C:\Users\hp\Downloads\Books.csv'
CSV HEADER;


--Import Data into Customers table
COPY Books(Customer_ID SERIAL, Name, Email, Phone, City, Country)
FROM 'C:\Users\hp\Downloads\Customers.csv'
CSV HEADER;

--Import Data into Orders table
COPY Books(Order_ID, Customer_ID, Book_ID, Order_Date DATE, Quantity INT, Total_Amount)
FROM 'C:\Users\hp\Downloads\Orders.csv'
CSV HEADER;


--1) Retrieve all books in the "Fiction" genre:

SELECT * FROM Books 
WHERE genre='Fiction';

--2) Find books published after the year 1950

SELECT * FROM Books
WHERE Published_Year>1950;

--3) List all the customers from the canada

SELECT * FROM Customers
WHERE Country='Canada';

--4) Show prders placed in November 2023

SELECT * FROM Orders
WHERE Order_Date BETWEEN '2023-11-01' AND '2023-11-30';

--5) Retrieve the total stock of Books available

SELECT SUM(Stock) AS total_stock
FROM Books;

--6) Find the details of the most expensive books

SELECT * FROM Books ORDER BY Price DESC;

SELECT * FROM Books ORDER BY Price DESC LIMIT 1;

--7) Show all the customers who ordered more than 1 quantity of a book

SELECT * FROM Orders
WHERE quantity>1 ;

--8) Retrieve all orders where the total amount exceeds $20

SELECT * FROM Orders
WHERE total_amount>20;

--9) List all genres available in the books table

SELECT DISTINCT Genre FROM Books;

--10) Find the books with the lowest stock

SELECT * FROM Books ORDER BY Stock LIMIT 1;

--11) Calculate the total revenue generated from all orders

SELECT SUM(total_amount) AS Revenue
FROM Orders;

--Advance Questions

--1) Retrieve total number of books sold for each genre
SELECT * FROM  Orders;

SELECT b.Genre, SUM(o.Quantity) AS Toal_books_sold
FROM Orders o
JOIN Books b 
ON o.book_id= b.book_id
GROUP BY b.Genre;

--2) Find the average price of books in the "Fantacy" genre
SELECT AVG(Price) AS Average_price
FROM Books
WHERE Genre='Fantasy';

--3) List customers who have placed at least 2 orders
SELECT customer_id, COUNT(Order_id) AS Order_count
FROM Orders
GROUP BY customer_id
HAVING COUNT(order_id) >=2;

SELECT o.customer_id, c.name, COUNT(o.Order_id) AS Order_count
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id
GROUP BY o.customer_id, c.name
HAVING COUNT(order_id) >=2;

--4) Find the most frequently ordered book
SELECT * FROM Books;

SELECT Book_id, COUNT(order_id) AS order_count
FROM orders
GROUP BY book_id
ORDER BY order_count DESC LIMIT 1;

SELECT o.Book_id, b.title, COUNT(order_id) AS order_count
FROM orders o
JOIN Books b ON o.book_id=b.book_id
GROUP BY o.book_id, b.title
ORDER BY order_count DESC LIMIT 1;

--5) Show the top 3 most expensive books of 'Fantasy' Genre
SELECT * FROM books
WHERE genre='Fantasy'
ORDER BY price DESC LIMIT 3;

--6) Retrieve the total quantity of books sold by each author
SELECT b.author, SUM(o.quantity) AS total_books_sold
FROM Orders o
JOIN books b ON o.book_id= b.book_id
GROUP BY b.author;

--7) List the cities where customers who spent over $30 are located
SELECT DISTINCT c.city, total_amount
FROM orders o
JOIN customers c ON o.customer_id= c.customer_id
WHERE o.total_amount>30;

--8) Find the customer who spent the most on orders
SELECT c.customer_id, c.name, SUM(o.total_amount) AS total_spent
FROM orders o
JOIN customers c ON o.customer_id=c.customer_id
GROUP BY c.customer_id, c.name
ORDER BY total_spent DESC LIMIT 1;   

--9) calculate the stock remaining after fulfilling all orders
SELECT b.book_id, b.title, b.stock, COALESCE(SUM(quantity),0) AS order_quantity
FROM books b
LEFT JOIN orders o ON b.book_id=o.book_id
GROUP BY b.book_id;

SELECT b.book_id, b.title, b.stock, COALESCE(SUM(o.quantity),0) AS order_quantity, 
b.stock-COALESCE(SUM(o.quantity),0) AS remining_quantity
FROM books b
LEFT JOIN orders o ON b.book_id=o.book_id
GROUP BY b.book_id;
