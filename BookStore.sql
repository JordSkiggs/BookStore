-- Creating a small table for bookstore that holds all of my favourite books

CREATE TABLE bookstore (
    BookID int,
    BookName varchar(255),
    Publisher varchar(255),
    ISBN varchar(17),
	Edition varchar(255),
	Pages int,
	Sales int,
	City varchar(255),
	Price numeric
);

-- Inserting the values for each column with the data for my favourite books

INSERT INTO bookstore 
VALUES ('1', 'Alice in Wonderland', 'CreateSpace Independent Publishing Platform', '978-1503222687', '7th Edition', '70', '1953456', 'New York', '5.99'),
       ('2', 'Solo Leveling Vol.1', 'Yen Press', '978-1975319274', '1st Edition', '232', '232654', 'Seoul', '11.75'),
	   ('3', 'Love Simon: Simon Vs The Homo Sapiens Agenda', 'Penguin', '978-0241330135','2nd Edition', '352', '864877', 'New York', '5.99'),
	   ('4', 'The Creative Gene', 'Viz Media', '978-1974725915', '1st Edition', '256', '501222', 'Tokyo', '13.99'),
	   ('5', 'The Storyteller: Tales of Life and Music', 'Simon and Schuster','978-1398503700', '1st Edition', '384', '955448', 'Washington', '16.00'),
	   ('6', 'Dictionary of Modern American Philosophers', 'Thoemmes Continuum', '978-1843710370', '1st Edition', '1500', '12695', 'Athens', '1197.16'),
	   ('7', 'Harry Potter Childrens Collection: The Complete Collection', 'Bloomsbury', '978-1408856772', '5th Edition', '3872', '5641888', 'London', '39.22');

-- I realised I made a mistake in two of the rows so I will update the city name for both of these
UPDATE bookstore
SET City = 'London'
WHERE BookName= 'The Creative Gene' OR BookName = 'Solo Leveling Vol.1';

-- Viewing my finished table

SELECT *
FROM bookstore;

-- Which book is the most bought book in the store?

SELECT BookName, Publisher, Sales, Price
FROM bookstore
WHERE sales = (SELECT MAX(sales)
                FROM bookstore
                );
-- Using a substring so I can see the variables I want to see, I can use the MAX aggregate function to find 
-- which book had the biggest sales in the store. Including it's name, publishes, sales and price

-- Or I can use a simple order by function and whichever the top row is will be the most bought book

SELECT BookName, Publisher, Sales, Price
FROM bookstore
ORDER BY sales DESC;

-- Using this I can see Harry Potter is at the top followed by Alice in Wonderland

-- Which book was the most popular book in each city?

SELECT a.Bookname, a.city, a.sales
FROM bookstore AS a
INNER JOIN (
   SELECT city, MAX(sales) AS maxsales
FROM bookstore
GROUP BY  City
) AS b ON a.sales = b.maxsales
ORDER BY maxsales DESC;

-- Using an inner join to view the variables I want to see I can see that the most popular book in London was
-- Harry Potter and the most popular book in New York was Alice in Wonderland

-- What is the most expensive book?

SELECT BookName, Publisher, Price
FROM bookstore
ORDER BY price DESC;

-- Using an order by function I can see that the Disctionary of Modern American Philosophers is the most 
-- expensive at a whopping £1197

-- Similarly to a previous query, I can use a substring to return just the most expensive book

SELECT BookName, Publisher, Price
FROM bookstore
WHERE Price = (SELECT MAX(Price)
                FROM bookstore
                );

-- Which book is least preferred by readers?

SELECT BookName, Publisher, Sales, Price
FROM bookstore
ORDER BY sales ASC;

-- I can see again using the ORDER BY function that the Disctionary of Modern American Philosophers
-- is the least preffered
-- Again I can use a substring and use the MIN function to return just that row

SELECT BookName, Publisher, Sales, Price
FROM bookstore
WHERE sales = (SELECT MIN(sales)
                FROM bookstore
                );

-- What are the percentages of sales for all of the books in the store

SELECT BookName,SUM(sales),
       ROUND(SUM(sales) * 100.0 / SUM(SUM(sales)) OVER () ,2) AS Percentage
FROM bookstore
GROUP BY BookName
ORDER BY Percentage DESC;

-- I can see that Harry Potter takes up over half of the stores book sales and The Creative Gene
-- Takes 4.93% of the total sales

-- Does the price of a book affect the sales of a book in the bookstore?

SELECT BookName, Price, Sales, ROUND(SUM(sales) * 100.0 / SUM(SUM(sales)) OVER () ,2) AS Percentage
From bookstore
GROUP BY BookName, Price, Sales
ORDER BY Price, Sales

-- At a glance of the table even though the smaller priced items a good percentage, it seems higher priced items
-- like Tales of Life and Music and Harry Potter are still taking up most so I would say it does not affect sales