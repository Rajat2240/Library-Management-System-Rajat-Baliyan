Create database LibraryDB;
USE LibraryDB

----  BooksTable ----

Create Table Books (
Book_id int primary key,
Title varchar(100),
Author varchar(100),
Genre varchar(50),
Year_Published int,
Available_copies int);

Insert into Books Values
(1, 'Rich dad poor dad', 'Sharon Lechter', 'Finance', 2000, 3),
(2, 'Harry Potter', 'Rowling', 'Fantasy', 1997, 5),
(3, 'The invisible Man', 'Wells', 'Science', 1897, 4),
(4, 'The Hobbit', 'J.R.R. Tolkien', 'Fantasy', 1937, 3),
(5, 'Fahrenheit 451', 'Ray Bradbury', 'Dystopian', 1953, 1);

-----  Members Table ----

CREATE TABLE Members(
    Member_id INT Primary key,
    Name Varchar(255),
    Email Varchar(255),
    Phone_NO Varchar(20),
    Address Text,
    Membership_Date Date);
    
Insert into Members Values 
(1, 'Akash', 'Akash@example.com', '1234567890', 'Dabri extension', '2024-01-15'),
(2, 'Varun', 'Varun@example.com', '2345678901', 'Shalimar Bagh', '2024-02-10'),
(3, 'Tom', 'Tom@example.com', '3456789012', 'Ashok Viahr', '2024-03-05');

---- Borrowing records Table -----

Create table BorrowingRecords(
    BORROW_ID INT Primary key,
    MEMBER_ID INT,
    BOOK_ID INT,
    BORROW_DATE Date,
    RETURN_DATE Date,
    Foreign Key (MEMBER_ID) REFERENCES Members(MEMBER_ID),
    Foreign Key (Book_id) REFERENCES Books(Book_id));
    
INSERT INTO BorrowingRecords VALUES 
(1, 1, 1, '2025-04-10', NULL),
(2, 2, 2, '2025-03-15', '2025-04-15'),
(3, 1, 3, '2025-05-01', NULL),
(4, 2, 1, '2025-01-01', '2025-01-25'),
(5, 3, 2, '2025-03-01', NULL),
(6, 3, 1, '2025-01-15', '2025-01-30'),
(7, 3, 4, '2025-02-01', '2025-02-15');

Select * from Books
Select * from Members
Select * from BorrowingRecords

--- Retrieve a list of books currently borrowed by a specific member. ---

SELECT Members.NAME, Books.TITLE
FROM Members
JOIN BorrowingRecords ON Members.MEMBER_ID = BorrowingRecords.MEMBER_ID
JOIN Books ON BorrowingRecords.BOOK_ID = Books.BOOK_ID
WHERE BorrowingRecords.RETURN_DATE IS NULL;

---- Find members who have overdue books (borrowed more than 30 days ago, not 
returned) ----

SELECT Members.NAME, Books.TITLE, BorrowingRecords.BORROW_DATE
FROM Members
JOIN BorrowingRecords ON Members.MEMBER_ID = BorrowingRecords.MEMBER_ID
JOIN Books ON BorrowingRecords.BOOK_ID = Books.BOOK_ID
WHERE BorrowingRecords.RETURN_DATE IS NULL
  AND BorrowingRecords.BORROW_DATE < CURDATE() - INTERVAL 30 DAY;
  
---- Retrieve books by genre along with the count of available copies ----

Select Genre, Sum(Available_Copies) AS Total_Copies
From Books
Group by Genre;

----Find the most borrowed book(s) overall----

Select B.Title, Count(*) As Times_Borrowed
From BorrowingRecords BR
Join Books B On BR.BOOK_ID = B.BOOK_ID
Group By B.TITLE
Having Count(*) = (
    Select Max(BorrowCount)
    From (
        Select Count(*) AS BorrowCount
        from BorrowingRecords
        Group By BOOK_ID
    ) As Counts);
    
----Retrieve members who have borrowed books from at least three different genres----

Select m.name, count(distinct b.Genre) As Genre_count
From BorrowingRecords BR
join Members m on br.MEMBER_ID = m.MEMBER_ID
join books b on br.book_id = b.book_id
group by m.MEMBER_ID, m.name
having count(distinct b.genre) >= 3;

---- Reporting and Analytics: ----

---- Calculate the total number of books borrowed per month ----

select date_format(borrow_date, '%y-%m-%d') as month, count(*)
as total_borrowed
from Borrowingrecords
group by month
order by month;

---- Find the top three most active members based on the number of books 
borrowed ---

Select m.name, count(*) AS Borrow_Count
From BorrowingRecords BR
Join Members M ON BR.MEMBER_ID = M.MEMBER_ID
Group by M.MEMBER_ID, m.name
Order by BORROW_COUNT DESC
LIMIT 3;

---- Retrieve authors whose books have been borrowed at least 10 times ----

select b.author, count(*) as times_borrowed
from borrowingrecords br
join books b on br.book_id = b.book_id
group by b.author
having count(*) >= 10;

---- Identify members who have never borrowed a book ----

select m.member_id, m.name, m.email
from members m
left join borrowingrecords br on m.member_id = br.member_id
where br.borrow_id is null;







