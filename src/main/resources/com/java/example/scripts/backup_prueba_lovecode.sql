/*M!999999\- enable the sandbox mode */ 
-- MariaDB dump 10.19-11.8.6-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: lovecode
-- ------------------------------------------------------
-- Server version	11.8.6-MariaDB-0+deb13u1 from Debian

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*M!100616 SET @OLD_NOTE_VERBOSITY=@@NOTE_VERBOSITY, NOTE_VERBOSITY=0 */;

--
-- Table structure for table `Likes`
--

DROP TABLE IF EXISTS `Likes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Likes` (
  `id_like` int(11) NOT NULL AUTO_INCREMENT,
  `id_usuario_origen` int(11) NOT NULL,
  `id_usuario_destino` int(11) NOT NULL,
  `fecha_like` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id_like`),
  UNIQUE KEY `uq_like` (`id_usuario_origen`,`id_usuario_destino`),
  KEY `fk_like_destino` (`id_usuario_destino`),
  CONSTRAINT `fk_like_destino` FOREIGN KEY (`id_usuario_destino`) REFERENCES `Usuarios` (`id_usuario`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_like_origen` FOREIGN KEY (`id_usuario_origen`) REFERENCES `Usuarios` (`id_usuario`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Likes`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `Likes` WRITE;
/*!40000 ALTER TABLE `Likes` DISABLE KEYS */;
INSERT INTO `Likes` VALUES
(1,1,2,'2026-04-17 10:21:50'),
(2,2,1,'2026-04-17 10:21:50'),
(3,3,1,'2026-04-17 10:21:50'),
(4,4,5,'2026-04-17 10:21:50'),
(5,5,4,'2026-04-17 10:21:50');
/*!40000 ALTER TABLE `Likes` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `Matches`
--

DROP TABLE IF EXISTS `Matches`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Matches` (
  `id_match` int(11) NOT NULL AUTO_INCREMENT,
  `id_usuario1` int(11) NOT NULL,
  `id_usuario2` int(11) NOT NULL,
  `fecha_match` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id_match`),
  UNIQUE KEY `uq_match` (`id_usuario1`,`id_usuario2`),
  KEY `fk_match_u2` (`id_usuario2`),
  CONSTRAINT `fk_match_u1` FOREIGN KEY (`id_usuario1`) REFERENCES `Usuarios` (`id_usuario`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_match_u2` FOREIGN KEY (`id_usuario2`) REFERENCES `Usuarios` (`id_usuario`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Matches`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `Matches` WRITE;
/*!40000 ALTER TABLE `Matches` DISABLE KEYS */;
/*!40000 ALTER TABLE `Matches` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `Tecnologias`
--

DROP TABLE IF EXISTS `Tecnologias`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Tecnologias` (
  `id_tecnologia` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `categoria` enum('Frontend','Backend','BBDD','DevOps','Mobile','IA','Otro') NOT NULL DEFAULT 'Otro',
  PRIMARY KEY (`id_tecnologia`),
  UNIQUE KEY `nombre` (`nombre`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Tecnologias`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `Tecnologias` WRITE;
/*!40000 ALTER TABLE `Tecnologias` DISABLE KEYS */;
INSERT INTO `Tecnologias` VALUES
(1,'HTML','Frontend'),
(2,'CSS','Frontend'),
(3,'JavaScript','Frontend'),
(4,'React','Frontend'),
(5,'Java','Backend'),
(6,'Spring Boot','Backend'),
(7,'Python','Backend'),
(8,'MySQL','BBDD'),
(9,'PostgreSQL','BBDD'),
(10,'Docker','DevOps'),
(11,'Git','DevOps'),
(12,'TensorFlow','IA');
/*!40000 ALTER TABLE `Tecnologias` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `Usuarios`
--

DROP TABLE IF EXISTS `Usuarios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Usuarios` (
  `id_usuario` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `email` varchar(150) NOT NULL,
  `password` varchar(255) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `foto_url` varchar(500) DEFAULT NULL,
  `ciudad` varchar(100) DEFAULT NULL,
  `fecha_registro` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id_usuario`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Usuarios`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `Usuarios` WRITE;
/*!40000 ALTER TABLE `Usuarios` DISABLE KEYS */;
INSERT INTO `Usuarios` VALUES
(1,'Ana Garcia','ana@lovecode.dev','pass_ana','Apasionada del frontend y el diseno UX.',NULL,'Madrid','2026-04-17 10:21:50'),
(2,'Carlos Ruiz','carlos@lovecode.dev','pass_carlos','Backend developer con amor por los datos.',NULL,'Barcelona','2026-04-17 10:21:50'),
(3,'Lucia Perez','lucia@lovecode.dev','pass_lucia','Fullstack en constante aprendizaje.',NULL,'Valencia','2026-04-17 10:21:50'),
(4,'Marcos Diaz','marcos@lovecode.dev','pass_marcos','DevOps y apasionado de la automatizacion.',NULL,'Sevilla','2026-04-17 10:21:50'),
(5,'Sara Lopez','sara@lovecode.dev','pass_sara','IA y machine learning son mi mundo.',NULL,'Bilbao','2026-04-17 10:21:50');
/*!40000 ALTER TABLE `Usuarios` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `Usuarios_Tecnologias`
--

DROP TABLE IF EXISTS `Usuarios_Tecnologias`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Usuarios_Tecnologias` (
  `id_usuario` int(11) NOT NULL,
  `id_tecnologia` int(11) NOT NULL,
  `nivel` enum('basico','intermedio','avanzado') NOT NULL DEFAULT 'basico',
  PRIMARY KEY (`id_usuario`,`id_tecnologia`),
  KEY `fk_ut_tecnologia` (`id_tecnologia`),
  CONSTRAINT `fk_ut_tecnologia` FOREIGN KEY (`id_tecnologia`) REFERENCES `Tecnologias` (`id_tecnologia`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_ut_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `Usuarios` (`id_usuario`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Usuarios_Tecnologias`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `Usuarios_Tecnologias` WRITE;
/*!40000 ALTER TABLE `Usuarios_Tecnologias` DISABLE KEYS */;
INSERT INTO `Usuarios_Tecnologias` VALUES
(1,1,'avanzado'),
(1,2,'avanzado'),
(1,3,'intermedio'),
(1,4,'intermedio'),
(2,5,'avanzado'),
(2,6,'intermedio'),
(2,8,'avanzado'),
(2,11,'intermedio'),
(3,1,'avanzado'),
(3,3,'avanzado'),
(3,5,'intermedio'),
(3,8,'intermedio'),
(3,11,'avanzado'),
(4,5,'basico'),
(4,10,'avanzado'),
(4,11,'avanzado'),
(5,7,'avanzado'),
(5,9,'intermedio'),
(5,12,'avanzado');
/*!40000 ALTER TABLE `Usuarios_Tecnologias` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*M!100616 SET NOTE_VERBOSITY=@OLD_NOTE_VERBOSITY */;

-- Dump completed on 2026-04-23  8:18:26
