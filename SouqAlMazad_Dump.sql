-- MySQL dump 10.13  Distrib 8.0.19, for Win64 (x86_64)
--
-- Host: localhost    Database: souqalmazad
-- ------------------------------------------------------
-- Server version	8.0.45

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `admin`
--

DROP TABLE IF EXISTS `admin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `admin` (
  `admin_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `role` enum('super_admin','moderator','support') NOT NULL,
  `permissions` text,
  PRIMARY KEY (`admin_id`),
  UNIQUE KEY `user_id` (`user_id`),
  CONSTRAINT `admin_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admin`
--

LOCK TABLES `admin` WRITE;
/*!40000 ALTER TABLE `admin` DISABLE KEYS */;
INSERT INTO `admin` VALUES (1,5,'super_admin','all');
/*!40000 ALTER TABLE `admin` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auction`
--

DROP TABLE IF EXISTS `auction`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auction` (
  `auction_id` int NOT NULL AUTO_INCREMENT,
  `product_id` int NOT NULL,
  `starting_price` decimal(12,2) NOT NULL,
  `reserve_price` decimal(12,2) DEFAULT NULL,
  `current_highest` decimal(12,2) DEFAULT '0.00',
  `start_time` datetime NOT NULL,
  `end_time` datetime NOT NULL,
  `status` enum('upcoming','active','ended','cancelled') DEFAULT 'upcoming',
  `winner_buyer_id` int DEFAULT NULL,
  PRIMARY KEY (`auction_id`),
  KEY `product_id` (`product_id`),
  KEY `winner_buyer_id` (`winner_buyer_id`),
  KEY `idx_auction_status` (`status`),
  CONSTRAINT `auction_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `product` (`product_id`) ON DELETE CASCADE,
  CONSTRAINT `auction_ibfk_2` FOREIGN KEY (`winner_buyer_id`) REFERENCES `buyer` (`buyer_id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auction`
--

LOCK TABLES `auction` WRITE;
/*!40000 ALTER TABLE `auction` DISABLE KEYS */;
INSERT INTO `auction` VALUES (1,2,3000.00,3500.00,10.00,'2026-03-20 10:00:00','2026-04-05 22:00:00','cancelled',NULL),(2,5,300.00,400.00,450.00,'2026-03-25 08:00:00','2026-04-10 20:00:00','ended',NULL),(3,6,4000.00,4800.00,3000.00,'2026-04-01 10:00:00','2026-04-15 22:00:00','ended',3),(4,1,50000.00,1000000.00,1500000.00,'2026-05-08 20:00:00','2026-05-09 20:00:00','ended',1),(5,21,10.00,1000000.00,1000000000.00,'2026-05-10 22:29:04','2026-05-10 23:29:04','ended',6),(6,23,10.00,1000.00,1000000.00,'2026-05-10 22:39:00','2026-05-10 22:41:00','ended',1),(7,28,10.00,900.00,10000.00,'2026-05-12 00:17:33','2026-05-12 01:17:33','ended',6),(8,29,800.00,2450.00,0.00,'2026-05-12 13:05:00','2026-05-13 00:00:00','upcoming',NULL),(9,30,1000.00,4500.00,0.00,'2026-05-12 13:06:00','2026-05-12 23:30:00','upcoming',NULL),(10,33,100.00,500.00,1000000.00,'2026-05-12 10:32:59','2026-05-12 11:32:59','active',6);
/*!40000 ALTER TABLE `auction` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bid`
--

DROP TABLE IF EXISTS `bid`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bid` (
  `bid_id` int NOT NULL AUTO_INCREMENT,
  `auction_id` int NOT NULL,
  `buyer_id` int NOT NULL,
  `bid_amount` decimal(12,2) NOT NULL,
  `bid_time` datetime DEFAULT CURRENT_TIMESTAMP,
  `is_winning` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`bid_id`),
  KEY `buyer_id` (`buyer_id`),
  KEY `idx_bid_auction` (`auction_id`),
  CONSTRAINT `bid_ibfk_1` FOREIGN KEY (`auction_id`) REFERENCES `auction` (`auction_id`) ON DELETE CASCADE,
  CONSTRAINT `bid_ibfk_2` FOREIGN KEY (`buyer_id`) REFERENCES `buyer` (`buyer_id`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bid`
--

LOCK TABLES `bid` WRITE;
/*!40000 ALTER TABLE `bid` DISABLE KEYS */;
INSERT INTO `bid` VALUES (1,1,1,3200.00,'2026-03-21 14:30:00',0),(2,1,2,3600.00,'2026-03-22 09:15:00',0),(3,2,1,350.00,'2026-03-26 11:00:00',0),(4,2,2,450.00,'2026-03-27 16:45:00',1),(8,1,1,220.00,'2026-05-08 13:46:14',0),(12,1,1,10.00,'2026-05-08 14:13:23',1),(13,3,1,10.00,'2026-05-08 14:13:35',0),(14,3,3,3000.00,'2026-05-08 15:00:52',1),(15,4,1,50000.00,'2026-05-08 23:20:24',0),(16,4,1,1500000.00,'2026-05-08 23:20:42',1),(17,5,1,1000000.00,'2026-05-10 22:31:45',0),(18,5,6,1000000000.00,'2026-05-10 22:34:02',1),(19,6,6,10000.00,'2026-05-10 22:40:09',0),(20,6,1,1000000.00,'2026-05-10 22:40:45',1),(21,7,1,900.00,'2026-05-12 00:18:27',0),(22,7,6,10000.00,'2026-05-12 00:19:41',1),(23,10,1,900.00,'2026-05-12 10:34:40',0),(24,10,6,900000.00,'2026-05-12 10:38:19',0),(25,10,6,1000000.00,'2026-05-12 11:07:11',1);
/*!40000 ALTER TABLE `bid` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `buyer`
--

DROP TABLE IF EXISTS `buyer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `buyer` (
  `buyer_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `loyalty_points` int DEFAULT '0',
  `date_of_birth` date DEFAULT NULL,
  `gender` enum('male','female','other') DEFAULT NULL,
  PRIMARY KEY (`buyer_id`),
  UNIQUE KEY `user_id` (`user_id`),
  CONSTRAINT `buyer_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `buyer`
--

LOCK TABLES `buyer` WRITE;
/*!40000 ALTER TABLE `buyer` DISABLE KEYS */;
INSERT INTO `buyer` VALUES (1,2,150,'1999-03-15','female'),(2,3,80,'2001-07-20','male'),(3,14,0,NULL,NULL),(4,17,0,NULL,NULL),(5,18,0,NULL,NULL),(6,21,0,NULL,NULL);
/*!40000 ALTER TABLE `buyer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `category`
--

DROP TABLE IF EXISTS `category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `category` (
  `category_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `icon_url` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`category_id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `category`
--

LOCK TABLES `category` WRITE;
/*!40000 ALTER TABLE `category` DISABLE KEYS */;
INSERT INTO `category` VALUES (1,'Electronics','Phones, laptops, accessories',NULL),(2,'Fashion','Clothing, shoes, bags,lara',NULL),(3,'Home','Furniture, kitchen, decoration',NULL),(4,'Sports','Equipment, clothing, accessories',NULL),(7,'rare','r',NULL);
/*!40000 ALTER TABLE `category` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notification`
--

DROP TABLE IF EXISTS `notification`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notification` (
  `notification_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `type` enum('outbid','auction_won','order_update','new_message','promotion','system') NOT NULL,
  `title` varchar(100) NOT NULL,
  `content` text,
  `is_read` tinyint(1) DEFAULT '0',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`notification_id`),
  KEY `idx_notification_user` (`user_id`),
  CONSTRAINT `notification_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=81 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notification`
--

LOCK TABLES `notification` WRITE;
/*!40000 ALTER TABLE `notification` DISABLE KEYS */;
INSERT INTO `notification` VALUES (1,2,'outbid','You have been outbid!','Someone placed a higher bid on Samsung Galaxy S24.',1,'2026-05-07 13:07:16'),(2,3,'auction_won','Congratulations!','You won the auction for Running Shoes Nike!',1,'2026-05-07 13:07:16'),(3,2,'order_update','Order Shipped','Your order #2 has been shipped via DHL.',1,'2026-05-07 13:07:16'),(4,1,'promotion','New Deals!','Check out the latest deals on TechZone store.',0,'2026-05-07 13:07:16'),(5,1,'auction_won','wonnnnn','شكرا',1,'2026-05-08 22:51:54'),(6,2,'order_update','Order created','Order #9 was created for lara.',1,'2026-05-09 17:17:41'),(7,2,'system','Report status updated','Your report #1 is now reviewed.',1,'2026-05-10 19:53:38'),(8,2,'system','Report status updated','Your report #1 is now resolved.',1,'2026-05-10 19:53:44'),(9,2,'order_update','Order created','Order #10 was created for AirPods Pro 2.',1,'2026-05-10 19:59:39'),(10,2,'order_update','Order Placed!','Your order #10 has been placed.',1,'2026-05-10 19:59:39'),(11,2,'order_update','Order status updated','Order #10 is now confirmed.',1,'2026-05-10 20:00:25'),(13,2,'order_update','Payment status updated','Payment for order #10 is now completed.',1,'2026-05-10 20:16:46'),(14,2,'order_update','Shipment status updated','Shipment for order #7 is now shipped.',1,'2026-05-10 20:17:01'),(15,2,'order_update','Order status updated','Order #7 is now shipped.',1,'2026-05-10 20:17:01'),(16,2,'order_update','Payment status updated','Payment for order #7 is now failed.',1,'2026-05-10 20:17:12'),(17,2,'order_update','Order status updated','Order #7 is now pending.',1,'2026-05-10 20:17:17'),(18,2,'order_update','Payment status updated','Payment for order #7 is now refunded.',1,'2026-05-10 20:17:43'),(19,2,'order_update','Order status updated','Order #7 is now pending.',1,'2026-05-10 20:17:46'),(20,2,'order_update','Payment status updated','Payment for order #1 is now failed.',1,'2026-05-10 20:18:15'),(21,2,'order_update','Order status updated','Order #1 is now pending.',1,'2026-05-10 20:18:18'),(22,2,'order_update','Order status updated','Order #1 is now pending.',1,'2026-05-10 20:18:28'),(23,2,'order_update','Shipment status updated','Shipment for order #1 is now returned.',1,'2026-05-10 20:18:38'),(24,2,'order_update','Order status updated','Order #1 is now returned.',1,'2026-05-10 20:18:38'),(26,2,'outbid','You were outbid','A higher bid was placed on auction #5.',1,'2026-05-10 22:34:02'),(27,21,'system','Bid placed','Your bid of $1,000,000,000.00 was placed on auction #5.',0,'2026-05-10 22:34:02'),(28,21,'order_update','Order created','Order #11 was created for rerfdf.',1,'2026-05-10 22:34:55'),(29,21,'order_update','Order Placed!','Your order #11 has been placed.',1,'2026-05-10 22:34:55'),(30,21,'system','Bid placed','Your bid of $10,000.00 was placed on auction #6.',1,'2026-05-10 22:40:09'),(31,21,'outbid','You were outbid','A higher bid was placed on auction #6.',1,'2026-05-10 22:40:45'),(32,2,'system','Bid placed','Your bid of $1,000,000.00 was placed on auction #6.',1,'2026-05-10 22:40:45'),(33,2,'promotion','hiiiiiii','nothing',1,'2026-05-12 00:11:14'),(34,2,'system','Bid placed','Your bid of $900.00 was placed on auction #7.',1,'2026-05-12 00:18:27'),(35,2,'outbid','You were outbid','A higher bid was placed on auction #7.',1,'2026-05-12 00:19:41'),(36,21,'system','Bid placed','Your bid of $10,000.00 was placed on auction #7.',1,'2026-05-12 00:19:41'),(37,2,'system','Report status updated','Your report #1 is now dismissed.',1,'2026-05-12 00:56:38'),(50,2,'system','Bid placed','Your bid of $900.00 was placed on auction #10.',1,'2026-05-12 10:34:40'),(57,2,'outbid','You were outbid','A higher bid was placed on auction #10.',1,'2026-05-12 10:38:19'),(58,21,'system','Bid placed','Your bid of $900,000.00 was placed on auction #10.',0,'2026-05-12 10:38:19'),(67,2,'system','Report status updated','Your report #1 is now resolved.',0,'2026-05-12 10:51:08'),(68,5,'system','sorry','',0,'2026-05-12 10:52:04'),(69,21,'promotion','disc','',0,'2026-05-12 10:52:46'),(76,21,'system','Bid placed','Your bid of $1,000,000.00 was placed on auction #10.',0,'2026-05-12 11:07:12');
/*!40000 ALTER TABLE `notification` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order`
--

DROP TABLE IF EXISTS `order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order` (
  `order_id` int NOT NULL AUTO_INCREMENT,
  `buyer_id` int NOT NULL,
  `order_type` enum('direct','auction_win') NOT NULL DEFAULT 'direct',
  `shipping_address` varchar(255) NOT NULL,
  `total_amount` decimal(12,2) NOT NULL,
  `discount_amount` decimal(12,2) DEFAULT '0.00',
  `final_amount` decimal(12,2) NOT NULL,
  `status` enum('pending','confirmed','processing','shipped','delivered','cancelled','returned') DEFAULT 'pending',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`order_id`),
  KEY `idx_order_buyer` (`buyer_id`),
  KEY `idx_order_status` (`status`),
  CONSTRAINT `order_ibfk_1` FOREIGN KEY (`buyer_id`) REFERENCES `buyer` (`buyer_id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order`
--

LOCK TABLES `order` WRITE;
/*!40000 ALTER TABLE `order` DISABLE KEYS */;
INSERT INTO `order` VALUES (1,1,'direct','Nablus, Palestine - Main Street 15',4500.00,0.00,4500.00,'returned','2026-05-07 13:07:16','2026-05-10 20:18:38'),(3,2,'direct','Ramallah, Palestine - Center 22',350.00,0.00,350.00,'processing','2026-05-07 13:07:16','2026-05-08 22:46:20'),(4,2,'direct','nablus',520.00,0.00,520.00,'pending','2026-05-08 23:35:12','2026-05-08 23:35:12'),(5,1,'direct','nablus',350.00,0.00,350.00,'pending','2026-05-08 23:38:11','2026-05-08 23:38:11'),(6,1,'direct','nablus',580.00,0.00,580.00,'pending','2026-05-08 23:38:32','2026-05-08 23:38:32'),(7,1,'direct','nablus',580.00,0.00,580.00,'pending','2026-05-08 23:38:38','2026-05-10 20:17:17'),(8,1,'direct','klhlkhkh',520.00,0.00,520.00,'pending','2026-05-09 00:04:28','2026-05-09 00:04:28'),(9,1,'direct','nab',52880.00,0.00,52880.00,'pending','2026-05-09 17:17:41','2026-05-09 17:17:41'),(10,1,'direct','lara',950.00,0.00,950.00,'confirmed','2026-05-10 19:59:39','2026-05-10 20:00:25');
/*!40000 ALTER TABLE `order` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_item`
--

DROP TABLE IF EXISTS `order_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_item` (
  `order_item_id` int NOT NULL AUTO_INCREMENT,
  `order_id` int NOT NULL,
  `product_id` int NOT NULL,
  `store_id` int NOT NULL,
  `quantity` int NOT NULL DEFAULT '1',
  `unit_price` decimal(12,2) NOT NULL,
  `subtotal` decimal(12,2) NOT NULL,
  PRIMARY KEY (`order_item_id`),
  KEY `order_id` (`order_id`),
  KEY `product_id` (`product_id`),
  KEY `store_id` (`store_id`),
  CONSTRAINT `order_item_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `order` (`order_id`) ON DELETE CASCADE,
  CONSTRAINT `order_item_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `product` (`product_id`),
  CONSTRAINT `order_item_ibfk_3` FOREIGN KEY (`store_id`) REFERENCES `store` (`store_id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_item`
--

LOCK TABLES `order_item` WRITE;
/*!40000 ALTER TABLE `order_item` DISABLE KEYS */;
INSERT INTO `order_item` VALUES (1,1,1,1,1,4500.00,4500.00),(3,3,4,2,1,350.00,350.00),(4,4,12,1,1,520.00,520.00),(5,5,4,2,1,350.00,350.00),(6,6,11,1,1,580.00,580.00),(7,7,11,1,1,580.00,580.00),(8,8,12,1,1,520.00,520.00),(9,9,10,1,1,52880.00,52880.00),(10,10,3,1,1,950.00,950.00);
/*!40000 ALTER TABLE `order_item` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payment`
--

DROP TABLE IF EXISTS `payment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `payment` (
  `payment_id` int NOT NULL AUTO_INCREMENT,
  `order_id` int NOT NULL,
  `payment_method` enum('credit_card','paypal','cash_on_delivery') NOT NULL,
  `amount` decimal(12,2) NOT NULL,
  `status` enum('pending','completed','failed','refunded') DEFAULT 'pending',
  `transaction_ref` varchar(100) DEFAULT NULL,
  `paid_at` datetime DEFAULT NULL,
  PRIMARY KEY (`payment_id`),
  KEY `order_id` (`order_id`),
  CONSTRAINT `payment_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `order` (`order_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payment`
--

LOCK TABLES `payment` WRITE;
/*!40000 ALTER TABLE `payment` DISABLE KEYS */;
INSERT INTO `payment` VALUES (1,1,'credit_card',4500.00,'failed','TXN001','2026-03-15 10:30:00'),(3,3,'cash_on_delivery',350.00,'pending',NULL,NULL),(4,4,'cash_on_delivery',520.00,'pending',NULL,NULL),(5,5,'cash_on_delivery',350.00,'pending',NULL,NULL),(6,6,'cash_on_delivery',580.00,'pending',NULL,NULL),(7,7,'cash_on_delivery',580.00,'refunded',NULL,NULL),(8,8,'cash_on_delivery',520.00,'pending',NULL,NULL),(9,9,'cash_on_delivery',52880.00,'pending',NULL,NULL),(10,10,'paypal',950.00,'completed',NULL,'2026-05-10 20:16:37');
/*!40000 ALTER TABLE `payment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product`
--

DROP TABLE IF EXISTS `product`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product` (
  `product_id` int NOT NULL AUTO_INCREMENT,
  `store_id` int NOT NULL,
  `category_id` int NOT NULL,
  `title` varchar(150) NOT NULL,
  `description` text,
  `price` decimal(12,2) NOT NULL,
  `stock_quantity` int DEFAULT '1',
  `sale_type` enum('direct','auction','both') NOT NULL DEFAULT 'direct',
  `item_condition` enum('new','used','refurbished') DEFAULT 'new',
  `is_active` tinyint(1) DEFAULT '1',
  `view_count` int DEFAULT '0',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`product_id`),
  KEY `idx_product_store` (`store_id`),
  KEY `idx_product_category` (`category_id`),
  CONSTRAINT `product_ibfk_1` FOREIGN KEY (`store_id`) REFERENCES `store` (`store_id`) ON DELETE CASCADE,
  CONSTRAINT `product_ibfk_2` FOREIGN KEY (`category_id`) REFERENCES `category` (`category_id`)
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product`
--

LOCK TABLES `product` WRITE;
/*!40000 ALTER TABLE `product` DISABLE KEYS */;
INSERT INTO `product` VALUES (1,1,1,'lamp','',60.00,3,'auction','new',0,0,'2026-05-07 13:07:16','2026-05-11 21:54:43'),(2,1,1,'Samsung Galaxy S24','Samsung Galaxy S24 Ultra 512GB',3800.00,3,'both','new',0,0,'2026-05-07 13:07:16','2026-05-08 14:51:51'),(3,1,1,'AirPods Pro 2','Apple AirPods Pro 2nd gen',950.00,9,'direct','new',0,0,'2026-05-07 13:07:16','2026-05-10 21:28:30'),(4,2,2,'Leather Jacket','Premium leather jacket black',350.00,7,'direct','new',1,0,'2026-05-07 13:07:16','2026-05-08 23:38:11'),(5,2,2,'Running Shoes Nike','Nike Air Max 2024',500.00,15,'auction','new',0,0,'2026-05-07 13:07:16','2026-05-08 14:39:26'),(6,1,1,'MacBook Air M3','Apple MacBook Air 15 inch M3',5200.00,2,'auction','new',0,0,'2026-05-07 13:07:16','2026-05-10 21:28:26'),(8,2,2,'Leather Jacket','Premium leather jacket',355550.00,9,'direct','used',1,0,'2026-05-08 14:40:02','2026-05-08 15:20:58'),(9,2,2,'Leather Jacket','Premium leather jacket black2222',350.00,8,'direct','used',0,0,'2026-05-08 14:40:19','2026-05-08 14:54:03'),(10,1,1,'lara','Apple MacBook Air 15 inch M3',52880.00,1,'direct','used',0,0,'2026-05-08 14:41:13','2026-05-10 21:28:22'),(11,1,1,'lara','Apple MacBook Air 15 inch M3',580.00,0,'direct','used',0,0,'2026-05-08 15:31:24','2026-05-10 21:28:18'),(12,1,1,'lara','Apple MacBook Air 15 inch M3',520.00,0,'direct','used',0,0,'2026-05-08 22:43:25','2026-05-10 21:28:15'),(14,1,1,'dhjkjhdf','fee',12.00,10,'direct','new',0,0,'2026-05-10 20:02:05','2026-05-10 21:28:12'),(15,1,1,'lamp','ewfeeweweww',20.00,30,'both','used',0,0,'2026-05-10 21:05:25','2026-05-10 21:28:08'),(16,1,1,'فرح','',10000000.00,1,'auction','new',0,0,'2026-05-10 21:29:42','2026-05-12 00:39:45'),(17,1,1,'لمبة','لمبة فش اشي كرييتف',10.00,600,'direct','used',0,0,'2026-05-10 21:30:27','2026-05-12 00:10:01'),(18,1,1,'الة العودة بالزمن','محد بده يرجع',60.00,80,'direct','new',0,0,'2026-05-10 21:31:39','2026-05-12 00:10:05'),(19,1,1,'rerfdf','',222.00,1,'both','new',0,0,'2026-05-10 21:50:03','2026-05-12 00:55:57'),(21,1,1,'فرح مرة ثانية','',10000000.00,1,'both','new',0,0,'2026-05-10 22:29:20','2026-05-12 00:09:53'),(23,1,1,'new','',1000.00,1,'auction','new',0,0,'2026-05-10 22:39:28','2026-05-12 00:10:08'),(24,2,3,'lamp','',5.00,5,'direct','new',1,0,'2026-05-11 21:55:47','2026-05-11 21:55:47'),(25,9,3,'fdgd','',22.00,4,'direct','new',1,0,'2026-05-11 21:56:33','2026-05-11 21:56:33'),(28,1,1,'try','jjjj',900.00,1,'auction','new',0,0,'2026-05-12 00:17:35','2026-05-12 00:39:42'),(29,1,2,'Hand-Embroidered Palestinian Thobe – Heritage Edition','',2000.00,3,'auction','new',1,0,'2026-05-12 00:43:35','2026-05-12 00:43:35'),(30,10,7,'1967 Palestinian Coin Collection','',2500.00,1,'auction','new',1,0,'2026-05-12 00:46:53','2026-05-12 00:46:53'),(31,1,1,'iPhone 18 Pro Max','',1800.00,12,'direct','new',1,0,'2026-05-12 00:48:32','2026-05-12 00:48:32'),(32,1,7,'yrt','',300.00,1,'auction','new',1,0,'2026-05-12 10:31:33','2026-05-12 10:31:57'),(33,1,7,'tgggg','',20.00,2,'auction','new',1,0,'2026-05-12 10:33:05','2026-05-12 10:33:05'),(34,1,7,'ddddd','',100.00,1,'direct','new',1,0,'2026-05-12 11:04:46','2026-05-12 11:04:46');
/*!40000 ALTER TABLE `product` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_image`
--

DROP TABLE IF EXISTS `product_image`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_image` (
  `image_id` int NOT NULL AUTO_INCREMENT,
  `product_id` int NOT NULL,
  `image_url` varchar(255) NOT NULL,
  `is_primary` tinyint(1) DEFAULT '0',
  `display_order` int DEFAULT '0',
  PRIMARY KEY (`image_id`),
  KEY `product_id` (`product_id`),
  CONSTRAINT `product_image_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `product` (`product_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=38 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_image`
--

LOCK TABLES `product_image` WRITE;
/*!40000 ALTER TABLE `product_image` DISABLE KEYS */;
INSERT INTO `product_image` VALUES (1,1,'images/iphone15_1.jpg',1,1),(2,1,'images/iphone15_2.jpg',0,2),(3,2,'images/galaxy24_1.jpg',1,1),(4,3,'images/airpods_1.jpg',1,1),(5,4,'images/jacket_1.jpg',1,1),(6,5,'images/nike_1.jpg',1,1),(7,6,'images/macbook_1.jpg',1,1),(8,11,'product_images/11.png',0,0),(9,11,'product_images/11.jpeg',1,0),(10,10,'product_images/10.jpg',0,0),(11,10,'product_images/10.jpg',0,0),(12,10,'product_images/10.jpg',0,0),(13,12,'product_images/12.jpg',0,0),(14,12,'product_images/12.png',0,0),(15,12,'product_images/12.jpg',0,0),(16,10,'product_images/10.jpg',1,0),(17,12,'product_images/12.jpg',0,0),(18,12,'product_images/12.png',1,0),(19,14,'product_images/14.png',0,0),(20,14,'product_images/14.png',0,0),(21,15,'product_images/15.jpg',0,0),(22,15,'product_images/15.png',1,0),(23,14,'product_images/14.jpg',1,0),(24,16,'product_images/16.jpg',0,0),(25,17,'product_images/17.jpeg',1,0),(26,18,'product_images/18.jpeg',1,0),(27,16,'product_images/16.jpg',1,0),(28,21,'product_images/21.jpg',1,0),(29,25,'product_images/25.jpeg',1,0),(30,31,'product_images/31.png',0,0),(31,29,'product_images/29.png',0,0),(32,30,'product_images/30.png',0,0),(33,29,'product_images/29.png',0,0),(34,31,'product_images/31.png',0,0),(35,31,'product_images/31.png',1,0),(36,30,'product_images/30.png',1,0),(37,29,'product_images/29.png',1,0);
/*!40000 ALTER TABLE `product_image` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `report`
--

DROP TABLE IF EXISTS `report`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `report` (
  `report_id` int NOT NULL AUTO_INCREMENT,
  `reporter_id` int NOT NULL,
  `reported_type` enum('product','store','user') NOT NULL,
  `reported_id` int NOT NULL,
  `reason` enum('fake_product','scam','inappropriate','harassment','other') NOT NULL,
  `description` text,
  `status` enum('pending','reviewed','resolved','dismissed') DEFAULT 'pending',
  `admin_id` int DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `resolved_at` datetime DEFAULT NULL,
  PRIMARY KEY (`report_id`),
  KEY `reporter_id` (`reporter_id`),
  KEY `admin_id` (`admin_id`),
  CONSTRAINT `report_ibfk_1` FOREIGN KEY (`reporter_id`) REFERENCES `user` (`user_id`),
  CONSTRAINT `report_ibfk_2` FOREIGN KEY (`admin_id`) REFERENCES `admin` (`admin_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `report`
--

LOCK TABLES `report` WRITE;
/*!40000 ALTER TABLE `report` DISABLE KEYS */;
INSERT INTO `report` VALUES (1,2,'product',6,'fake_product','This MacBook listing looks suspicious.','resolved',1,'2026-05-07 13:07:16','2026-05-12 10:51:08');
/*!40000 ALTER TABLE `report` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `review`
--

DROP TABLE IF EXISTS `review`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `review` (
  `review_id` int NOT NULL AUTO_INCREMENT,
  `product_id` int NOT NULL,
  `buyer_id` int NOT NULL,
  `order_id` int NOT NULL,
  `rating` tinyint NOT NULL,
  `comment` text,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`review_id`),
  KEY `buyer_id` (`buyer_id`),
  KEY `order_id` (`order_id`),
  KEY `idx_review_product` (`product_id`),
  CONSTRAINT `review_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `product` (`product_id`) ON DELETE CASCADE,
  CONSTRAINT `review_ibfk_2` FOREIGN KEY (`buyer_id`) REFERENCES `buyer` (`buyer_id`),
  CONSTRAINT `review_ibfk_3` FOREIGN KEY (`order_id`) REFERENCES `order` (`order_id`),
  CONSTRAINT `review_chk_1` CHECK ((`rating` between 1 and 5))
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `review`
--

LOCK TABLES `review` WRITE;
/*!40000 ALTER TABLE `review` DISABLE KEYS */;
INSERT INTO `review` VALUES (1,1,1,1,5,'Excellent phone! Fast delivery.','2026-05-07 13:07:16'),(2,4,2,3,4,'Nice jacket, good quality.','2026-05-07 13:07:16');
/*!40000 ALTER TABLE `review` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `seller`
--

DROP TABLE IF EXISTS `seller`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `seller` (
  `seller_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `business_name` varchar(100) DEFAULT NULL,
  `national_id` varchar(20) DEFAULT NULL,
  `is_verified` tinyint(1) DEFAULT '0',
  `commission_rate` decimal(4,2) DEFAULT '5.00',
  `joined_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`seller_id`),
  UNIQUE KEY `user_id` (`user_id`),
  CONSTRAINT `seller_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `seller`
--

LOCK TABLES `seller` WRITE;
/*!40000 ALTER TABLE `seller` DISABLE KEYS */;
INSERT INTO `seller` VALUES (1,1,'Ahmad Electronics','1234567890',1,5.00,'2026-05-07 13:07:16'),(2,4,'Lina Fashion','0987654321',1,4.50,'2026-05-07 13:07:16'),(3,15,'lara Store',NULL,0,5.00,'2026-05-10 19:43:01'),(4,22,'LAILA Store',NULL,0,5.00,'2026-05-11 21:53:51');
/*!40000 ALTER TABLE `seller` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `shipment`
--

DROP TABLE IF EXISTS `shipment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `shipment` (
  `shipment_id` int NOT NULL AUTO_INCREMENT,
  `order_id` int NOT NULL,
  `carrier_name` varchar(50) DEFAULT NULL,
  `tracking_number` varchar(100) DEFAULT NULL,
  `status` enum('preparing','shipped','in_transit','delivered','returned') DEFAULT 'preparing',
  `estimated_delivery` date DEFAULT NULL,
  `actual_delivery` date DEFAULT NULL,
  `shipped_at` datetime DEFAULT NULL,
  PRIMARY KEY (`shipment_id`),
  KEY `order_id` (`order_id`),
  CONSTRAINT `shipment_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `order` (`order_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `shipment`
--

LOCK TABLES `shipment` WRITE;
/*!40000 ALTER TABLE `shipment` DISABLE KEYS */;
INSERT INTO `shipment` VALUES (1,1,'Aramex','ARX123456','returned','2026-03-20','2026-03-19','2026-03-16 08:00:00'),(3,3,'Aramex','ARX345678','preparing','2026-03-28',NULL,NULL),(4,4,NULL,NULL,'preparing',NULL,NULL,NULL),(5,5,NULL,NULL,'preparing',NULL,NULL,NULL),(6,6,NULL,NULL,'preparing',NULL,NULL,NULL),(7,7,NULL,NULL,'shipped',NULL,NULL,NULL),(8,8,NULL,NULL,'preparing',NULL,NULL,NULL),(9,9,NULL,NULL,'preparing',NULL,NULL,NULL),(10,10,NULL,NULL,'preparing',NULL,NULL,NULL);
/*!40000 ALTER TABLE `shipment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `store`
--

DROP TABLE IF EXISTS `store`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `store` (
  `store_id` int NOT NULL AUTO_INCREMENT,
  `seller_id` int NOT NULL,
  `store_name` varchar(100) NOT NULL,
  `store_description` text,
  `logo_url` varchar(255) DEFAULT NULL,
  `banner_url` varchar(255) DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT '1',
  `rating_avg` decimal(3,2) DEFAULT '0.00',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`store_id`),
  KEY `seller_id` (`seller_id`),
  CONSTRAINT `store_ibfk_1` FOREIGN KEY (`seller_id`) REFERENCES `seller` (`seller_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `store`
--

LOCK TABLES `store` WRITE;
/*!40000 ALTER TABLE `store` DISABLE KEYS */;
INSERT INTO `store` VALUES (1,1,'TechZone','Best electronics in Palestine',NULL,NULL,1,0.00,'2026-05-07 13:07:16'),(2,2,'StyleHub','Trendy fashion for everyone',NULL,NULL,1,0.00,'2026-05-07 13:07:16'),(3,1,'TechZone','Best electronics in Palestine',NULL,NULL,1,0.00,'2026-05-08 23:04:39'),(4,1,'TechZone','Best electronics in Palestine',NULL,NULL,1,0.00,'2026-05-08 23:04:46'),(7,1,'lara','fdfdf',NULL,NULL,0,0.00,'2026-05-08 23:33:46'),(8,1,'1','',NULL,NULL,1,0.00,'2026-05-10 20:02:59'),(9,4,'map','',NULL,NULL,1,0.00,'2026-05-11 21:56:16'),(10,1,'rare','',NULL,NULL,1,0.00,'2026-05-12 00:45:04');
/*!40000 ALTER TABLE `store` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `user_id` int NOT NULL AUTO_INCREMENT,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `profile_image` varchar(255) DEFAULT NULL,
  `user_type` enum('buyer','seller','admin') NOT NULL,
  `is_active` tinyint(1) DEFAULT '1',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (1,'Ahmad','Naser','ahmad@email.com','hash123','599111111',NULL,'seller',1,'2026-05-07 13:07:16','2026-05-08 13:02:35'),(2,'Sara','Khalil','sara@email.com','hash456','599222222',NULL,'buyer',1,'2026-05-07 13:07:16','2026-05-08 13:02:21'),(3,'Omar','Ali','omar@email.com','hash789','599333333',NULL,'buyer',1,'2026-05-07 13:07:16','2026-05-08 13:03:07'),(4,'Lina','Mahmoud','lina@email.com','hash101','599444444',NULL,'seller',1,'2026-05-07 13:07:16','2026-05-08 13:03:00'),(5,'Khaled','Saleh','khaled@email.com','hash202','599555555','profile_images/5.jpg','admin',1,'2026-05-07 13:07:16','2026-05-12 00:26:00'),(6,'lara','rrr','dfdrr','default_hash','rrrr',NULL,'buyer',1,'2026-05-08 00:59:52','2026-05-08 00:59:52'),(7,'hhh','hhh','ggggf','default_hash','47444',NULL,'buyer',1,'2026-05-08 02:24:25','2026-05-08 02:24:25'),(8,'fdfd','fdff','fgf','default_hash','jjh',NULL,'buyer',1,'2026-05-08 02:24:32','2026-05-08 02:24:32'),(9,'lara','lalal','seljd@lekjdkj','hash','22222',NULL,'buyer',1,'2026-05-08 10:58:27','2026-05-08 13:03:51'),(11,'lara','saleh','laea@ fff','hash','05666 ',NULL,'buyer',1,'2026-05-08 14:18:27','2026-05-08 14:18:27'),(13,'jkhhnkh','saleh','ewwewee@gmail.com','hash','56669999',NULL,'buyer',1,'2026-05-08 14:20:36','2026-05-08 22:49:01'),(14,'ll','jnn','iuhh@gmail.com','hash','0559999',NULL,'buyer',1,'2026-05-08 14:50:53','2026-05-08 14:50:53'),(15,'lara','saleh','lara@gmail.com','2b2a0ff8f9def3f17d58512ab10d7b1b40e5ae06dabbddfd4d9278a428a3700c','059908255',NULL,'seller',1,'2026-05-10 19:43:01','2026-05-10 19:43:01'),(17,'lolo','lala','laraa@gmail.com','abd8cfba151826bb7bf3de57387e9653e9d7f54d61e2e107213b3add4383cf91','0599088756',NULL,'buyer',1,'2026-05-10 19:44:04','2026-05-10 19:44:04'),(18,'','','','e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855','',NULL,'buyer',0,'2026-05-10 19:49:13','2026-05-12 10:49:13'),(21,'lara','saleh','lara1@gmail.com','9af15b336e6a9619928537df30b2e6a2376569fcf9d7e773eccede65606529a0','059955565414','profile_images/21.jpg','buyer',1,'2026-05-10 22:32:53','2026-05-12 00:27:06'),(22,'LAILA','SA','LA@gmail.com','0ffe1abd1a08215353c233d6e009613e95eec4253832a761af28ff37ac5a150c','099998888',NULL,'seller',1,'2026-05-11 21:53:51','2026-05-11 21:53:51');
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wishlist`
--

DROP TABLE IF EXISTS `wishlist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `wishlist` (
  `wishlist_id` int NOT NULL AUTO_INCREMENT,
  `buyer_id` int NOT NULL,
  `product_id` int NOT NULL,
  `added_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`wishlist_id`),
  UNIQUE KEY `buyer_id` (`buyer_id`,`product_id`),
  KEY `product_id` (`product_id`),
  CONSTRAINT `wishlist_ibfk_1` FOREIGN KEY (`buyer_id`) REFERENCES `buyer` (`buyer_id`) ON DELETE CASCADE,
  CONSTRAINT `wishlist_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `product` (`product_id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wishlist`
--

LOCK TABLES `wishlist` WRITE;
/*!40000 ALTER TABLE `wishlist` DISABLE KEYS */;
INSERT INTO `wishlist` VALUES (3,2,1,'2026-05-07 13:07:16'),(4,2,6,'2026-05-07 13:07:16'),(6,1,16,'2026-05-10 21:37:31'),(7,6,23,'2026-05-10 22:44:01');
/*!40000 ALTER TABLE `wishlist` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'souqalmazad'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-05-14 23:57:25
