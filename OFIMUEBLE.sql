CREATE DATABASE  IF NOT EXISTS `ofimueble` /*!40100 DEFAULT CHARACTER SET utf8 */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `ofimueble`;
-- MySQL dump 10.13  Distrib 8.0.18, for Win64 (x86_64)
--
-- Host: localhost    Database: ofimueble
-- ------------------------------------------------------
-- Server version	8.0.18

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
-- Table structure for table `areas`
--

DROP TABLE IF EXISTS `areas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `areas` (
  `CODIGO` int(11) NOT NULL,
  `NOMBRE` varchar(10) NOT NULL,
  PRIMARY KEY (`CODIGO`),
  UNIQUE KEY `CODIGO` (`CODIGO`),
  UNIQUE KEY `NOMBRE` (`NOMBRE`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `areas`
--

LOCK TABLES `areas` WRITE;
/*!40000 ALTER TABLE `areas` DISABLE KEYS */;
INSERT INTO `areas` VALUES (1,'CENTRO'),(2,'NORTE'),(3,'SUR');
/*!40000 ALTER TABLE `areas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `clientes`
--

DROP TABLE IF EXISTS `clientes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `clientes` (
  `CODIGO` int(11) NOT NULL,
  `NOMBRE` varchar(30) NOT NULL,
  `TELEF` varchar(10) DEFAULT NULL,
  `CODOFIC` int(11) NOT NULL,
  PRIMARY KEY (`CODIGO`),
  UNIQUE KEY `CODIGO` (`CODIGO`),
  KEY `CODOFIC` (`CODOFIC`),
  CONSTRAINT `clientes_ibfk_1` FOREIGN KEY (`CODOFIC`) REFERENCES `oficinas` (`CODIGO`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clientes`
--

