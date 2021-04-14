-- phpMyAdmin SQL Dump
-- version 4.9.2
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3306
-- Generation Time: Apr 07, 2021 at 05:02 AM
-- Server version: 8.0.18
-- PHP Version: 7.3.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `freefood`
--

-- --------------------------------------------------------

--
-- Table structure for table `history`
--

DROP TABLE IF EXISTS `history`;
CREATE TABLE IF NOT EXISTS `history` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `post_id` int(11) NOT NULL,
  `taker` varchar(25) NOT NULL,
  `giver` varchar(25) NOT NULL,
  `food_type` varchar(25) NOT NULL,
  `no_of_people` int(11) NOT NULL,
  `taker_accepted` tinyint(1) NOT NULL DEFAULT '0',
  `otp` int(11) NOT NULL,
  `otp_given` tinyint(1) NOT NULL DEFAULT '0',
  `latitude` float NOT NULL,
  `longitude` float NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;



-- --------------------------------------------------------

--
-- Table structure for table `people`
--

DROP TABLE IF EXISTS `people`;
CREATE TABLE IF NOT EXISTS `people` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(25) NOT NULL,
  `password` varchar(25) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=MyISAM AUTO_INCREMENT=35 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `post`
--

DROP TABLE IF EXISTS `post`;
CREATE TABLE IF NOT EXISTS `post` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `taker` varchar(25) NOT NULL,
  `food_type` varchar(10) NOT NULL DEFAULT 'any',
  `no_of_people` int(11) NOT NULL DEFAULT '1',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `longitude` float NOT NULL,
  `latitude` float NOT NULL,
  `address` varchar(50) NOT NULL,
  `fixed_position` tinyint(1) NOT NULL DEFAULT '1',
  `taker_accepted` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `taker` (`taker`)
) ENGINE=MyISAM AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------
--
-- Table structure for table `relation`
--

DROP TABLE IF EXISTS `relation`;
CREATE TABLE IF NOT EXISTS `relation` (
  `post_id` int(11) NOT NULL,
  `taker` varchar(25) NOT NULL,
  `giver` varchar(25) NOT NULL,
  `food_type` varchar(25) NOT NULL,
  `plate` int(11) NOT NULL,
  `taker_accepted` tinyint(1) NOT NULL,
  `otp_given` tinyint(1) NOT NULL,
  `latitude` float NOT NULL,
  `longitude` float NOT NULL,
  `otp` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  KEY `giver` (`giver`),
  KEY `taker` (`taker`),
  KEY `post_foreign` (`post_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;


--
-- Triggers `relation`
--
DROP TRIGGER IF EXISTS `BeforeRelationEntryDelete`;
DELIMITER $$
CREATE TRIGGER `BeforeRelationEntryDelete` BEFORE DELETE ON `relation` FOR EACH ROW INSERT INTO history( post_id, taker, giver, food_type, no_of_people, taker_accepted, otp, otp_given, latitude, longitude, created_at )
    VALUES(OLD.post_id, OLD.taker, OLD.giver, OLD.food_type, OLD.plate, OLD.taker_accepted ,OLD.otp,OLD.otp_given, OLD.latitude, OLD.longitude, OLD.created_at)
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
CREATE TABLE IF NOT EXISTS `user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(25) NOT NULL,
  `password` varchar(25) NOT NULL,
  `phone` varchar(15) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `longitude` float NOT NULL,
  `latitude` float NOT NULL,
  `address` varchar(50) NOT NULL,
  `given` int(11) NOT NULL DEFAULT '0',
  `taken` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique` (`username`),
  UNIQUE KEY `uniquePhone` (`phone`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;


COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
