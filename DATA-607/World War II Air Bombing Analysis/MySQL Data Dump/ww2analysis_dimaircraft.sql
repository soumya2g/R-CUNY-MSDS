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
-- Table structure for table `dimaircraft`
--

DROP TABLE IF EXISTS `dimaircraft`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dimaircraft` (
  `gloss_id` int(11) NOT NULL,
  `aircraft` varchar(50) DEFAULT NULL,
  `name` varchar(100) DEFAULT NULL,
  `full_name` varchar(500) DEFAULT NULL,
  `aircraft_type` varchar(100) DEFAULT NULL,
  `hyperlink` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`gloss_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dimaircraft`
--

LOCK TABLES `dimaircraft` WRITE;
/*!40000 ALTER TABLE `dimaircraft` DISABLE KEYS */;
INSERT INTO `dimaircraft` VALUES (1,'A20','A20','Douglas A-20 Havoc','Boston Light Bomber / Night-Fighter','http://militaryfactory.com/aircraft/detail.asp?aircraft_id=186'),(2,'A24','A24','Douglass A-24 Banshee','Dive Bomber / Reconnaissance','http://militaryfactory.com/aircraft/detail.asp?aircraft_id=491'),(3,'A26','A26','Douglas A-26 Invader','Medium Bomber / Heavy Assault','http://militaryfactory.com/aircraft/detail.asp?aircraft_id=91'),(4,'A36','A36','North American A-36 Apache (Invader)','Ground Attack / Dive Bomber','http://militaryfactory.com/aircraft/detail.asp?aircraft_id=687'),(5,'ALBA','Albacore','Fairey Albacore ','Naval Torpedo Bomber','http://militaryfactory.com/aircraft/detail.asp?aircraft_id=1390'),(6,'AUDA','Audax','Hawker Audax','Biplane Light Bomber','http://en.wikipedia.org/wiki/Hawker_Hart'),(7,'B17','FORT','B-17 Flying Fortress','Heavy Bomber','http://boeing.com/history/products/b-17-flying-fortress.page'),(8,'B24','Liberator','B-24 Liberator','Heavy Bomber','http://militaryfactory.com/aircraft/detail.asp?aircraft_id=80'),(9,'B25','B25','B-25 Mitchell','Medium Bomber','http://militaryfactory.com/aircraft/detail.asp?aircraft_id=81'),(10,'B26','B26','Martin B-26 Marauder','Medium Bomber','http://militaryfactory.com/aircraft/detail.asp?aircraft_id=299'),(11,'B29','B29','Boeing B-29 Superfortress','\"Strategic Long-Range, High-Altitude Heavy Bomber\"','http://militaryfactory.com/aircraft/detail.asp?aircraft_id=825'),(12,'B32','B32','B-32 Dominator','Heavy Bomber','http://militaryfactory.com/aircraft/detail.asp?aircraft_id=655'),(13,'BALT','Baltimore','Martin Baltimore','Light / Medium Bomber','http://militaryfactory.com/aircraft/detail.asp?aircraft_id=264'),(14,'BATT','Fairey Battle','Fairey Battle','Light Bomber / Trainer','http://militaryfactory.com/aircraft/detail.asp?aircraft_id=851'),(15,'BEAU','Beaufighter','Bristol Beaufighter','Heavy Fighter / Night-Fighter','http://militaryfactory.com/aircraft/detail.asp?aircraft_id=135'),(16,'BEAUF','Beaufort','Bristol Beaufort','Torpedo Bomber','http://militaryfactory.com/aircraft/detail.asp?aircraft_id=307'),(17,'BLEN','Blenheim','Bristol Blenheim','Light / Medium Bomber','http://militaryfactory.com/aircraft/detail.asp?aircraft_id=293'),(18,'BOM','Bombay','Bristol Bombay','Troop Transport / Medium Bomber','http://en.wikipedia.org/wiki/Bristol_Bombay'),(19,'Catalina','Catalina','PBY Catalina','Long-Range Maritime Patrol Flying Boat','http://militaryfactory.com/aircraft/detail.asp?aircraft_id=318'),(20,'F4U','F4U','Vought F4U Corsair','Carrier-Based Fighter / Fighter-Bomber / Night Fighter','http://militaryfactory.com/aircraft/detail.asp?aircraft_id=87'),(21,'GLAD','Gladiator','Gloster Gladiator','Biplane Fighter','http://militaryfactory.com/aircraft/detail.asp?aircraft_id=624'),(22,'HALI','Halifax','Handley Page Halifax','Heavy Night Bomber','http://militaryfactory.com/aircraft/detail.asp?aircraft_id=233'),(23,'HAMP','Hampden','Handley Page HP.52 Hampden','Medium Bomber','http://en.wikipedia.org/wiki/Handley_Page_Hampden'),(24,'HAR','Hawker Hardy','Hawker Hardy','Biplane Light Bomber','http://en.wikipedia.org/wiki/Hawker_Hart#Hardy'),(25,'Hudson','Hudson','Lockheed Hudson','Light Bomber','http://en.wikipedia.org/wiki/Lockheed_Hudson'),(26,'HURR','Hurricane','Hawker Hurricane','Fighter / Ground Attack','http://militaryfactory.com/aircraft/detail.asp?aircraft_id=125'),(27,'HVY','Lancaster','Avro Lancaster','Heavy Bomber / Reconnaissance','http://militaryfactory.com/aircraft/detail.asp?aircraft_id=234'),(28,'JU86','Ju 86','Junkers Ju 86','Reconnaissance / Medium Bomber','http://militaryfactory.com/aircraft/detail.asp?aircraft_id=825'),(29,'LYS','Lysander','Westland Lysander','Liaison Aircraft','http://en.wikipedia.org/wiki/Westland_Lysander'),(30,'MANC','Manchester','Avro Manchester','Heavy Bomber','http://militaryfactory.com/aircraft/detail.asp?aircraft_id=691'),(31,'MARY','Maryland','Martin Maryland','Light Bomber / Reconnaissance','http://militaryfactory.com/aircraft/detail.asp?aircraft_id=485'),(32,'MOHA','Mohawk','Curtiss P-36 Hawk (Hawk 75 / Mohawk)','Fighter','http://militaryfactory.com/aircraft/detail.asp?aircraft_id=155'),(33,'P38','P38','Lockheed P-38 Lightning','Heavy Fighter / Fighter-Bomber','http://militaryfactory.com/aircraft/detail.asp?aircraft_id=74'),(34,'P39','P39','Bell P-39 Airacobra','Fighter / Fighter-Bomber','http://militaryfactory.com/aircraft/detail.asp?aircraft_id=140'),(35,'P40','P40','Curtiss P-40 Warhawk','Fighter-Bomber','http://militaryfactory.com/aircraft/detail.asp?aircraft_id=75'),(36,'P400','P400','P-400 Airacobra (P-39 Airacobra)','Fighter / Fighter-Bomber','http://en.wikipedia.org/wiki/Bell_P-39_Airacobra#P-400'),(37,'P47','P47','Republic P-47 Thunderbolt','Fighter / Fighter-Bomber','http://militaryfactory.com/aircraft/detail.asp?aircraft_id=76'),(38,'P51','P51','North American P-51 Mustang','Fighter / Fighter-Bomber / Reconnaissance','http://militaryfactory.com/aircraft/detail.asp?aircraft_id=77'),(39,'P61','P61','Northrop P-61 / F-61 Black Widow','Night Fighter / Reconnaissance','http://militaryfactory.com/aircraft/detail.asp?aircraft_id=78'),(40,'P70','P70','Douglas P-70 Nighthawk','Night-Fighter','http://militaryfactory.com/aircraft/detail.asp?aircraft_id=1214'),(41,'PV-1 Ventura','PV-1 Ventura','PV-1 Lockeed Ventura','Patrol Bomber','http://en.wikipedia.org/wiki/Lockeed_Ventura'),(42,'SBD','SBD Dauntless','Douglas SBD Dauntless','Carrier-borne Dive Bomber','http://militaryfactory.com/aircraft/detail.asp?aircraft_id=297'),(43,'STIR','Short Stirling','Short Stirling','Heavy Bomber','http://militaryfactory.com/aircraft/detail.asp?aircraft_id=308'),(44,'SUND','Sunderland','Short S25 Sunderland','Long-Range Maritime / Reconnaissance Flying Boat','http://militaryfactory.com/aircraft/detail.asp?aircraft_id=319'),(45,'SWORD','Swordfish','Fairey Swordfish','Torpedo Bomber / Anti-Submarine / Reconnaissance / Trainer','http://militaryfactory.com/aircraft/detail.asp?aircraft_id=571'),(46,'TBF Avenger','TBF Avenger','Grumman TBF Avenger','Carrier-Borne Torpedo Bomber','http://militaryfactory.com/aircraft/detail.asp?aircraft_id=300'),(47,'TOM','Tomahawk','Curtis P-40 Tomahawk','Fighter','http://militaryfactory.com/aircraft/detail.asp?aircraft_id=1433'),(48,'VALE','Valentia','Vikers Valentia','Bombing Transport / Cargo','http://en.wikipedia.org/wiki/Vickers_Type_264_Valentia'),(49,'VENGEANCE (A31)','VENGEANCE (A31)','Vultee A-31 Vengeance','Dive Bomber','http://en.wikipedia.org/wiki/Vultee_A-31_Vengeance'),(50,'WELL','WELLINGTON','Vickers Wellington','Medium Bomber','http://militaryfactory.com/aircraft/detail.asp?aircraft_id=295'),(51,'WHIT','WHITLEY','Armstrong Whitworth Whitley','Heavy Bomber','http://militaryfactory.com/aircraft/detail.asp?aircraft_id=309'),(52,'Wirraway','Wirraway','CAC Wirraway','Multi-role Aircraft / Trainer','http://militaryfactory.com/aircraft/detail.asp?aircraft_id=846');
/*!40000 ALTER TABLE `dimaircraft` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2018-09-29 20:16:23