LOCK TABLES `clientes` WRITE;
/*!40000 ALTER TABLE `clientes` DISABLE KEYS */;
INSERT INTO `clientes` VALUES (1,'ABAD',NULL,1),(2,'JIMENEZ',NULL,10),(3,'GARCIA',NULL,4),(4,'MORA',NULL,5),(5,'FERNANDEZ',NULL,19),(6,'ARIAS',NULL,8),(7,'RAMOS',NULL,7),(8,'PALACIOS',NULL,15),(9,'MOYA',NULL,12),(10,'MARTIN',NULL,10),(11,'MARTINEZ',NULL,16),(12,'GARCIA',NULL,6),(13,'RODRIGUEZ',NULL,13),(14,'INIESTA',NULL,2),(15,'LOPEZ',NULL,11),(16,'FLORES',NULL,14),(17,'GARCIA',NULL,9),(18,'JIMENEZ',NULL,3),(19,'MOLINA',NULL,18),(20,'ORTEGA',NULL,17),(21,'GOMEZ',NULL,1),(22,'PEREZ',NULL,13),(23,'JIMENEZ',NULL,7),(24,'FERNANDEZ',NULL,8),(25,'MORENO',NULL,11),(26,'TORRES',NULL,15),(27,'SANTOS',NULL,4),(28,'VELA',NULL,12),(29,'RUIZ',NULL,20),(30,'OLIVER',NULL,17),(31,'HERRERA',NULL,3),(32,'ZAPATA',NULL,1),(33,'BAEZA',NULL,15),(34,'GARCIA',NULL,18),(35,'MORALES',NULL,4),(36,'SANCHEZ',NULL,10),(37,'COCA',NULL,9),(38,'MARTINEZ',NULL,1);
/*!40000 ALTER TABLE `clientes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lineasventa`
--

DROP TABLE IF EXISTS `lineasventa`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `lineasventa` (
  `NOVENTA` int(11) NOT NULL,
  `CODPROD` int(11) NOT NULL,
  `CTD` int(11) NOT NULL,
  PRIMARY KEY (`NOVENTA`,`CODPROD`),
  KEY `CODPROD` (`CODPROD`),
  CONSTRAINT `lineasventa_ibfk_1` FOREIGN KEY (`NOVENTA`) REFERENCES `ventas` (`NOVENTA`),
  CONSTRAINT `lineasventa_ibfk_2` FOREIGN KEY (`CODPROD`) REFERENCES `productos` (`CODIGO`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lineasventa`
--

LOCK TABLES `lineasventa` WRITE;
/*!40000 ALTER TABLE `lineasventa` DISABLE KEYS */;
INSERT INTO `lineasventa` VALUES (1,2,50),(1,8,30),(1,10,10),(2,3,10),(2,4,20),(3,1,15),(3,5,10),(3,6,25),(3,10,5),(4,9,10),(5,4,100),(5,10,50),(6,3,20),(6,6,15),(6,7,10),(7,1,80),(8,2,100),(8,5,60),(9,4,30),(9,9,25),(10,5,40),(10,7,10),(10,9,30),(11,7,5),(11,8,100),(12,3,10),(12,4,15),(12,5,20),(13,6,50),(14,1,20),(14,2,20),(15,7,12),(15,8,50),(15,9,20),(16,2,75),(17,4,15),(17,10,10),(18,8,50),(18,9,20),(19,5,50),(20,1,15),(20,4,20),(20,5,25),(21,3,10),(21,7,8),(22,9,12),(23,2,30),(23,8,12),(24,4,40),(25,1,20),(25,4,10),(25,7,5),(26,6,30),(27,5,30),(27,8,25),(28,10,15),(29,1,50),(29,2,70),(30,9,15),(31,6,12),(32,1,20),(32,4,10),(32,8,10),(33,3,10),(33,6,15),(34,7,8),(35,1,20),(35,10,8),(36,3,8),(37,4,10),(37,6,8),(37,7,5),(37,8,10),(38,2,20),(38,5,10),(39,6,12),(40,4,5),(40,10,5),(41,3,8),(41,8,20),(42,7,8),(43,2,50),(44,1,10),(44,3,5),(44,5,20),(45,9,12),(46,6,8),(47,1,10),(47,2,15),(48,3,10),(48,4,15),(49,1,12),(49,9,7),(50,1,20),(50,3,8),(50,7,5),(50,8,10),(50,10,5);
/*!40000 ALTER TABLE `lineasventa` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `oficinas`
--

DROP TABLE IF EXISTS `oficinas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `oficinas` (
  `CODIGO` int(11) NOT NULL,
  `POBLACION` varchar(30) NOT NULL,
  PRIMARY KEY (`CODIGO`),
  UNIQUE KEY `CODIGO` (`CODIGO`),
  KEY `POBLACION` (`POBLACION`),
  CONSTRAINT `oficinas_ibfk_1` FOREIGN KEY (`POBLACION`) REFERENCES `poblaciones` (`POBLACION`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `oficinas`
--

LOCK TABLES `oficinas` WRITE;
/*!40000 ALTER TABLE `oficinas` DISABLE KEYS */;
INSERT INTO `oficinas` VALUES (10,'ALBACETE'),(11,'ALCAZAR DE SAN JUAN'),(20,'AVILA'),(8,'BADAJOZ'),(16,'BADALONA'),(15,'BARCELONA'),(9,'CIUDAD REAL'),(3,'FUENLABRADA'),(17,'HOSPITALET'),(19,'LEON'),(1,'MADRID'),(6,'MALAGA'),(7,'MARBELLA'),(2,'MOSTOLES'),(12,'MURCIA'),(4,'SEVILLA'),(5,'SEVILLA'),(18,'TARRAGONA'),(13,'ZARAGOZA'),(14,'ZARAGOZA');
/*!40000 ALTER TABLE `oficinas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `poblaciones`
--

DROP TABLE IF EXISTS `poblaciones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `poblaciones` (
  `POBLACION` varchar(30) NOT NULL,
  `PROVINCIA` varchar(20) NOT NULL,
  PRIMARY KEY (`POBLACION`),
  UNIQUE KEY `POBLACION` (`POBLACION`),
  KEY `PROVINCIA` (`PROVINCIA`),
  CONSTRAINT `poblaciones_ibfk_1` FOREIGN KEY (`PROVINCIA`) REFERENCES `provincias` (`PROVINCIA`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `poblaciones`
--

LOCK TABLES `poblaciones` WRITE;
/*!40000 ALTER TABLE `poblaciones` DISABLE KEYS */;
INSERT INTO `poblaciones` VALUES ('ALBACETE','ALBACETE'),('AVILA','AVILA'),('BADAJOZ','BADAJOZ'),('BADALONA','BARCELONA'),('BARCELONA','BARCELONA'),('HOSPITALET','BARCELONA'),('ALCAZAR DE SAN JUAN','CIUDAD REAL'),('CIUDAD REAL','CIUDAD REAL'),('LEON','LEON'),('FUENLABRADA','MADRID'),('MADRID','MADRID'),('MOSTOLES','MADRID'),('MALAGA','MALAGA'),('MARBELLA','MALAGA'),('MURCIA','MURCIA'),('SEVILLA','SEVILLA'),('TARRAGONA','TARRAGONA'),('ZARAGOZA','ZARAGOZA');
/*!40000 ALTER TABLE `poblaciones` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `productos`
--

DROP TABLE IF EXISTS `productos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `productos` (
  `CODIGO` int(11) NOT NULL,
  `DESCRIPCION` varchar(20) NOT NULL,
  `MATERIAL` varchar(15) NOT NULL,
  `DIMENSIONES` varchar(15) NOT NULL,
  `EXISTENCIAS` int(11) NOT NULL,
  `PVP` int(11) NOT NULL,
  PRIMARY KEY (`CODIGO`),
  UNIQUE KEY `CODIGO` (`CODIGO`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `productos`
--

LOCK TABLES `productos` WRITE;
/*!40000 ALTER TABLE `productos` DISABLE KEYS */;
INSERT INTO `productos` VALUES (1,'MESA','MADERA','90x90',45,30),(2,'SILLA','MADERA','40x40',150,20),(3,'CAMA','HIERRO','90x185',75,120),(4,'PUERTA','HIERRO','200x90',90,60),(5,'SILLA','MADERA','45x40',200,40),(6,'CAMA','HIERRO','135x190',100,100),(7,'CAMA','MADERA','150x200',40,250),(8,'MESA','MADERA','100x90',60,50),(9,'MESA','HIERRO','80x75',25,110),(10,'PUERTA','MADERA','190x90',175,125),(11,'SILLA','HIERRO','30x30',0,25),(12,'CAMA','MADERA','200x200',0,200),(13,'PUERTA','MADERA','250x100',0,100);
/*!40000 ALTER TABLE `productos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `provincias`
--

DROP TABLE IF EXISTS `provincias`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `provincias` (
  `PROVINCIA` varchar(20) NOT NULL,
  `CODZONA` int(11) NOT NULL,
  PRIMARY KEY (`PROVINCIA`),
  UNIQUE KEY `PROVINCIA` (`PROVINCIA`),
  KEY `CODZONA` (`CODZONA`),
  CONSTRAINT `provincias_ibfk_1` FOREIGN KEY (`CODZONA`) REFERENCES `zonas` (`CODIGO`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `provincias`
--

LOCK TABLES `provincias` WRITE;
/*!40000 ALTER TABLE `provincias` DISABLE KEYS */;
INSERT INTO `provincias` VALUES ('MADRID',1),('BARCELONA',2),('TARRAGONA',2),('BADAJOZ',3),('MURCIA',4),('ZARAGOZA',5),('ALBACETE',6),('CIUDAD REAL',6),('MALAGA',7),('SEVILLA',7),('AVILA',8),('LEON',8);
/*!40000 ALTER TABLE `provincias` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ventas`
--

DROP TABLE IF EXISTS `ventas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ventas` (
  `NOVENTA` int(11) NOT NULL,
  `FECHAV` date NOT NULL,
  `CODCLI` int(11) NOT NULL,
  PRIMARY KEY (`NOVENTA`),
  UNIQUE KEY `NOVENTA` (`NOVENTA`),
  KEY `CODCLI` (`CODCLI`),
  CONSTRAINT `ventas_ibfk_1` FOREIGN KEY (`CODCLI`) REFERENCES `clientes` (`CODIGO`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ventas`
--

LOCK TABLES `ventas` WRITE;
/*!40000 ALTER TABLE `ventas` DISABLE KEYS */;
INSERT INTO `ventas` VALUES (1,'2019-01-10',1),(2,'2019-01-10',16),(3,'2019-01-15',9),(4,'2019-02-03',1),(5,'2019-02-20',5),(6,'2019-02-20',18),(7,'2019-02-25',32),(8,'2019-03-01',17),(9,'2019-03-01',25),(10,'2019-03-01',28),(11,'2019-03-01',34),(12,'2019-03-12',2),(13,'2019-03-20',5),(14,'2019-03-28',23),(15,'2019-04-02',14),(16,'2019-04-05',24),(17,'2019-04-10',30),(18,'2019-04-10',6),(19,'2019-04-10',10),(20,'2019-04-15',12),(21,'2019-04-20',29),(22,'2019-04-20',31),(23,'2019-04-25',3),(24,'2019-04-28',7),(25,'2019-05-02',8),(26,'2019-05-03',11),(27,'2019-05-04',22),(28,'2019-05-04',23),(29,'2019-05-10',29),(30,'2019-05-10',15),(31,'2019-05-10',21),(32,'2019-05-18',34),(33,'2019-05-22',11),(34,'2019-05-25',20),(35,'2019-05-30',25),(36,'2019-05-31',12),(37,'2019-06-02',16),(38,'2019-06-02',13),(39,'2019-06-02',17),(40,'2019-06-05',19),(41,'2019-06-08',25),(42,'2019-06-08',33),(43,'2019-06-10',32),(44,'2019-06-12',26),(45,'2019-06-13',4),(46,'2019-06-13',3),(47,'2019-06-13',27),(48,'2019-06-20',1),(49,'2019-06-25',4),(50,'2019-06-28',1);
/*!40000 ALTER TABLE `ventas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `zonas`
--

DROP TABLE IF EXISTS `zonas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `zonas` (
  `CODIGO` int(11) NOT NULL,
  `NOMBRE` varchar(20) NOT NULL,
  `CODAREA` int(11) NOT NULL,
  PRIMARY KEY (`CODIGO`),
  UNIQUE KEY `CODIGO` (`CODIGO`),
  UNIQUE KEY `NOMBRE` (`NOMBRE`),
  KEY `CODAREA` (`CODAREA`),
  CONSTRAINT `zonas_ibfk_1` FOREIGN KEY (`CODAREA`) REFERENCES `areas` (`CODIGO`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `zonas`
--

LOCK TABLES `zonas` WRITE;
/*!40000 ALTER TABLE `zonas` DISABLE KEYS */;
INSERT INTO `zonas` VALUES (1,'MADRID',1),(2,'CATALUÑA',2),(3,'EXTREMADURA',1),(4,'MURCIA',3),(5,'ARAGON',2),(6,'CASTILLA LA MANCHA',1),(7,'ANDALUCIA',3),(8,'CASTILLA LEON',2);
/*!40000 ALTER TABLE `zonas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'ofimueble'
--

--
-- Dumping routines for database 'ofimueble'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2022-01-21 12:44:04
