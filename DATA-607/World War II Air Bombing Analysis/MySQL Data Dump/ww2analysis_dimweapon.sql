-- MySQL dump 10.13  Distrib 5.7.17, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: ww2analysis
-- ------------------------------------------------------
-- Server version	8.0.11

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `dimweapon`
--

DROP TABLE IF EXISTS `dimweapon`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dimweapon` (
  `weapon_id` int(11) NOT NULL,
  `country` varchar(50) DEFAULT NULL,
  `weapon_name` varchar(100) DEFAULT NULL,
  `weapon_type` varchar(20) DEFAULT NULL,
  `weapon_class` varchar(5) DEFAULT NULL,
  `number_of_bomblets` int(11) NOT NULL DEFAULT '0',
  `alt_weapon_name` varchar(100) DEFAULT NULL,
  `weapon_description` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`weapon_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dimweapon`
--

LOCK TABLES `dimweapon` WRITE;
/*!40000 ALTER TABLE `dimweapon` DISABLE KEYS */;
INSERT INTO `dimweapon` VALUES (1,'USA','10 lb Incendiary','','IC',0,'AN-M67 or AN-M69','10 lb Incendiary that used White Phosphorous or other incendiary fuel'),(2,'USA','100 lb Incendiary','','IC',0,'M47A2','100 lb M47A2 Incendiary usually loaded with gelled gassoline (Napalm)'),(3,'USA','100 lb WP (White Phosphrous)','','IC',0,'M47A2','100 lb M47A2 Smoke bomb'),(4,'USA','1000 lb aux fuel tank Incendiary','','IC',0,'','1000 lb Auxiliary fuel tank. When used as incendiaries they were usually filled with napalm'),(5,'USA','136 lb (38x4 Clusters) I-M6','I-M6','IC',0,'M6','M6 Cluster containing 38 AN-M50 incendiary bombs. They usually carried 128 AN-M50\'s.'),(6,'USA','2000 lb Aux Fuel Tank as Incendiary ','','IC',0,'','2000 lb Auxiliary fuel tank. When used as incendiaries they were usually filled with napalm'),(7,'USA','30 lb RAF Incendiary','','IC',0,'I.B 30-lb Mk I-IV','30 lb Type-J Mk-I Superflamer Incendiary bomb'),(8,'USA','300 lb aux fuel tank Incendiary','','IC',0,'','300 lb Auxiliary fuel tank. When used as incendiaries they were usually filled with napalm'),(9,'USA','300 lb Incendiary','','IC',0,'M31','300 lb Incendiary cluster bomb usually containing M74 or other small incendiary bombs'),(10,'USA','360 lb (60x6 Clusters) Incendiary I-M13','I-M13','IC',0,'AN-M13','500 lb Cluster containing 60 M-69 incendiary bombs'),(11,'USA','4 lb Incendiary','','IC',0,'AN-M50','\"4 lb Incendiary. There were several types such as the AN-M50XA1, M50A2, and AN-M50XA3\"'),(12,'USA','440 lb (110x4 Clusters) I-M17','I-M17','IC',0,'M17','The M17 was a 500 lb cluster bomb used to disperse the AN-M50A1 bombs'),(13,'USA','500 lb aux fuel tank Incendiary','','IC',0,'','500 lb Auxiliary fuel tank. When used as incendiaries they were usually filled with napalm'),(14,'USA','500 lb Incendiary','','IC',0,'\"M17, AN-M76, or M78\"','500 lb M17 cluster or AN-M76 incendiary which used white phosphorous and fuel or a gasoline gel-magnesium mixture. The M78 was a gass bomb'),(15,'USA','512 lb (128x4 Clusters) Incendiary I-M7','I-M7','IC',0,'M7','M7 Cluster containing 128 AN-M50 incendiary bombs. They were also used to carry clusters of  60 AN-M69 incendiary bombs.'),(16,'USA','6 lb Incendiary','','IC',0,'AN-M69 / M-69 ','6 lb Napalm incendiary bomb'),(17,'USA','660 lb Aux Fuel Tank as Incendiary ','','IC',0,'','660 lb Auxiliary fuel tank. When used as incendiaries they were usually filled with napalm'),(18,'USA','84 lb Incendiary (14x6 Cluster) I-M12','I-M12','IC',0,'AN-M12','100 lb Cluster containing 14 M-69 incendiary bombs'),(19,'USA','100 lb GP (GP-M30)','GP-M30','HE',0,'AN-M30','100 lb General Purpose'),(20,'USA','1000 lb AP (AP-Mk 33)','AP-Mk 33','HE',0,'AN-Mk33 or M52','1000 lb Armor Piercing'),(21,'USA','1000 lb GP (GP-M44/M65)','GP-M44/M65','HE',0,'AN-M44 or AN-M65','1000 lb General Purpose'),(22,'USA','1000 lb mines','','HE',0,'','Mk-26 or MK-13???'),(23,'USA','1000 lb SAP(SA-M59)','SA-M59','HE',0,'AN-M59','1000 lb Semi Armor Piercing'),(24,'USA','10000 lb Pumpkin Bomb (Atomic Bomb training)','','HE',0,'','10000 lb Pumpkin Bomb (Atomic Bomb training)'),(25,'USA','1600 lb AP(AP-Mk 1)','AP-Mk 1','HE',0,'AN-Mk1','1600 lb Armor Piercing'),(26,'USA','2000 lb GP (GP-M34/M66)','GP-M34/M66','HE',0,'AN-M34 or AN-M66','2000 lb General Purpose'),(27,'USA','2000 lb mines (M-Mk 12)','M-Mk12','HE',0,'','2000 lb mines'),(28,'USA','250 lb GP (GP-M57)','GP-M57','HE',0,'AN-M57','250 lb General Purpose'),(29,'USA','300 lb GP (GP-31)','GP-31','HE',0,'M31','300 lb General Purpose replaced by the AN-M57'),(30,'USA','325 lb DC (DB-Mk 17/47)','DB-Mk 17/47','HE',0,'AN-Mk17 or AN-Mk47','325 lb AN-Mk17 or 350 lb AN-Mk47 Depth Bomb (Depth Charge) (AN-Mk41 and AN-Mk44 were similar to the AN-Mk47)'),(31,'USA','4000 lb GP (GP-M56)','GP-M56','HE',0,'AN-M56','4000 lb Light Case ╥Blockbuster╙'),(32,'USA','500 lb GP (GP-M43/M64)','GP-M43/M64','HE',0,'AN-M43 or AN-M64','500 lb General Purpose'),(33,'USA','500 lb SAP (SA-M58)','SA-M58','HE',0,'AN-M58','500 lb Semi Armor Piercing'),(34,'USA','600 lb GP (GP-M32)','GP-M32','HE',0,'','600 lb Armor Piercing M62 ???'),(35,'USA','Atomic Bomb (Fat Man)','Fat Man','HE',0,'','Mark III 20 Kiloton Atomic Bomb'),(36,'USA','Atomic Bomb (Little Boy)','Little Boy','HE',0,'','15 Kiloton Atomic Bomb'),(37,'USA','Flares Pyrotechnics(Py-M26)','Py-M26','HE',0,'AN-M26','Pyrotechnics/Flares used to illuminate targets'),(38,'USA','Torpedoes Misc','','HE',0,'Mark 13','The most common U.S. torpedo was the Mark 13'),(39,'USA','120 lb Frag (6x20 Clusters)','','Frag',0,'','Cluster bomb containing 6 M41 fragmentation bombs'),(40,'USA','20 lb Frag','M41','Frag',0,'M41','US M41 20 lb Fragmentation bomb'),(41,'USA','23 lb Frag','','Frag',0,'AN-M40 or AN-M72','For AN-M40 see 23 lb Parafrag'),(42,'USA','23 LB Frag Clusters (6 x23 per cluster)','','Frag',0,'','Cluster bomb containing 6 AN-M40 or AN-M72 fragmentation bombs'),(43,'USA','23 LB Parafrag','An-M40','Frag',0,'AN-M40','23 lb Parachute Fragmentation bomb'),(44,'USA','260 lb Frag','','Frag',0,'AN-M81','260 lb AN-M81 Fragmentation bomb'),(45,'USA','360 lb Frag (90x4 Clusters)','','Frag',0,'','Cluster bomb containing 90 M83 (butterfly) fragmentation bombs'),(46,'USA','4 lb Frag','','Frag',0,'M83','4 lb M83 fragmentation bomb (butterfly bomb)'),(47,'USA','400 lb Frag (20x20 Clusters)','','Frag',0,'','Cluster bomb containing 20 M41 fragmentation bombs'),(48,'USA','69 lb Frag (3x23 Clusters)','','Frag',0,'','Cluster bomb containing 3 AN-M40 or AN-M72 fragmentation bombs'),(49,'USA','90 lb Frag','','Frag',0,'M82','90 lb Fragmentation bomb'),(50,'USA','96 lb Frag (24x4 Clusters)','','Frag',0,'','Cluster bomb containing 24 M83 (butterfly) fragmentation bombs'),(51,'New Zealand','350 lb DC','','HE',0,'AN-Mk47','\"350 lb AN-Mk41, Mk44, or Mk47 Depth Bomb (Depth Charge)\"'),(52,'New Zealand','650 lb DC','','HE',0,'MK-29 or Mk37','650 lb Mk-29 or Mk37 Depth bomb (depth charge)'),(53,'Great Britain','30 lb Incendiary','','IC',0,'I.B 30-lb Mk I-IV','30 lb Type-J Mk-I Superflamer Incendiary bomb'),(54,'Great Britain','4 lb Incendiary','','IC',0,'4-lb In Mk I-V','4 lb Incendiary bomb'),(55,'Great Britain','500 lb Incendiary','','IC',106,'','Usually a cluster bomb containing 4 lb Mk-I-Vs'),(56,'Great Britain','250 lb GP (GP-M57)','GP-M57','HE',0,'','250 lb General Purpose'),(57,'Great Britain','4000 lb GP (GP-M56)','GP-M56','HE',0,'Mk I-VI','4000 lb Light Case ╥Blockbuster╙ or ╥Cookie╙'),(58,'Great Britain','Dummy Paratroops','','HE',0,'Paradummy','╥Rupert╙ Paradummy was a fake paratrooper dropped to deceive the enemy'),(59,'Great Britain','Leaflet','','HE',0,'','Bombs/containers used to dispense propaganda leaflets');
/*!40000 ALTER TABLE `dimweapon` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2018-09-29 20:16:19
