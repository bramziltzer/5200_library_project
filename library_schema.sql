-- DROP DATABASE library_system;
CREATE DATABASE IF NOT EXISTS library_system;
USE library_system;
-- easier to make one type of intended user, the librarian. 
-- Should librarian table include username/password so they can log in?
CREATE TABLE address (
  address_id INT AUTO_INCREMENT,
  street_address VARCHAR(64) NOT NULL,
  city VARCHAR(64) NOT NULL,
  state CHAR(2) NOT NULL,
  zip_code CHAR(5) NOT NULL,
  PRIMARY KEY (address_id)
);

CREATE TABLE library_branch (
  	library_id INT AUTO_INCREMENT,
  	address_id INT NOT NULL,    
  PRIMARY KEY (library_id),
  CONSTRAINT library_branch_fk_address
		FOREIGN KEY (address_id)
  	REFERENCES address (address_id)
    ON UPDATE CASCADE ON DELETE RESTRICT
);

ALTER TABLE library_branch ADD library_name VARCHAR(64) NOT NULL;
UPDATE `library_system`.`library_branch` SET `library_name` = 'Snell Library' WHERE (`library_id` = '1');
UPDATE `library_system`.`library_branch` SET `library_name` = 'Western Library' WHERE (`library_id` = '2');
UPDATE `library_system`.`library_branch` SET `library_name` = 'Great Library' WHERE (`library_id` = '3');

CREATE TABLE genre_type (
	genre VARCHAR(64) PRIMARY KEY
);

