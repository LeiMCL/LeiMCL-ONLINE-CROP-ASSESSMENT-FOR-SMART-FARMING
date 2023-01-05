-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Dec 03, 2022 at 07:26 AM
-- Server version: 10.4.22-MariaDB
-- PHP Version: 8.1.2

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `db_crop_forum`
--
DROP DATABASE IF EXISTS db_crop_forum;
CREATE DATABASE IF NOT EXISTS `db_crop_forum` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `db_crop_forum`;

-- --------------------------------------------------------

--
-- Table structure for table `comments`
--

CREATE TABLE `comments` (
  `comment_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `post_id` int(11) NOT NULL,
  `content` varchar(255) NOT NULL,
  `like_count` int(11) DEFAULT 0,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `comments`
--

INSERT INTO `comments` (`comment_id`, `user_id`, `post_id`, `content`, `like_count`, `created_at`) VALUES
(7, 1, 12, 'Hello!', 1, '2022-09-17 18:32:33'),
(8, 1, 12, 'Tae!', 1, '2022-09-17 18:36:00'),
(9, 1, 15, 'Hoy!', 1, '2022-09-17 20:02:15'),
(10, 1, 15, 'Hoy hoy!', 1, '2022-09-17 20:03:29'),
(14, 13, 12, 'Hi!', 1, '2022-09-18 12:05:04'),
(20, 13, 17, 'Up!', 1, '2022-09-18 13:39:55'),
(22, 1, 17, 'Anti-kuhol katol', 0, '2022-09-18 16:12:27'),
(23, 13, 17, 'Test', 0, '2022-12-03 09:20:11'),
(24, 13, 17, 'Test2', 0, '2022-12-03 09:23:14'),
(25, 13, 17, 'Test2', 0, '2022-12-03 09:23:15'),
(26, 13, 17, 'Test3', 0, '2022-12-03 09:23:58'),
(37, 1, 21, 'Doing Good.', 1, '2022-12-03 13:13:11'),
(38, 15, 21, 'Need help!', 1, '2022-12-03 13:16:44'),
(39, 1, 16, 'Any update please.', 1, '2022-12-03 13:17:27');

-- --------------------------------------------------------

--
-- Table structure for table `comment_likers`
--

CREATE TABLE `comment_likers` (
  `like_id` int(11) NOT NULL,
  `comment_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `comment_likers`
--

INSERT INTO `comment_likers` (`like_id`, `comment_id`, `user_id`) VALUES
(15, 7, 13),
(17, 14, 13),
(18, 8, 13),
(19, 9, 13),
(20, 10, 13),
(21, 20, 1),
(57, 37, 13),
(58, 38, 13),
(59, 39, 15);

--
-- Triggers `comment_likers`
--
DELIMITER $$
CREATE TRIGGER `when_user_like_comment` BEFORE INSERT ON `comment_likers` FOR EACH ROW UPDATE `comments` SET `comments`.`like_count` = `comments`.`like_count`+1
WHERE `comments`.`comment_id` = NEW.comment_id
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `when_user_unlike_comment` BEFORE DELETE ON `comment_likers` FOR EACH ROW UPDATE `comments` SET `comments`.`like_count` = `comments`.`like_count`-1
WHERE `comments`.`comment_id` = OLD.comment_id
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `notifications`
--

CREATE TABLE `notifications` (
  `notification_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `post_id` int(11) DEFAULT NULL,
  `content` varchar(255) NOT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `notifications`
--

INSERT INTO `notifications` (`notification_id`, `user_id`, `post_id`, `content`, `created_at`) VALUES
(1, 13, 17, 'john doe liked your Post.', '2022-12-03 11:43:37'),
(2, 13, 12, 'john doe liked your Post.', '2022-12-03 11:57:44'),
(6, 1, 16, 'elgin espinoza liked your Post.', '2022-12-03 13:01:25'),
(14, 13, 21, 'john doe liked your Post.', '2022-12-03 13:13:06'),
(15, 13, 21, 'test liked your Post.', '2022-12-03 13:16:29'),
(16, 1, 16, 'test liked your Post.', '2022-12-03 13:16:32');

-- --------------------------------------------------------

--
-- Table structure for table `posts`
--

CREATE TABLE `posts` (
  `post_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `content` varchar(255) NOT NULL,
  `like_count` int(11) DEFAULT 0,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `posts`
--

INSERT INTO `posts` (`post_id`, `user_id`, `content`, `like_count`, `created_at`) VALUES
(12, 13, 'Magtanim ay \'di biro.', 2, '2022-09-17 15:41:55'),
(15, 13, 'What kind of soil do you use?', 2, '2022-09-17 15:44:09'),
(16, 1, 'Do you use GMO seeds?', 3, '2022-09-17 16:29:48'),
(17, 13, 'What sprays/pesticides/herbicides do you use?', 1, '2022-09-18 13:03:20'),
(21, 13, 'How was the Harvest fellow farmers?', 2, '2022-12-03 13:12:49'),
(22, 15, 'New Here!', 0, '2022-12-03 13:20:02');

-- --------------------------------------------------------

--
-- Table structure for table `post_likers`
--

CREATE TABLE `post_likers` (
  `like_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `post_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `post_likers`
--

INSERT INTO `post_likers` (`like_id`, `user_id`, `post_id`) VALUES
(84, 1, 15),
(90, 14, 15),
(91, 14, 12),
(112, 1, 17),
(113, 1, 12),
(114, 13, 16),
(115, 1, 16),
(116, 1, 21),
(117, 15, 21),
(118, 15, 16);

--
-- Triggers `post_likers`
--
DELIMITER $$
CREATE TRIGGER `when_user_like` BEFORE INSERT ON `post_likers` FOR EACH ROW UPDATE `posts`
SET `like_count` = `like_count`+1 WHERE
`posts`.`post_id` = NEW.post_id
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `when_user_unlike` BEFORE DELETE ON `post_likers` FOR EACH ROW UPDATE `posts` SET `posts`.`like_count` = `posts`.`like_count`-1
WHERE `posts`.`post_id` = OLD.post_id
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_user`
--

CREATE TABLE `tbl_user` (
  `user_id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `username` varchar(50) NOT NULL,
  `email` varchar(50) NOT NULL,
  `password` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `tbl_user`
--

INSERT INTO `tbl_user` (`user_id`, `name`, `username`, `email`, `password`) VALUES
(1, 'john doe', 'john', 'john@gmail.com', 'john123'),
(13, 'elgin espinoza', 'elgin', 'elgin@gmail.com', 'elgin123'),
(14, 'john cena', 'cena', 'cena@gmail.com', 'cena123'),
(15, 'test', 'test', 'test@mail.com', 'test123');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `comments`
--
ALTER TABLE `comments`
  ADD PRIMARY KEY (`comment_id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `post_id` (`post_id`);

--
-- Indexes for table `comment_likers`
--
ALTER TABLE `comment_likers`
  ADD PRIMARY KEY (`like_id`),
  ADD KEY `comment_id` (`comment_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `notifications`
--
ALTER TABLE `notifications`
  ADD PRIMARY KEY (`notification_id`),
  ADD KEY `fk_notification_user` (`user_id`),
  ADD KEY `fk_notification_post` (`post_id`);

--
-- Indexes for table `posts`
--
ALTER TABLE `posts`
  ADD PRIMARY KEY (`post_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `post_likers`
--
ALTER TABLE `post_likers`
  ADD PRIMARY KEY (`like_id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `post_likers_ibfk_2` (`post_id`);

--
-- Indexes for table `tbl_user`
--
ALTER TABLE `tbl_user`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `username_email_unique` (`username`,`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `comments`
--
ALTER TABLE `comments`
  MODIFY `comment_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=40;

--
-- AUTO_INCREMENT for table `comment_likers`
--
ALTER TABLE `comment_likers`
  MODIFY `like_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=60;

--
-- AUTO_INCREMENT for table `notifications`
--
ALTER TABLE `notifications`
  MODIFY `notification_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT for table `posts`
--
ALTER TABLE `posts`
  MODIFY `post_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT for table `post_likers`
--
ALTER TABLE `post_likers`
  MODIFY `like_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=119;

--
-- AUTO_INCREMENT for table `tbl_user`
--
ALTER TABLE `tbl_user`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `comments`
--
ALTER TABLE `comments`
  ADD CONSTRAINT `comments_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `tbl_user` (`user_id`),
  ADD CONSTRAINT `post_id` FOREIGN KEY (`post_id`) REFERENCES `posts` (`post_id`) ON DELETE CASCADE;

--
-- Constraints for table `comment_likers`
--
ALTER TABLE `comment_likers`
  ADD CONSTRAINT `comment_likers_ibfk_1` FOREIGN KEY (`comment_id`) REFERENCES `comments` (`comment_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `comment_likers_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `tbl_user` (`user_id`);

--
-- Constraints for table `notifications`
--
ALTER TABLE `notifications`
  ADD CONSTRAINT `fk_notification_post` FOREIGN KEY (`post_id`) REFERENCES `posts` (`post_id`),
  ADD CONSTRAINT `fk_notification_user` FOREIGN KEY (`user_id`) REFERENCES `tbl_user` (`user_id`);

--
-- Constraints for table `posts`
--
ALTER TABLE `posts`
  ADD CONSTRAINT `posts_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `tbl_user` (`user_id`);

--
-- Constraints for table `post_likers`
--
ALTER TABLE `post_likers`
  ADD CONSTRAINT `post_likers_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `tbl_user` (`user_id`),
  ADD CONSTRAINT `post_likers_ibfk_2` FOREIGN KEY (`post_id`) REFERENCES `posts` (`post_id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
