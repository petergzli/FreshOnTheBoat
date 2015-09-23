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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `forum_post_flagged`
--

LOCK TABLES `forum_post_flagged` WRITE;
/*!40000 ALTER TABLE `forum_post_flagged` DISABLE KEYS */;
INSERT INTO `forum_post_flagged` VALUES (1,8,2);
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
  `category` int(11) DEFAULT NULL,
  `title` varchar(150) DEFAULT NULL,
  `location` varchar(150) DEFAULT NULL,
  `latitude` float DEFAULT NULL,
  `longitude` float DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `image_url` varchar(150) DEFAULT NULL,
  `forum_post_flagged` int(11) DEFAULT NULL,
  `location_pin_latitude` float DEFAULT NULL,
  `location_pin_longitude` float DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `forum_profile`
--

LOCK TABLES `forum_profile` WRITE;
/*!40000 ALTER TABLE `forum_profile` DISABLE KEYS */;
INSERT INTO `forum_profile` VALUES (1,8,'This is a test post',NULL,'Where is the best chinese food on the west side?','UCLA',34.0687,-118.446,'2015-09-05 11:20:13','910290193102912039abcdes.jpg',NULL,NULL,NULL),(2,8,'This is a test post',NULL,'Where is the best chinese food on the west side?','UCLA',34.0687,-118.446,'2015-09-05 11:22:05','910290193102912039abcdes.jpg',NULL,NULL,NULL),(3,8,'This is a test post',0,'Where is the best chinese food on the west side?','UCLA',34.0687,-118.446,'2015-09-20 11:56:22','910290193102912039abcdes.jpg',NULL,34.0569,-118.446),(4,17,'I want good, but cheap if possible. ',0,'Where are the best oysters in town?','',34.0671,-118.445,'2015-09-20 21:54:06','',NULL,34.1343,-118.026),(5,17,'Wow, hell yeah, this is the coolest shit ever. ',3,'Where\'s teh bes t place to take a date this weekend to bang?','',34.0671,-118.445,'2015-09-23 00:12:22','',NULL,34.0671,-118.445),(6,17,'I\'m just down to meet with some dudes if you wanna pick up some chicas',2,'How about that bugalow bar this weekend? ANyone game for sarging?','',34.0671,-118.445,'2015-09-23 00:15:15','',NULL,34.0245,-118.507);
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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `forum_profile_likes`
--

LOCK TABLES `forum_profile_likes` WRITE;
/*!40000 ALTER TABLE `forum_profile_likes` DISABLE KEYS */;
INSERT INTO `forum_profile_likes` VALUES (1,2,8,1,0);
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
  `replied_to_forum_id` int(11) DEFAULT NULL,
  `location_pin_latitude` float DEFAULT NULL,
  `location_pin_longitude` float DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `forum_profile_postings`
--

LOCK TABLES `forum_profile_postings` WRITE;
/*!40000 ALTER TABLE `forum_profile_postings` DISABLE KEYS */;
INSERT INTO `forum_profile_postings` VALUES (1,2,8,'This is a test post','2015-09-06 11:51:41','910290193102912039abcdes.jpg',NULL,NULL,NULL,NULL),(2,2,8,'This is a test post','2015-09-23 10:42:00','910290193102912039abcdes.jpg',NULL,NULL,NULL,NULL),(3,2,8,'This is a test post','2015-09-23 10:42:47','910290193102912039abcdes.jpg',NULL,NULL,34.0201,-118.011);
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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `forum_profile_postings_flagged`
--

LOCK TABLES `forum_profile_postings_flagged` WRITE;
/*!40000 ALTER TABLE `forum_profile_postings_flagged` DISABLE KEYS */;
INSERT INTO `forum_profile_postings_flagged` VALUES (1,8,1);
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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `forum_profile_postings_likes`
--