CREATE TABLE publisher(
	publisher_id INT AUTO_INCREMENT,
  publisher_name VARCHAR(100) NOT NULL,
  address_id INT,
  PRIMARY KEY (publisher_id),
  CONSTRAINT publisher_fk_address
		FOREIGN KEY (address_id)
  	REFERENCES address (address_id)
    ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE book (
  isbn CHAR(13) NOT NULL,
  title VARCHAR(64) NOT NULL,
  year_published CHAR(4) NOT NULL,
  publisher_id INT NOT NULL,
  number_of_pages INT,
  genre VARCHAR(64),
  PRIMARY KEY (isbn),
  CONSTRAINT book_fk_genre_type
		FOREIGN KEY (genre)
  	REFERENCES genre_type (genre)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT book_fk_publisher
		FOREIGN KEY (publisher_id)
  	REFERENCES publisher (publisher_id)
    ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE author (
  author_id INT AUTO_INCREMENT,
  author_name VARCHAR(100) NOT NULL,
  country_of_origin VARCHAR(64),
  PRIMARY KEY (author_id)
);

CREATE TABLE book_author(
	isbn CHAR(13) NOT NULL,
  author_id INT NOT NULL,
  PRIMARY KEY (isbn, author_id),
  CONSTRAINT book_author_fk_author
		FOREIGN KEY (author_id)
  	REFERENCES author (author_id)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT book_author_fk_book
		FOREIGN KEY (isbn)
  	REFERENCES book (isbn)
    ON UPDATE CASCADE ON DELETE RESTRICT
);

-- need a table for checking out books, the date they were checked out, which librarian checked it out for the member
-- need to keep track of fines
CREATE TABLE book_copy (
  book_copy_id INT AUTO_INCREMENT,
	isbn CHAR(13) NOT NULL,
  library_id INT NOT NULL,
  is_checked_out BOOL DEFAULT FALSE,
  PRIMARY KEY (book_copy_id),
  CONSTRAINT book_copy_fk_book
		FOREIGN KEY (isbn)
  	REFERENCES book (isbn)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT book_copy_fk_library_branch
		FOREIGN KEY (library_id)
  	REFERENCES library_branch (library_id)
    ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE member (
  member_id INT AUTO_INCREMENT,
  email VARCHAR(64) NOT NULL,
  name VARCHAR(64) NOT NULL,
  registration_date DATE NOT NULL,
  fine_balance DECIMAL(9,2) DEFAULT 0.00,
  PRIMARY KEY (member_id)
);

CREATE TABLE librarian (
  librarian_id INT AUTO_INCREMENT,
  library_id INT NOT NULL,
  name VARCHAR(64) NOT NULL,
  email VARCHAR(64) NOT NULL,
  hire_date DATE NOT NULL,
  address_id INT,
  PRIMARY KEY (librarian_id),
  CONSTRAINT librarian_fk_library_branch
		FOREIGN KEY (library_id)
  	REFERENCES library_branch (library_id)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT librarian_fk_address
		FOREIGN KEY (address_id)
  	REFERENCES address (address_id)
    ON UPDATE CASCADE ON DELETE RESTRICT
);

  -- ADD AN EVENT
CREATE TABLE book_checkout (
	transaction_id INT AUTO_INCREMENT,
  book_copy_id INT NOT NULL,
  date_checked_out DATE NOT NULL,
  member_id INT NOT NULL,
  librarian_id INT,
  is_returned BOOL DEFAULT FALSE,
  is_fined BOOL DEFAULT FALSE,
  PRIMARY KEY (transaction_id),
  CONSTRAINT book_checkout_fk_book_copy
		FOREIGN KEY (book_copy_id)
  	REFERENCES book_copy (book_copy_id)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT book_checkout_fk_member
		FOREIGN KEY (member_id)
  	REFERENCES member (member_id)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT book_checkout_fk_librarian
		FOREIGN KEY (librarian_id)
  	REFERENCES librarian (librarian_id)
    ON UPDATE CASCADE ON DELETE RESTRICT
);
-- create event to check all checked out books in book_copy table
-- if 45 days past due date and have not already been fined for this book, charge $100 to member table
-- create procedure for librarian to clear fines

-- procedures and triggers

-- add book
  -- is it ok to use author_id and publisher_id instead of their names
  -- potential option: create separate procedure for adding author/publisher and in the python code have an interaction
  -- 									 that asks to check if the author/publisher exists in the database
  -- python error message pop out for num_copies_to_add_p
  -- add error handler for bad foreign keys
  -- use transactions
DELIMITER $$
CREATE PROCEDURE add_book (isbn_p CHAR(13), title_p VARCHAR(64), author_id_p INT, genre_p VARCHAR(64), num_pages_p INT,
                           year_published_p CHAR(4), publisher_id_p INT, library_id_p INT, num_copies_to_add_p INT)
clf:BEGIN
  DECLARE loop_var INT;
  SET loop_var = num_copies_to_add_p;
  IF(NOT EXISTS(SELECT * FROM author WHERE author_id = author_id_p)) THEN
    SELECT 'Author does not exist! Please try entry again.';
    LEAVE clf;
  ELSEIF(NOT EXISTS(SELECT * FROM publisher WHERE publisher_id = publisher_id_p)) THEN
    SELECT 'Publisher does not exist! Please try entry again.';
    LEAVE clf;
  ELSEIF(NOT EXISTS(SELECT * FROM library_branch WHERE library_id = library_id_p)) THEN
    SELECT 'Library does not exist! Please try entry again.';
    LEAVE clf;
  ELSEIF(EXISTS(SELECT * FROM book WHERE isbn = isbn_p)) THEN
    SELECT 'ISBN already exists in the system! Make sure you use the correct number.';
    LEAVE clf;
  ELSEIF(NOT EXISTS(SELECT * FROM genre_type WHERE genre = genre_p)) THEN
    SELECT 'Genre does not exist! Please try entry again.';
    LEAVE clf;
  ELSE
  
  INSERT INTO book VALUES(isbn_p, title_p, year_published_p, publisher_id_p, num_pages_p, genre_p);
  INSERT INTO book_author VALUES(isbn_p, author_id_p);

  WHILE loop_var != 0 DO
    INSERT INTO book_copy (isbn, library_id) VALUES (isbn_p, library_id_p);
    SET loop_var = loop_var - 1;
  END WHILE;
  END IF;
  SELECT 'Successfully added book to the database!';
END $$
DELIMITER ;

-- add member
-- adding validation
DELIMITER $$
CREATE PROCEDURE add_member (email_p VARCHAR(64), name_p VARCHAR(64))
clf:BEGIN
  IF (EXISTS(SELECT * FROM member WHERE email = email_p)) THEN
    SELECT 'Member already exists!';
    LEAVE clf;
  ELSE
    INSERT INTO member(email, name, registration_date) VALUES(email_p, name_p, CURDATE());
  END IF;
END $$
DELIMITER ;

-- remove member
-- note, if they've ever checked out a book they can't be deleted
-- validation
DELIMITER $$
CREATE PROCEDURE remove_member (member_id_p INT)
clf:BEGIN
  IF(NOT EXISTS(SELECT * FROM member WHERE member_id = member_id_p)) THEN
    SELECT 'Member does not exist!';
    LEAVE clf;
  ELSEIF(EXISTS(SELECT * FROM book_checkout WHERE member_id = member_id_p AND is_returned = FALSE)) THEN
    SELECT 'Member has checked out books and cannot be deleted.';
    LEAVE clf;
  ELSE
    DELETE FROM member WHERE member_id = member_id_p;
  END IF;
END $$
DELIMITER ;

-- TODO update member email


-- Search by three types
-- only accept three inputs: title, author, isbn
DELIMITER $$
CREATE PROCEDURE search_books (search_type_p VARCHAR(64), search_content VARCHAR(64))
BEGIN

	IF search_type_p = 'title' THEN
    SELECT * FROM book_copy WHERE isbn IN 
    (SELECT isbn FROM book WHERE title = search_content);
  ELSEIF search_type_p = 'author' THEN
  	SELECT * FROM book_copy WHERE isbn IN 
    (SELECT isbn FROM book_author WHERE author_id IN 
     (SELECT author_id FROM author WHERE author_name = search_content));
  ELSEIF search_type_p = 'isbn' THEN
  	SELECT * FROM book_copy WHERE isbn = search_content;
  ELSE 
    SELECT 'Wrong Input! Please check and input again';
  END IF;

END $$
DELIMITER ;

-- check out books
DELIMITER $$
CREATE PROCEDURE check_out_books (book_copy_id_p INT, member_id_p INT, librarian_id_p INT)
clf:BEGIN
  IF(EXISTS(SELECT * FROM book_copy WHERE book_copy_id = book_copy_id_p AND is_checked_out = TRUE)) THEN
    SELECT'Book is already checked out!';
    LEAVE clf;
  ELSEIF(NOT EXISTS(SELECT * FROM book_copy WHERE book_copy_id = book_copy_id_p)) THEN
    SELECT'Book copy not exists!';
    LEAVE clf;
  ELSEIF(NOT EXISTS(SELECT * FROM member WHERE member_id = member_id_p)) THEN
    SELECT'Member not exists!';
    LEAVE clf;
  ELSEIF(NOT EXISTS(SELECT * FROM librarian WHERE librarian_id = librarian_id_p)) THEN
    SELECT'Librarian not exists!';
    LEAVE clf;
  ELSE 
  UPDATE book_copy SET is_checked_out = TRUE WHERE book_copy_id = book_copy_id_p;
  
  INSERT INTO book_checkout (book_copy_id, 
                              date_checked_out,
                              member_id,
                              librarian_id)
  VALUES(book_copy_id_p, CURDATE(), member_id_p, librarian_id_p);
  END IF;
END $$
DELIMITER ;

-- return books
DELIMITER $$
CREATE PROCEDURE return_books (book_copy_id_p INT)
clf: BEGIN
  IF (NOT EXISTS(SELECT * FROM book_copy WHERE book_copy_id = book_copy_id_p AND is_checked_out = TRUE)) THEN
    SELECT'Book is not checked out!';
    LEAVE clf;
  ELSE 
    UPDATE book_copy SET is_checked_out = FALSE WHERE book_copy_id = book_copy_id_p;
    UPDATE book_checkout SET is_returned = TRUE WHERE book_copy_id = book_copy_id_p;
  END IF;
END $$
DELIMITER ;

-- search member 
DELIMITER $$
CREATE PROCEDURE search_one_member (member_id_p INT)
BEGIN

  SELECT * FROM member WHERE member_id = member_id_p;

END $$
DELIMITER ;

--  View all late fees
DELIMITER $$
CREATE PROCEDURE view_all_late_fees ()
BEGIN

  SELECT * FROM member WHERE fine_balance > 0;

END $$
DELIMITER ;

-- View all overdue books
DELIMITER $$
CREATE PROCEDURE view_all_overdue_books ()
BEGIN

  SELECT * FROM book_copy WHERE is_checked_out IS TRUE;

END $$
DELIMITER ;

-- clear late fees
DELIMITER $$
CREATE PROCEDURE pay_late_fee (member_id_p INT, fee_amount_p DECIMAL(9,2))
clf: BEGIN
	
  IF fee_amount_p <= 0 THEN
  	SELECT 'Fee amount should be greater then 0!';
  	LEAVE clf;
  ELSEIF(NOT EXISTS(SELECT * FROM member WHERE member_id = member_id_p)) THEN
    SELECT 'Member not exists!';
  	LEAVE clf;
  END IF;

  UPDATE member 
    	SET fine_balance = fine_balance - fee_amount_p 
      WHERE member_id = member_id_p;

  
  IF (SELECT fine_balance FROM member WHERE member_id = member_id_p) < 0 THEN
  	UPDATE member SET fine_balance = 0 WHERE member_id = member_id_p;
	END IF;
  
END $$
DELIMITER ;

-- check out book
-- return book

-- late fee daily event
SET GLOBAL event_scheduler = ON;
DELIMITER $$
CREATE PROCEDURE fine_member(member_id_p INT, fine_amount_p INT)
	BEGIN
    DECLARE EXIT HANDLER FOR NOT FOUND
	
    IF NOT EXISTS (SELECT member_id FROM member WHERE member_id = member_id_p) THEN
		SELECT "Error! Could not fine member because given id was not found." AS message;
    ELSE
		UPDATE member
			SET fine_balance = fine_balance + fine_amount_p
			WHERE member_id = member_id_p;
	END IF;
	END $$
DELIMITER ;

DELIMITER $$
CREATE EVENT overdue_book_check
	ON SCHEDULE EVERY 1 HOUR
	DO BEGIN
		DECLARE max_days_past_due INT DEFAULT 45;
        DECLARE copy_id_var INT;
		DECLARE checkout_date_var DATE;
        DECLARE member_id_var INT;
        DECLARE transaction_id_var INT;
        
		DECLARE row_not_found TINYINT DEFAULT FALSE;
        
		DECLARE book_cursor CURSOR FOR
			-- find all book_copies for books that are checked out and fine has not yet been placed
			SELECT copy.book_copy_id, checkout.date_checked_out, checkout.member_id, checkout.transaction_id FROM book_copy AS copy
				NATURAL JOIN book_checkout AS checkout
				WHERE copy.is_checked_out IS TRUE AND checkout.is_fined IS FALSE AND checkout.is_returned IS FALSE;
                
		DECLARE CONTINUE HANDLER FOR NOT FOUND
			SET row_not_found = TRUE;
		
		OPEN book_cursor;
			WHILE row_not_found = FALSE DO 
			FETCH book_cursor INTO copy_id_var, checkout_date_var, member_id_var, transaction_id_var;
            IF DATEDIFF(CURDATE(), checkout_date_var) >= max_days_past_due THEN
				-- set book as fined
				UPDATE book_checkout
					SET is_fined = TRUE
					WHERE transaction_id = transaction_id_var;
				-- add fine to member balance
				CALL fine_member(member_id_var, 100);
			END IF;
		END WHILE;
        CLOSE book_cursor;
END $$
DELIMITER ;