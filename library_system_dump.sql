CREATE DATABASE  IF NOT EXISTS `library_system` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `library_system`;
-- MySQL dump 10.13  Distrib 8.0.30, for Win64 (x86_64)
--
-- Host: localhost    Database: library_system
-- ------------------------------------------------------
-- Server version	8.0.30

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `address`
--

DROP TABLE IF EXISTS `address`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `address` (
  `address_id` int NOT NULL AUTO_INCREMENT,
  `street_address` varchar(64) NOT NULL,
  `city` varchar(64) NOT NULL,
  `state` char(2) NOT NULL,
  `zip_code` char(5) NOT NULL,
  PRIMARY KEY (`address_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `address`
--

LOCK TABLES `address` WRITE;
/*!40000 ALTER TABLE `address` DISABLE KEYS */;
INSERT INTO `address` VALUES (1,'86 Main St','Boston','MA','03187'),(2,'153 Common St','Boston','MA','06853'),(3,'50 Rockland St','Boston','MA','02716');
/*!40000 ALTER TABLE `address` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `author`
--

DROP TABLE IF EXISTS `author`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `author` (
  `author_id` int NOT NULL AUTO_INCREMENT,
  `author_name` varchar(100) NOT NULL,
  `country_of_origin` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`author_id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `author`
--

LOCK TABLES `author` WRITE;
/*!40000 ALTER TABLE `author` DISABLE KEYS */;
INSERT INTO `author` VALUES (1,'William Shakespeare','England'),(2,'Charles Dickens','Portsmouth'),(3,'Agatha Christie','Devon'),(4,'Fyodor Dostoevsky','Moscow '),(5,'William Faulkner','Mississippi '),(6,'Mark Twain','Florida'),(7,'Xun Lu','China');
/*!40000 ALTER TABLE `author` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `book`
--

DROP TABLE IF EXISTS `book`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `book` (
  `isbn` char(13) NOT NULL,
  `title` varchar(64) NOT NULL,
  `year_published` char(4) NOT NULL,
  `publisher_id` int NOT NULL,
  `number_of_pages` int DEFAULT NULL,
  `genre` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`isbn`),
  KEY `book_fk_genre_type` (`genre`),
  KEY `book_fk_publisher` (`publisher_id`),
  CONSTRAINT `book_fk_genre_type` FOREIGN KEY (`genre`) REFERENCES `genre_type` (`genre`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `book_fk_publisher` FOREIGN KEY (`publisher_id`) REFERENCES `publisher` (`publisher_id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `book`
--

LOCK TABLES `book` WRITE;
/*!40000 ALTER TABLE `book` DISABLE KEYS */;
INSERT INTO `book` VALUES ('1234562401802','The apple','1997',3,120,'Legend'),('1357934643286','The boat','2019',3,56,'Humor'),('9780762401802','The Unabridged','1997',4,1289,'Legend'),('9781760890223','MONEY SCHOOL','2018',3,336,'Legend');
/*!40000 ALTER TABLE `book` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `book_author`
--

DROP TABLE IF EXISTS `book_author`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `book_author` (
  `isbn` char(13) NOT NULL,
  `author_id` int NOT NULL,
  PRIMARY KEY (`isbn`,`author_id`),
  KEY `book_author_fk_author` (`author_id`),
  CONSTRAINT `book_author_fk_author` FOREIGN KEY (`author_id`) REFERENCES `author` (`author_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `book_author_fk_book` FOREIGN KEY (`isbn`) REFERENCES `book` (`isbn`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `book_author`
--

LOCK TABLES `book_author` WRITE;
/*!40000 ALTER TABLE `book_author` DISABLE KEYS */;
INSERT INTO `book_author` VALUES ('1234562401802',2),('9781760890223',3),('1357934643286',6),('9780762401802',6);
/*!40000 ALTER TABLE `book_author` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `book_checkout`
--

DROP TABLE IF EXISTS `book_checkout`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `book_checkout` (
  `transaction_id` int NOT NULL AUTO_INCREMENT,
  `book_copy_id` int NOT NULL,
  `date_checked_out` date NOT NULL,
  `member_id` int NOT NULL,
  `librarian_id` int DEFAULT NULL,
  `is_returned` tinyint(1) DEFAULT '0',
  `is_fined` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`transaction_id`),
  KEY `book_checkout_fk_book_copy` (`book_copy_id`),
  KEY `book_checkout_fk_member` (`member_id`),
  KEY `book_checkout_fk_librarian` (`librarian_id`),
  CONSTRAINT `book_checkout_fk_book_copy` FOREIGN KEY (`book_copy_id`) REFERENCES `book_copy` (`book_copy_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `book_checkout_fk_librarian` FOREIGN KEY (`librarian_id`) REFERENCES `librarian` (`librarian_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `book_checkout_fk_member` FOREIGN KEY (`member_id`) REFERENCES `member` (`member_id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `book_checkout`
--

LOCK TABLES `book_checkout` WRITE;
/*!40000 ALTER TABLE `book_checkout` DISABLE KEYS */;
INSERT INTO `book_checkout` VALUES (1,1,'2022-12-08',2,6,0,0),(2,3,'2022-12-08',4,5,1,0),(3,5,'2022-12-08',4,3,1,0),(4,4,'2022-08-15',3,2,0,1);
/*!40000 ALTER TABLE `book_checkout` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `book_copy`
--

DROP TABLE IF EXISTS `book_copy`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `book_copy` (
  `book_copy_id` int NOT NULL AUTO_INCREMENT,
  `isbn` char(13) NOT NULL,
  `library_id` int NOT NULL,
  `is_checked_out` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`book_copy_id`),
  KEY `book_copy_fk_book` (`isbn`),
  KEY `book_copy_fk_library_branch` (`library_id`),
  CONSTRAINT `book_copy_fk_book` FOREIGN KEY (`isbn`) REFERENCES `book` (`isbn`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `book_copy_fk_library_branch` FOREIGN KEY (`library_id`) REFERENCES `library_branch` (`library_id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `book_copy`
--

LOCK TABLES `book_copy` WRITE;
/*!40000 ALTER TABLE `book_copy` DISABLE KEYS */;
INSERT INTO `book_copy` VALUES (1,'9781760890223',1,1),(2,'9781760890223',1,0),(3,'9781760890223',1,0),(4,'9781760890223',1,1),(5,'9780762401802',2,0),(6,'9780762401802',2,0),(7,'9780762401802',2,0),(8,'1234562401802',1,0),(9,'1234562401802',1,0),(10,'1357934643286',2,0),(11,'1357934643286',2,0),(12,'1357934643286',2,0),(13,'1357934643286',2,0);
/*!40000 ALTER TABLE `book_copy` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `genre_type`
--

DROP TABLE IF EXISTS `genre_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `genre_type` (
  `genre` varchar(64) NOT NULL,
  PRIMARY KEY (`genre`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `genre_type`
--

LOCK TABLES `genre_type` WRITE;
/*!40000 ALTER TABLE `genre_type` DISABLE KEYS */;
INSERT INTO `genre_type` VALUES ('Drama'),('Fantasy'),('Horror'),('Humor'),('Legend'),('Poetry');
/*!40000 ALTER TABLE `genre_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `librarian`
--

DROP TABLE IF EXISTS `librarian`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `librarian` (
  `librarian_id` int NOT NULL AUTO_INCREMENT,
  `library_id` int NOT NULL,
  `name` varchar(64) NOT NULL,
  `email` varchar(64) NOT NULL,
  `hire_date` date NOT NULL,
  `address_id` int DEFAULT NULL,
  PRIMARY KEY (`librarian_id`),
  KEY `librarian_fk_library_branch` (`library_id`),
  KEY `librarian_fk_address` (`address_id`),
  CONSTRAINT `librarian_fk_address` FOREIGN KEY (`address_id`) REFERENCES `address` (`address_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `librarian_fk_library_branch` FOREIGN KEY (`library_id`) REFERENCES `library_branch` (`library_id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `librarian`
--

LOCK TABLES `librarian` WRITE;
/*!40000 ALTER TABLE `librarian` DISABLE KEYS */;
INSERT INTO `librarian` VALUES (1,1,'Tasnim Payne','payne.t@gmail.com','2018-04-12',1),(2,1,'Rachael Joyce','joyce.r@gmail.com','2019-03-12',1),(3,2,'Rehan Gaines','gaines.r@gmail.com','2016-09-07',2),(4,2,'Maeve Jacobs','jacobs.m@gmail.com','2020-06-27',2),(5,3,'Dennis Cantu','cantu.d@gmail.com','2021-01-11',3),(6,3,'Dawn Frye','frye.d@gmail.com','2021-11-18',3),(7,3,'Saskia Craig','craig.s@gmail.com','2020-12-02',3);
/*!40000 ALTER TABLE `librarian` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `library_branch`
--

DROP TABLE IF EXISTS `library_branch`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `library_branch` (
  `library_id` int NOT NULL AUTO_INCREMENT,
  `address_id` int NOT NULL,
  `library_name` varchar(64) NOT NULL,
  PRIMARY KEY (`library_id`),
  KEY `library_branch_fk_address` (`address_id`),
  CONSTRAINT `library_branch_fk_address` FOREIGN KEY (`address_id`) REFERENCES `address` (`address_id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `library_branch`
--

LOCK TABLES `library_branch` WRITE;
/*!40000 ALTER TABLE `library_branch` DISABLE KEYS */;
INSERT INTO `library_branch` VALUES (1,1,'Snell Library'),(2,2,'Western Library'),(3,3,'Great Library');
/*!40000 ALTER TABLE `library_branch` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `member`
--

DROP TABLE IF EXISTS `member`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `member` (
  `member_id` int NOT NULL AUTO_INCREMENT,
  `email` varchar(64) NOT NULL,
  `name` varchar(64) NOT NULL,
  `registration_date` date NOT NULL,
  `fine_balance` decimal(9,2) DEFAULT '0.00',
  PRIMARY KEY (`member_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `member`
--

LOCK TABLES `member` WRITE;
/*!40000 ALTER TABLE `member` DISABLE KEYS */;
INSERT INTO `member` VALUES (1,'hubbard.l@gmail.com','Logan Hubbard','2022-12-08',0.00),(2,'mayo.e@northeastern.edu','Elias Mayo','2022-12-08',85.00),(3,'meyers.t@gmail.com','Tiago Meyers','2022-12-08',100.00),(4,'lam.mala@northeastern.edu','Malachi Lam','2022-12-08',0.00),(6,'wu.jack@gmail.com','Jack Wu','2022-12-08',0.00);
/*!40000 ALTER TABLE `member` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `publisher`
--

DROP TABLE IF EXISTS `publisher`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `publisher` (
  `publisher_id` int NOT NULL AUTO_INCREMENT,
  `publisher_name` varchar(100) NOT NULL,
  `address_id` int DEFAULT NULL,
  PRIMARY KEY (`publisher_id`),
  KEY `publisher_fk_address` (`address_id`),
  CONSTRAINT `publisher_fk_address` FOREIGN KEY (`address_id`) REFERENCES `address` (`address_id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `publisher`
--

LOCK TABLES `publisher` WRITE;
/*!40000 ALTER TABLE `publisher` DISABLE KEYS */;
INSERT INTO `publisher` VALUES (1,'Lerner Publishing Group',3),(2,'Elsevier',3),(3,'Outskirts Press',1),(4,'Baker Publishing Group',3),(5,'Sea Turtle Publishing',2);
/*!40000 ALTER TABLE `publisher` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'library_system'
--
/*!50106 SET @save_time_zone= @@TIME_ZONE */ ;
/*!50106 DROP EVENT IF EXISTS `overdue_book_check` */;
DELIMITER ;;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;;
/*!50003 SET character_set_client  = utf8mb4 */ ;;
/*!50003 SET character_set_results = utf8mb4 */ ;;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;;
/*!50003 SET @saved_time_zone      = @@time_zone */ ;;
/*!50003 SET time_zone             = 'SYSTEM' */ ;;
/*!50106 CREATE*/ /*!50117 DEFINER=`root`@`localhost`*/ /*!50106 EVENT `overdue_book_check` ON SCHEDULE EVERY 1 MINUTE STARTS '2022-12-08 12:45:34' ON COMPLETION NOT PRESERVE ENABLE DO BEGIN
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
                IF row_not_found = FALSE THEN
				CALL fine_member(member_id_var, 100);
                END IF;
			END IF;
		END WHILE;
        CLOSE book_cursor;
END */ ;;
/*!50003 SET time_zone             = @saved_time_zone */ ;;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;;
/*!50003 SET character_set_client  = @saved_cs_client */ ;;
/*!50003 SET character_set_results = @saved_cs_results */ ;;
/*!50003 SET collation_connection  = @saved_col_connection */ ;;
DELIMITER ;
/*!50106 SET TIME_ZONE= @save_time_zone */ ;

--
-- Dumping routines for database 'library_system'
--
/*!50003 DROP PROCEDURE IF EXISTS `add_book` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `add_book`(isbn_p CHAR(13), title_p VARCHAR(64), author_id_p INT, genre_p VARCHAR(64), num_pages_p INT,
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `add_member` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `add_member`(email_p VARCHAR(64), name_p VARCHAR(64))
clf:BEGIN
  IF (EXISTS(SELECT * FROM member WHERE email = email_p)) THEN
    SELECT 'Member already exists!';
    LEAVE clf;
  ELSE
    INSERT INTO member(email, name, registration_date) VALUES(email_p, name_p, CURDATE());
    SELECT CONCAT("Member added! Their new Member ID is: ", 
      (SELECT member_id FROM member WHERE email = email_p AND name = name_p));
  END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `check_out_books` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `check_out_books`(book_copy_id_p INT, member_id_p INT, librarian_id_p INT)
clf:BEGIN
  IF(EXISTS(SELECT * FROM book_copy WHERE book_copy_id = book_copy_id_p AND is_checked_out = TRUE)) THEN
    SELECT'Book is already checked out!';
    LEAVE clf;
  ELSEIF(NOT EXISTS(SELECT * FROM book_copy WHERE book_copy_id = book_copy_id_p)) THEN
    SELECT'Book copy does not exist!';
    LEAVE clf;
  ELSEIF(NOT EXISTS(SELECT * FROM member WHERE member_id = member_id_p)) THEN
    SELECT'Member does not exist!';
    LEAVE clf;
  ELSEIF(NOT EXISTS(SELECT * FROM librarian WHERE librarian_id = librarian_id_p)) THEN
    SELECT'Librarian does not exist!';
    LEAVE clf;
  ELSE 
	UPDATE book_copy SET is_checked_out = TRUE WHERE book_copy_id = book_copy_id_p;
  
	INSERT INTO book_checkout (book_copy_id, 
                              date_checked_out,
                              member_id,
                              librarian_id)
  VALUES(book_copy_id_p, CURDATE(), member_id_p, librarian_id_p);
	SELECT "Successfully checked out book!";
  END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `fine_member` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `fine_member`(member_id_p INT, fine_amount_p INT)
clf:BEGIN
	
    IF NOT EXISTS (SELECT member_id FROM member WHERE member_id = member_id_p) THEN
		SELECT "Error! Could not fine member because given id was not found." AS message;
        LEAVE clf;
    ELSE
		UPDATE member
			SET fine_balance = fine_balance + fine_amount_p
			WHERE member_id = member_id_p;
	END IF;
	END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `pay_late_fee` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `pay_late_fee`(member_id_p INT, fee_amount_p DECIMAL(9,2))
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
  
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `remove_member` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `remove_member`(member_id_p INT)
clf:BEGIN
  IF(NOT EXISTS(SELECT * FROM member WHERE member_id = member_id_p)) THEN
    SELECT 'Member does not exist!';
    LEAVE clf;
  ELSEIF(EXISTS(SELECT * FROM book_checkout WHERE member_id = member_id_p)) THEN
    SELECT 'Member has checked out books and cannot be deleted.';
    LEAVE clf;
  ELSE
    DELETE FROM member WHERE member_id = member_id_p;
    SELECT 'Member successfully deleted';
  END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `return_books` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `return_books`(book_copy_id_p INT)
clf: BEGIN
  IF (NOT EXISTS(SELECT * FROM book_copy WHERE book_copy_id = book_copy_id_p AND is_checked_out = TRUE)) THEN
    SELECT "Book with ID you entered is not checked out!";
    LEAVE clf;
  ELSE 
    UPDATE book_copy SET is_checked_out = FALSE WHERE book_copy_id = book_copy_id_p;
    UPDATE book_checkout SET is_returned = TRUE WHERE book_copy_id = book_copy_id_p;

    SELECT "Book successfully returned!";
  END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `search_books` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `search_books`(search_type_p VARCHAR(64), search_content VARCHAR(64))
BEGIN
	IF search_type_p = 'title' THEN
	SELECT book.title, GROUP_CONCAT(author_name) AS authors, genre, book.isbn, book_copy_id, publisher_name, year_published,
			 library_name, is_checked_out
		FROM book_copy 
		NATURAL JOIN book
		INNER JOIN library_branch ON book_copy.library_id = library_branch.library_id
		INNER JOIN book_author ON book.isbn = book_author.isbn
		INNER JOIN author ON book_author.author_id = author.author_id
		INNER JOIN publisher ON book.publisher_id = publisher.publisher_id
		GROUP BY isbn, genre, publisher_name, year_published, book.isbn, book.title, is_checked_out, library_name, book_copy_id
		HAVING isbn IN (SELECT isbn FROM book WHERE title = search_content);
  ELSEIF search_type_p = 'author' THEN
  	SELECT book.title, GROUP_CONCAT(author_name) AS authors, genre, book.isbn, book_copy_id, publisher_name, year_published,
			 library_name, is_checked_out
		FROM book_copy 
		NATURAL JOIN book
		INNER JOIN library_branch ON book_copy.library_id = library_branch.library_id
		INNER JOIN book_author ON book.isbn = book_author.isbn
		INNER JOIN author ON book_author.author_id = author.author_id
		INNER JOIN publisher ON book.publisher_id = publisher.publisher_id
		GROUP BY isbn, genre, publisher_name, year_published, book.isbn, book.title, is_checked_out, library_name, book_copy_id
		HAVING isbn IN 
			(SELECT isbn FROM book_author WHERE author_id IN 
			 (SELECT author_id FROM author WHERE author_name = search_content));
  ELSEIF search_type_p = 'isbn' THEN
  	SELECT book.title, GROUP_CONCAT(author_name) AS authors, genre, book.isbn, book_copy_id, publisher_name, year_published,
		 library_name, is_checked_out
	FROM book_copy 
    NATURAL JOIN book
    INNER JOIN library_branch ON book_copy.library_id = library_branch.library_id
    INNER JOIN book_author ON book.isbn = book_author.isbn
    INNER JOIN author ON book_author.author_id = author.author_id
    INNER JOIN publisher ON book.publisher_id = publisher.publisher_id
    GROUP BY isbn, genre, publisher_name, year_published, book.isbn, book.title, is_checked_out, library_name, book_copy_id
    HAVING isbn = search_content;
  ELSE 
    SELECT 'Wrong Input! Please check and input again';
  END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `search_one_member` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `search_one_member`(member_id_p INT)
BEGIN

  SELECT * FROM member WHERE member_id = member_id_p;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `update_email` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `update_email`(member_id_p INT, email_p VARCHAR(64))
clf:BEGIN
  IF(NOT EXISTS(SELECT * FROM member WHERE member_id = member_id_p)) THEN
    SELECT 'Member does not exist!';
    LEAVE clf;
  ELSE
    UPDATE member SET email = email_p WHERE member_id = member_id_p;
    SELECT "Member's email updated successfully";
  END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `view_all_late_fees` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `view_all_late_fees`()
BEGIN

  SELECT * FROM member WHERE fine_balance > 0;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `view_all_overdue_books` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `view_all_overdue_books`()
BEGIN

  SELECT book_copy.book_copy_id, title, book.isbn, member.name, member.member_id, date_checked_out, is_fined, (DATEDIFF(CURDATE(), date_checked_out) - 44) AS days_late

  FROM book_copy

    INNER JOIN book ON book_copy.isbn = book.isbn

    INNER JOIN book_checkout ON book_copy.book_copy_id = book_checkout.book_copy_id

    INNER JOIN member ON member.member_id = book_checkout.member_id

  WHERE book_checkout.is_returned IS FALSE AND is_fined IS TRUE;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2022-12-08 13:15:28