LOCK TABLES `forum_profile_postings_likes` WRITE;
/*!40000 ALTER TABLE `forum_profile_postings_likes` DISABLE KEYS */;
INSERT INTO `forum_profile_postings_likes` VALUES (1,1,8,1,0);
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

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(60) DEFAULT NULL,
  `firstname` varchar(60) DEFAULT NULL,
  `lastname` varchar(60) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `encrypted_password` varchar(200) DEFAULT NULL,
  `reset_password_token` varchar(100) DEFAULT NULL,
  `authentication_token` varchar(200) DEFAULT NULL,
  `bio` text,
  `profile_photo` varchar(100) DEFAULT NULL,
  `main_city` varchar(100) DEFAULT NULL,
  `latitude` float DEFAULT NULL,
  `longitude` float DEFAULT NULL,
  `user_flagged` int(11) DEFAULT NULL,
  `device_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (8,'callmemaybe','Carly','Jepsen',NULL,'$6$rounds=667328$gme0ImomJkAO4w2e$m6ssXSLEpkRaXrdLc821o8Rv72O0GNYH9AsUV4cDtarNE7l13Ka/MXo0qDDKKzNsHew79sLDmfuNTa.ZtHD9P1',NULL,'eyJhbGciOiJIUzI1NiIsImV4cCI6MTQ0Mjc5ODQwMywiaWF0IjoxNDQyNzk3ODAzfQ.eyJpZCI6OH0.P-uzuOFGMAk6ogriQmcxtdieRUnN_9WKeptiyjvaI_k',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(9,'callbaby','Carly','Jepsen',NULL,'$6$rounds=615223$ynizOb8u2ADRmMT0$xECOzv8oMlvdX5WE.JvAx0Z/AP0.XSeb2ERFdznTMrC6UipfGe1lK6qH5NMfYtymKHQXdYPzYDQ.wc3XNSuK3/',NULL,'eyJhbGciOiJIUzI1NiIsImV4cCI6MTQ0MjU5NTYxNywiaWF0IjoxNDQyNTk1MDE3fQ.eyJpZCI6OX0.WRlS1q6exO1200HWoWjhcHb3fgHbJ-6IaqZETxx8QkE',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(10,'peteypie','','','peteypie@gmail.com','$6$rounds=635314$B4AwNdzX9tqFPiKu$fbg8hA44rgmBl/JEiJT.95VRUNqcWwLrwbwrxnMQiZpAHhUPp7pBRYKIiRNqxIIaW4xr0byE/u37W1uDHyd171',NULL,'eyJhbGciOiJIUzI1NiIsImV4cCI6MTQ0MjY1MTU0MCwiaWF0IjoxNDQyNjUwOTQwfQ.eyJpZCI6MTB9.uUaCkhFXz4tl86QjmvMtO-b_3u0iJMoh-tY8pwxsz04',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(11,'tester12','','','tester@gmail.com','$6$rounds=664976$BuzVfX0Jo4vwNZJV$csXxvRiW4FW4L94HXWzMwVNNYgT9CuA7PjMkxIqFlO8hvJdoUML9MWegVzNBmzppJO9SJdDQQETJJQr8Xip/20',NULL,'eyJhbGciOiJIUzI1NiIsImV4cCI6MTQ0MjY1MjIwNywiaWF0IjoxNDQyNjUxNjA3fQ.eyJpZCI6MTF9.-NlT2ZjcthqoOidzbFGOg989eadlUpEXW6-gQsXQUj4',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(12,'peteypiper','','','peteypiper@gmail.com','$6$rounds=694784$rR7C8Zo99CI3S6Ds$KFilJzMmaG3KR.7v5hTcHxaTpP2PbxuqHGWDGpBem5K7uqQGkRFTFyWRj9EUPzImKqX1V0.cTxXwd.Diiimjp1',NULL,'eyJhbGciOiJIUzI1NiIsImV4cCI6MTQ0MjY4MjQ1NSwiaWF0IjoxNDQyNjgxODU1fQ.eyJpZCI6MTJ9.NiCVxsikZniEFcYh3xn2j593hGySYWXhRP_KCSn3rcQ',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(13,'tester69','','','tester69@gmail.com','$6$rounds=639284$09Rvj9ILoqrzEDv0$0j7QQ8ZrlgmfUsYimRlPbFUGHffWQ1zGJJ63mZidz120A6Mwbf/8I/H8YZnD43BnmiFddRnULFtlRVDe1LMSI.',NULL,'eyJhbGciOiJIUzI1NiIsImV4cCI6MTQ0MjY4Mjk3MywiaWF0IjoxNDQyNjgyMzczfQ.eyJpZCI6MTN9.Vqt7vJUwFBBBXTLYyWkmuZdIohEChaCSIppwuBIxUxE',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(14,'tester70','','','tester70@gmail.com','$6$rounds=662841$F4lhFL0AnK4o5Kmn$FC/0AmkEb5bu5UyEvS0kfmXSmiFs8co3lOhP5rw5oTz1aKNOj9CZYJD3gYqemSTFWpBOnu7nTlTBpld7ddC2//',NULL,'eyJhbGciOiJIUzI1NiIsImV4cCI6MTQ0MjY4MzA4MiwiaWF0IjoxNDQyNjgyNDgyfQ.eyJpZCI6MTR9.Uo-eHAngr4hEMuQVrXFDojk3UOACuVD2iBckHaCaDVE',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(15,'tester71','','','tester71@gmail.com','$6$rounds=619666$/OCKlPhpRdhGk1yn$9bg9iDmystQOwdMjw6/WyTt/ZQbr2noTc6UFlzjuvjoMjheE18LeYwQclb1lCP.iz.Z4x9HGeS/2YZ4ixvLbS1',NULL,'eyJhbGciOiJIUzI1NiIsImV4cCI6MTQ0MjY4MzM3OSwiaWF0IjoxNDQyNjgyNzc5fQ.eyJpZCI6MTV9.VaVrYrh7OttfDnQQoS3PZYMTbxiJEnPXH4CRCNp1yZs',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(16,'tester80','','','tester80@gmail.com','$6$rounds=621913$KL9bRYUDqnccDmU0$ENoqqm0NPNek0QfQScesrlKzp.X5mXV5IviERp0lQ/HDh0WEWULwxp2zICONo7Vda26EI4dItyilQZkP5HS/H0',NULL,'eyJhbGciOiJIUzI1NiIsImV4cCI6MTQ0MjY4MzUxMywiaWF0IjoxNDQyNjgyOTEzfQ.eyJpZCI6MTZ9.K8td-JaJQdBk7zeFh2SyWhc6gRINcYY0Ih8ksjORi7c',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(17,'token','','','token@gmail.com','$6$rounds=591768$/LKOodWuddSi0WEr$yTRZcYKFyhqFddRWgbUtvTHvdmyfU66ul7xvHbD5o.QeB9dl0G.Xl4d9.bhpuuj.THW87L7zqwN8UcUB52vi8/',NULL,'eyJhbGciOiJIUzI1NiIsImV4cCI6MTQ0Mjk5MjkzOCwiaWF0IjoxNDQyOTkyMzM4fQ.eyJpZCI6MTd9.ZE5rxBBi9jrr0vZL7e4XYhQ3n90VXziCZJFpN4KHjmE',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(18,'pufferton','','','pufferton@gmail.com','$6$rounds=597523$VujxNMXXI/wVDk.s$lQa/rOCFM9Jw9kZV.x0ZTrhjrnJY38QjyR.t/w7oe2LoL8i7RSSwaM.mjR5AuyG.sSvWDVv790mDwDJEM/xKV.',NULL,'eyJhbGciOiJIUzI1NiIsImV4cCI6MTQ0Mjc3NTEyNiwiaWF0IjoxNDQyNzc0NTI2fQ.eyJpZCI6MTh9.ceoQJuEc4JMtDrB5UkNQV8Drzj0HdxvNwvp7XrDnRfo',NULL,NULL,NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2015-09-23 10:44:38
