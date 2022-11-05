-- MySQL dump 10.13  Distrib 8.0.18, for Win64 (x86_64)
--
-- Host: localhost    Database: ferreteria
-- ------------------------------------------------------
-- Server version	8.0.18
DROP DATABASE IF EXISTS FERRETERIA;
CREATE DATABASE FERRETERIA;
USE FERRETERIA;

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
-- Table structure for table `pedidos`
--

DROP TABLE IF EXISTS `pedidos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pedidos` (
  `numped` int(11) NOT NULL,
  `fechap` date NOT NULL,
  `codprov` int(11) NOT NULL,
  PRIMARY KEY (`numped`),
  UNIQUE KEY `numped` (`numped`),
  KEY `codprov` (`codprov`),
  CONSTRAINT `pedidos_ibfk_1` FOREIGN KEY (`codprov`) REFERENCES `proveedores` (`codprov`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pedidos`
--

LOCK TABLES `pedidos` WRITE;
/*!40000 ALTER TABLE `pedidos` DISABLE KEYS */;
INSERT INTO `pedidos` VALUES (1,'2021-01-01',1),(2,'2021-01-10',2),(3,'2021-01-25',3),(4,'2021-02-02',1),(5,'2021-02-05',4),(6,'2021-02-15',1),(7,'2021-02-20',2),(8,'2021-03-03',2),(9,'2021-03-13',3),(10,'2021-03-23',1),(11,'2021-04-04',1),(12,'2021-02-24',4);
/*!40000 ALTER TABLE `pedidos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `piezas`
--

DROP TABLE IF EXISTS `piezas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `piezas` (
  `codpieza` int(11) NOT NULL,
  `nompieza` varchar(20) NOT NULL,
  `peso` int(11) NOT NULL,
  `color` varchar(20) NOT NULL,
  `existencias` int(11) NOT NULL,
  `precio` int(11) NOT NULL,
  PRIMARY KEY (`codpieza`),
  UNIQUE KEY `codpieza` (`codpieza`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `piezas`
--

LOCK TABLES `piezas` WRITE;
/*!40000 ALTER TABLE `piezas` DISABLE KEYS */;
INSERT INTO `piezas` VALUES (1,'tuerca',20,'dorado',10,110),(2,'tuerca',60,'plata',60,120),(3,'tornillo',30,'plata',120,50),(4,'puntilla',55,'dorado',40,150),(5,'tornillo',30,'dorado',30,30),(6,'puntilla',10,'plata',80,100),(7,'tuerca',30,'dorado',0,40),(8,'puntilla',125,'dorado',0,200);
/*!40000 ALTER TABLE `piezas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `proveedores`
--

DROP TABLE IF EXISTS `proveedores`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `proveedores` (
  `codprov` int(11) NOT NULL,
  `nombre` varchar(10) NOT NULL,
  `poblacion` varchar(50) NOT NULL,
  PRIMARY KEY (`codprov`),
  UNIQUE KEY `codprov` (`codprov`),
  UNIQUE KEY `nombre` (`nombre`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `proveedores`
--

LOCK TABLES `proveedores` WRITE;
/*!40000 ALTER TABLE `proveedores` DISABLE KEYS */;
INSERT INTO `proveedores` VALUES (1,'fersa','alcazar'),(2,'tarsa','madrid'),(3,'melorsa','toledo'),(4,'corsa','madrid'),(5,'ferreto','ciudad real');
/*!40000 ALTER TABLE `proveedores` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `remesas`
--

DROP TABLE IF EXISTS `remesas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `remesas` (
  `numped` int(11) NOT NULL,
  `codpieza` int(11) NOT NULL,
  `ctd` int(11) NOT NULL,
  PRIMARY KEY (`numped`,`codpieza`),
  KEY `codpieza` (`codpieza`),
  CONSTRAINT `remesas_ibfk_1` FOREIGN KEY (`numped`) REFERENCES `pedidos` (`numped`),
  CONSTRAINT `remesas_ibfk_2` FOREIGN KEY (`codpieza`) REFERENCES `piezas` (`codpieza`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `remesas`
--

LOCK TABLES `remesas` WRITE;
/*!40000 ALTER TABLE `remesas` DISABLE KEYS */;
INSERT INTO `remesas` VALUES (1,1,120),(1,2,150),(1,3,50),(2,4,250),(3,1,100),(3,6,300),(4,5,250),(5,1,80),(5,2,150),(5,3,100),(5,4,220),(6,5,130),(6,6,320),(7,1,180),(7,4,50),(8,3,350),(9,1,125),(9,2,75),(9,5,150),(10,3,75),(10,6,140),(11,1,220),(11,2,180),(11,4,160),(12,3,200),(12,5,300);
/*!40000 ALTER TABLE `remesas` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2021-01-19 13:01:22
