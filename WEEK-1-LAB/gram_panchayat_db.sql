-- MySQL dump 10.13  Distrib 8.0.46, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: gram_panchayat_db
-- ------------------------------------------------------
-- Server version	8.0.46

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
-- Table structure for table `certificate_application`
--

DROP TABLE IF EXISTS `certificate_application`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `certificate_application` (
  `application_id` int NOT NULL,
  `citizen_id` int NOT NULL,
  `certificate_name` varchar(100) NOT NULL,
  `application_date` date NOT NULL,
  `purpose` varchar(500) NOT NULL,
  `application_status` varchar(30) NOT NULL,
  `fee_paid` decimal(8,2) NOT NULL,
  `reference_number` varchar(30) NOT NULL,
  `issued_date` date DEFAULT NULL,
  PRIMARY KEY (`application_id`),
  UNIQUE KEY `reference_number` (`reference_number`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `certificate_application`
--

LOCK TABLES `certificate_application` WRITE;
/*!40000 ALTER TABLE `certificate_application` DISABLE KEYS */;
INSERT INTO `certificate_application` VALUES (1001,101,'Residence Certificate','2026-07-01','Bank account documentation','Under Review',30.00,'GP20260001',NULL),(1002,102,'Family Member Certificate','2026-07-02','Welfare scheme application','Approved',40.00,'GP20260002',NULL),(1003,103,'Property Certificate','2026-07-03','Property documentation','Submitted',50.00,'GP20260003',NULL),(1004,104,'Residence Certificate','2026-07-04','College admission','Approved',30.00,'GP20260004',NULL),(1005,105,'No-Dues Certificate','2026-07-05','Local service requirement','Under Review',25.00,'GP20260005',NULL),(1006,106,'Birth Record Request','2026-07-06','Personal documentation','Rejected',20.00,'GP20260006',NULL);
/*!40000 ALTER TABLE `certificate_application` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `certificate_type`
--

DROP TABLE IF EXISTS `certificate_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `certificate_type` (
  `certificate_type_id` int NOT NULL,
  `certificate_name` varchar(100) NOT NULL,
  `description` varchar(200) NOT NULL,
  `processing_days` int NOT NULL,
  `application_fee` decimal(8,2) NOT NULL,
  `is_available` tinyint(1) NOT NULL,
  PRIMARY KEY (`certificate_type_id`),
  UNIQUE KEY `certificate_name` (`certificate_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `certificate_type`
--

LOCK TABLES `certificate_type` WRITE;
/*!40000 ALTER TABLE `certificate_type` DISABLE KEYS */;
INSERT INTO `certificate_type` VALUES (1,'Residence Certificate','Certifies the declared place of residence',7,30.00,1),(2,'Birth Record Request','Request for a locally maintained birth record',5,20.00,1),(3,'Death Record Request','Request for a locally maintained death record',5,20.00,1),(4,'Family Member Certificate','Records declared family-member information',10,40.00,1),(5,'Property Certificate','Certificate related to locally maintained property records',12,50.00,1),(6,'No-Dues Certificate','Indicates applicable local dues status',7,25.00,1),(7,'Income Certificate','Certificate for citizen income',10,35.00,1);
/*!40000 ALTER TABLE `certificate_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `citizen`
--

DROP TABLE IF EXISTS `citizen`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `citizen` (
  `citizen_id` int NOT NULL,
  `full_name` varchar(100) NOT NULL,
  `date_of_birth` date NOT NULL,
  `gender` varchar(10) NOT NULL,
  `mobile_number` varchar(15) NOT NULL,
  `occupation` varchar(50) DEFAULT NULL,
  `village_name` varchar(50) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `address` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`citizen_id`),
  UNIQUE KEY `mobile_number` (`mobile_number`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `citizen`
--

LOCK TABLES `citizen` WRITE;
/*!40000 ALTER TABLE `citizen` DISABLE KEYS */;
INSERT INTO `citizen` VALUES (101,'Ravi Kumar','1995-06-15','Male','9876500001','Farmer','Ramapuram',1,NULL),(102,'Lakshmi Devi','1988-11-22','Female','9876500002','Tailor','Ramapuram',1,NULL),(103,'Suresh Babu','1992-03-10','Male','9876500003','Shopkeeper','Seethampeta',1,NULL),(104,'Anjali Rao','2000-08-05','Female','9876500004','Student','Ramapuram',1,NULL),(105,'Kiran Kumar','1985-01-18','Male','9876500005','Electrical Technician','Seethampeta',1,NULL),(106,'Meena Kumari','1998-12-30','Female','9876500006','Teacher','Lakshmipuram',0,NULL);
/*!40000 ALTER TABLE `citizen` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `panchayat_office`
--

DROP TABLE IF EXISTS `panchayat_office`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `panchayat_office` (
  `office_id` int NOT NULL,
  `office_name` varchar(100) NOT NULL,
  `village_name` varchar(50) NOT NULL,
  `pincode` varchar(6) NOT NULL,
  `contact_number` varchar(15) DEFAULT NULL,
  `office_email` varchar(100) DEFAULT NULL,
  `opening_time` time NOT NULL,
  `is_operational` tinyint(1) NOT NULL,
  `closing_time` time DEFAULT NULL,
  PRIMARY KEY (`office_id`),
  UNIQUE KEY `contact_number` (`contact_number`),
  UNIQUE KEY `office_email` (`office_email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `panchayat_office`
--

LOCK TABLES `panchayat_office` WRITE;
/*!40000 ALTER TABLE `panchayat_office` DISABLE KEYS */;
INSERT INTO `panchayat_office` VALUES (1,'Ramapuram Gram Panchayat','Ramapuram','521101','0866000001','ramapuram@gp.example','09:00:00',1,NULL),(2,'Seethampeta Gram Panchayat','Seethampeta','521102','0866000002','seethampeta@gp.example','09:30:00',1,NULL),(3,'Lakshmipuram Gram Panchayat','Lakshmipuram','521103','0866000003','lakshmipuram@gp.example','09:00:00',1,NULL),(4,'Krishnapuram Gram Panchayat','Krishnapuram','521104','0866000004','krishnapuram@gp.example','10:00:00',1,NULL),(5,'Venkatapuram Gram Panchayat','Venkatapuram','521105','0866000005','venkatapuram@gp.example','09:30:00',1,NULL),(6,'Gopalapuram Gram Panchayat','Gopalapuram','521106','0866000006','gopalapuram@gp.example','09:00:00',0,NULL);
/*!40000 ALTER TABLE `panchayat_office` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-07-19  1:51:30
