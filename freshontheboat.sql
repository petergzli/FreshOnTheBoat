-- MySQL dump 10.13  Distrib 5.6.26, for osx10.10 (x86_64)
--
-- Host: localhost    Database: FreshOnTheBoat
-- ------------------------------------------------------
-- Server version	5.6.26

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
-- Table structure for table `USERS`
--

DROP TABLE IF EXISTS `USERS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `USERS` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(60) DEFAULT NULL,
  `firstname` varchar(60) DEFAULT NULL,
  `lastname` varchar(60) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `encrypted_password` varchar(100) DEFAULT NULL,
  `reset_password_token` varchar(100) DEFAULT NULL,
  `authentication_token` varchar(100) DEFAULT NULL,
  `bio` text,
  `profile_photo` varchar(100) DEFAULT NULL,
  `main_city` varchar(100) DEFAULT NULL,
  `latitude` float DEFAULT NULL,
  `longitude` float DEFAULT NULL,
  `user_flagged` int(11) DEFAULT NULL,
  `device_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `USERS`
--

LOCK TABLES `USERS` WRITE;
/*!40000 ALTER TABLE `USERS` DISABLE KEYS */;
/*!40000 ALTER TABLE `USERS` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `forum_post_flagged`
--

DROP TABLE IF EXISTS `forum_post_flagged`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `forum_post_flagged` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_who_flagged` int(11) DEFAULT NULL,
  `forum_profile_flagged_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `forum_post_flagged`
--

LOCK TABLES `forum_post_flagged` WRITE;
/*!40000 ALTER TABLE `forum_post_flagged` DISABLE KEYS */;
/*!40000 ALTER TABLE `forum_post_flagged` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `forum_profile`
--

DROP TABLE IF EXISTS `forum_profile`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `forum_profile` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created_by` int(11) DEFAULT NULL,
  `description` text,
  `category` varchar(100) DEFAULT NULL,
  `title` varchar(150) DEFAULT NULL,
  `location` varchar(150) DEFAULT NULL,
  `latitude` float DEFAULT NULL,
  `longitude` float DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `image_url` varchar(150) DEFAULT NULL,
  `forum_post_flagged` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `forum_profile`
--

LOCK TABLES `forum_profile` WRITE;
/*!40000 ALTER TABLE `forum_profile` DISABLE KEYS */;
/*!40000 ALTER TABLE `forum_profile` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `forum_profile_likes`
--

DROP TABLE IF EXISTS `forum_profile_likes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `forum_profile_likes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `forum_profile_id` int(11) DEFAULT NULL,
  `user_who_liked` int(11) DEFAULT NULL,
  `likes` int(11) DEFAULT NULL,
  `dislikes` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `forum_profile_likes`
--

LOCK TABLES `forum_profile_likes` WRITE;
/*!40000 ALTER TABLE `forum_profile_likes` DISABLE KEYS */;
/*!40000 ALTER TABLE `forum_profile_likes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `forum_profile_photo_album_photos`
--

DROP TABLE IF EXISTS `forum_profile_photo_album_photos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `forum_profile_photo_album_photos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `poster_id` int(11) DEFAULT NULL,
  `forum_profile_id` int(11) DEFAULT NULL,
  `image_url` varchar(150) DEFAULT NULL,
  `photo_flagged` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `forum_profile_photo_album_photos`
--

LOCK TABLES `forum_profile_photo_album_photos` WRITE;
/*!40000 ALTER TABLE `forum_profile_photo_album_photos` DISABLE KEYS */;
/*!40000 ALTER TABLE `forum_profile_photo_album_photos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `forum_profile_postings`
--

DROP TABLE IF EXISTS `forum_profile_postings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `forum_profile_postings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `forum_id` int(11) DEFAULT NULL,
  `poster_id` int(11) DEFAULT NULL,
  `body` text,
  `created_at` datetime DEFAULT NULL,
  `image_url` varchar(150) DEFAULT NULL,
  `comment_flagged` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `forum_profile_postings`
--

LOCK TABLES `forum_profile_postings` WRITE;
/*!40000 ALTER TABLE `forum_profile_postings` DISABLE KEYS */;
/*!40000 ALTER TABLE `forum_profile_postings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `forum_profile_postings_flagged`
--

DROP TABLE IF EXISTS `forum_profile_postings_flagged`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `forum_profile_postings_flagged` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_who_flagged` int(11) DEFAULT NULL,
  `forum_profile_flagged_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `forum_profile_postings_flagged`
--

LOCK TABLES `forum_profile_postings_flagged` WRITE;
/*!40000 ALTER TABLE `forum_profile_postings_flagged` DISABLE KEYS */;
/*!40000 ALTER TABLE `forum_profile_postings_flagged` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `forum_profile_postings_likes`
--

DROP TABLE IF EXISTS `forum_profile_postings_likes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `forum_profile_postings_likes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `forum_profile_posting_id` int(11) DEFAULT NULL,
  `user_who_liked` int(11) DEFAULT NULL,
  `likes` int(11) DEFAULT NULL,
  `dislikes` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `forum_profile_postings_likes`
--

LOCK TABLES `forum_profile_postings_likes` WRITE;
/*!40000 ALTER TABLE `forum_profile_postings_likes` DISABLE KEYS */;
/*!40000 ALTER TABLE `forum_profile_postings_likes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_checked_in`
--

DROP TABLE IF EXISTS `user_checked_in`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_checked_in` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_who_checked_in_id` int(11) DEFAULT NULL,
  `checked_into_forum_profile_id` int(11) DEFAULT NULL,
  `time_checked_in` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_checked_in`
--

LOCK TABLES `user_checked_in` WRITE;
/*!40000 ALTER TABLE `user_checked_in` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_checked_in` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2015-09-01 20:49:22
