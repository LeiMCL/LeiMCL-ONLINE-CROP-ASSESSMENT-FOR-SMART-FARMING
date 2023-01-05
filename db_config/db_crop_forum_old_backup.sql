-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Sep 18, 2022 at 10:55 AM
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
(22, 1, 17, 'Anti-kuhol katol', 0, '2022-09-18 16:12:27');

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
(21, 20, 1);

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
  `content` varchar(255) NOT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `notifications`
--

INSERT INTO `notifications` (`notification_id`, `user_id`, `content`, `created_at`) VALUES
(63, 1, 'elgin espinoza liked your Post.', '2022-09-18 00:00:00'),
(67, 1, 'elgin espinoza liked your Post.', '2022-09-18 00:00:00'),
(68, 13, 'john doe liked your Post.', '2022-09-18 00:00:00'),
(69, 13, 'john doe liked your Post.', '2022-09-18 00:00:00'),
(71, 1, 'elgin espinoza liked your Comment.', '2022-09-18 00:00:00'),
(72, 1, 'elgin espinoza liked your Comment.', '2022-09-18 00:00:00'),
(73, 1, 'elgin espinoza liked your Comment.', '2022-09-18 00:00:00'),
(74, 13, 'john doe liked your Comment.', '2022-09-18 00:00:00'),
(75, 13, 'john doe commented on your Post.', '2022-09-18 00:00:00'),
(76, 13, 'john doe liked your Post.', '2022-09-18 00:00:00'),
(77, 13, 'john cena liked your Post.', '2022-09-18 00:00:00'),
(78, 13, 'john cena liked your Post.', '2022-09-18 16:47:07');

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
(12, 13, 'Magtanim ay \'di biro.', 3, '2022-09-17 15:41:55'),
(15, 13, 'What kind of soil do you use?', 3, '2022-09-17 15:44:09'),
(16, 1, 'Do you use GMO seeds?', 2, '2022-09-17 16:29:48'),
(17, 13, 'What sprays/pesticides/herbicides do you use?', 2, '2022-09-18 13:03:20');

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
(69, 13, 15),
(81, 13, 12),
(82, 13, 16),
(83, 1, 16),
(84, 1, 15),
(85, 1, 12),
(88, 13, 17),
(89, 1, 17),
(90, 14, 15),
(91, 14, 12);

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
(14, 'john cena', 'cena', 'cena@gmail.com', 'cena123');

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
  ADD KEY `user_id` (`user_id`);

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
  MODIFY `comment_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT for table `comment_likers`
--
ALTER TABLE `comment_likers`
  MODIFY `like_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT for table `notifications`
--
ALTER TABLE `notifications`
  MODIFY `notification_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=79;

--
-- AUTO_INCREMENT for table `posts`
--
ALTER TABLE `posts`
  MODIFY `post_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT for table `post_likers`
--
ALTER TABLE `post_likers`
  MODIFY `like_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=92;

--
-- AUTO_INCREMENT for table `tbl_user`
--
ALTER TABLE `tbl_user`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

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
  ADD CONSTRAINT `notifications_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `tbl_user` (`user_id`);

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
