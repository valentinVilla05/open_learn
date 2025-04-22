-- phpMyAdmin SQL Dump
-- version 5.2.1deb3
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Apr 21, 2025 at 08:51 PM
-- Server version: 8.0.41-0ubuntu0.24.04.1
-- PHP Version: 8.3.6

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `open_learn`
--

-- --------------------------------------------------------

--
-- Table structure for table `califications`
--

CREATE TABLE `califications` (
  `id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `exam_id` bigint UNSIGNED NOT NULL,
  `calification` double DEFAULT NULL,
  `attempted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `califications`
--

INSERT INTO `califications` (`id`, `user_id`, `exam_id`, `calification`, `attempted_at`, `created_at`, `updated_at`) VALUES
(1, 15, 3, 2.69, '2025-01-16 22:42:12', '2025-04-18 17:13:07', '2025-04-18 17:13:07'),
(2, 10, 5, 1.45, '2024-05-09 21:20:52', '2025-04-18 17:13:07', '2025-04-18 17:13:07'),
(3, 11, 5, 6, '2024-07-20 05:27:19', '2025-04-18 17:13:07', '2025-04-18 17:13:07'),
(4, 14, 3, 3.42, '2024-11-12 09:54:03', '2025-04-18 17:13:07', '2025-04-18 17:13:07'),
(5, 8, 5, 3.51, '2024-06-11 16:21:25', '2025-04-18 17:13:07', '2025-04-18 17:13:07'),
(7, 2, 3, 3.03, '2024-10-23 18:18:21', '2025-04-18 17:13:07', '2025-04-18 17:13:07'),
(8, 13, 7, 4.75, '2025-01-27 05:48:38', '2025-04-18 17:13:07', '2025-04-18 17:13:07'),
(9, 8, 4, 3.2, '2024-10-24 18:13:27', '2025-04-18 17:13:07', '2025-04-18 17:13:07');

-- --------------------------------------------------------

--
-- Table structure for table `certificates`
--

CREATE TABLE `certificates` (
  `id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `course_id` bigint UNSIGNED NOT NULL,
  `ending_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `certificate_code` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `certificates`
--

INSERT INTO `certificates` (`id`, `user_id`, `course_id`, `ending_date`, `certificate_code`, `created_at`, `updated_at`) VALUES
(1, 11, 1, '2024-11-03 15:24:21', 'CERT-43xo11ne09xa', '2025-04-18 17:13:07', '2025-04-18 17:13:07'),
(2, 10, 2, '2024-11-20 18:17:16', 'CERT-53mt05ep43mt', '2025-04-18 17:13:07', '2025-04-18 17:13:07'),
(4, 14, 4, '2024-09-19 01:50:10', 'CERT-34ib56xj68ve', '2025-04-18 17:13:07', '2025-04-18 17:13:07'),
(6, 7, 6, '2024-05-12 22:25:36', 'CERT-08ym07vu85xi', '2025-04-18 17:13:07', '2025-04-18 17:13:07'),
(7, 8, 7, '2024-06-20 08:03:59', 'CERT-69xu26ie93kp', '2025-04-18 17:13:07', '2025-04-18 17:13:07'),
(8, 17, 8, '2024-09-23 02:02:26', 'CERT-90pz29su19ip', '2025-04-18 17:13:07', '2025-04-18 17:13:07'),
(9, 10, 9, '2025-01-07 21:00:39', 'CERT-69wu92az82kk', '2025-04-18 17:13:07', '2025-04-18 17:13:07');

-- --------------------------------------------------------

--
-- Table structure for table `comments`
--

CREATE TABLE `comments` (
  `id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `resource_id` bigint UNSIGNED NOT NULL,
  `response_id` bigint UNSIGNED DEFAULT NULL,
  `comment` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `comments`
--

INSERT INTO `comments` (`id`, `user_id`, `resource_id`, `response_id`, `comment`, `created_at`, `updated_at`) VALUES
(5, 8, 30, NULL, 'Quis quas soluta odio et et id qui.', '2025-04-18 17:13:07', '2025-04-18 17:13:07'),
(8, 3, 20, NULL, 'Quia voluptatem consequatur deleniti sed alias magnam reiciendis cupiditate non non repellat veritatis cum.', '2025-04-18 17:13:07', '2025-04-18 17:13:07'),
(10, 7, 10, NULL, 'Nulla repellat nobis perspiciatis magni mollitia ea ab recusandae perspiciatis exercitationem quo tempore laudantium.', '2025-04-18 17:13:07', '2025-04-18 17:13:07'),
(11, 2, 25, NULL, 'Officiis eaque sed quia facere quod maiores deserunt totam eum soluta.', '2025-04-18 17:13:07', '2025-04-18 17:13:07'),
(12, 5, 45, NULL, 'Quia sequi enim unde ut facilis qui earum vel.', '2025-04-18 17:13:07', '2025-04-18 17:13:07'),
(14, 9, 16, NULL, 'Aspernatur et nesciunt et voluptas eaque beatae omnis vel similique reprehenderit voluptate hic deserunt ipsum.', '2025-04-18 17:13:07', '2025-04-18 17:13:07'),
(17, 9, 44, NULL, 'Id nobis ut assumenda dolorem excepturi nihil quos est.', '2025-04-18 17:13:07', '2025-04-18 17:13:07'),
(18, 14, 29, NULL, 'Amet nulla illum modi quibusdam vero et provident autem eveniet.', '2025-04-18 17:13:07', '2025-04-18 17:13:07'),
(19, 11, 2, 10, 'Autem repellat repudiandae voluptatem est recusandae alias ex laudantium aut debitis eum.', '2025-04-18 17:13:07', '2025-04-18 17:13:07');

-- --------------------------------------------------------

--
-- Table structure for table `courses`
--

CREATE TABLE `courses` (
  `id` bigint UNSIGNED NOT NULL,
  `teacher_id` bigint UNSIGNED NOT NULL,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `privacy` enum('private','public') COLLATE utf8mb4_unicode_ci NOT NULL,
  `image` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `max_students` int UNSIGNED NOT NULL DEFAULT '0',
  `subject` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `duration` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `courses`
--

INSERT INTO `courses` (`id`, `teacher_id`, `title`, `description`, `privacy`, `image`, `max_students`, `subject`, `duration`, `created_at`, `updated_at`) VALUES
(1, 3, 'Magnam cupiditate.', 'Animi molestiae molestiae non perferendis amet vitae eligendi similique. Quae dolorum ut sapiente molestias. Rerum aut laudantium vero qui ut voluptatum. Aut quo nesciunt qui. Fuga ratione et possimus.', 'public', 'https://via.placeholder.com/640x480.png/00cc00?text=doloremque', 23, 'quo', '10 horas', '2025-04-18 17:13:06', '2025-04-18 17:13:06'),
(2, 5, 'Quia modi.', 'Natus velit est sint maiores. Ut maxime cupiditate consequatur dolor quia debitis rerum sint. Recusandae assumenda ea voluptatem quo dolorum. Ipsam ea magni ex quam cum dolorum.', 'private', 'https://via.placeholder.com/640x480.png/003355?text=omnis', 41, 'sed', '10 horas', '2025-04-18 17:13:06', '2025-04-18 17:13:06'),
(4, 4, 'Veritatis et illum.', 'Excepturi ea impedit officiis dolorem. Non magnam rerum et quas sunt. Eos quisquam reprehenderit ratione qui magni qui eveniet. Itaque et natus praesentium magnam earum rerum. Sint dignissimos mollitia veritatis optio at.', 'private', 'https://via.placeholder.com/640x480.png/00bb88?text=voluptas', 32, 'vero', '30 horas', '2025-04-18 17:13:06', '2025-04-18 17:13:06'),
(6, 2, 'Occaecati assumenda.', 'Qui est facilis modi consequuntur sed. Ut ut quae ullam facere quae. Perferendis libero veniam ducimus quam cumque.', 'private', 'https://via.placeholder.com/640x480.png/002255?text=non', 29, 'deleniti', '10 horas', '2025-04-18 17:13:06', '2025-04-18 17:13:06'),
(7, 5, 'Nesciunt magni qui.', 'Aut et corporis itaque sit ipsa eligendi. Vel qui aut et placeat qui. Expedita labore ut officiis vel animi.', 'public', 'https://via.placeholder.com/640x480.png/008822?text=quia', 44, 'expedita', '30 horas', '2025-04-18 17:13:06', '2025-04-18 17:13:06'),
(8, 2, 'Quae ratione est.', 'Quo voluptatibus ratione non nesciunt iusto dolor tenetur. Nemo in minus voluptates officiis consectetur possimus dolorem. Dolorem non ullam et ut voluptas. Neque fuga commodi quos provident est.', 'private', 'https://via.placeholder.com/640x480.png/00bbaa?text=ab', 69, 'suscipit', '10 horas', '2025-04-18 17:13:06', '2025-04-18 17:13:06'),
(9, 5, 'Laudantium distinctio aliquid.', 'Soluta culpa architecto voluptatum. Sed tempore molestiae adipisci voluptas aut dolores. Sint ipsum officiis est illum blanditiis distinctio enim. Repellat dicta aperiam consectetur sint sint ex aut dolor.', 'private', 'https://via.placeholder.com/640x480.png/00eebb?text=adipisci', 86, 'dolore', '10 horas', '2025-04-18 17:13:06', '2025-04-18 17:13:06'),
(12, 1, 'Introducción a Laravel', 'Aprende los fundamentos de Laravel, el framework PHP más popular.', 'public', 'https://example.com/images/laravel-course.jpg', 100, 'Programación Web', '6 semanas', '2025-04-20 07:42:30', '2025-04-20 07:42:30');

-- --------------------------------------------------------

--
-- Table structure for table `exams`
--

CREATE TABLE `exams` (
  `id` bigint UNSIGNED NOT NULL,
  `course_id` bigint UNSIGNED NOT NULL,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `exams`
--

INSERT INTO `exams` (`id`, `course_id`, `title`, `is_active`, `created_at`, `updated_at`) VALUES
(3, 6, 'Totam quaerat quia.', 1, '2025-04-18 17:13:06', '2025-04-18 17:13:06'),
(4, 7, 'Culpa est.', 0, '2025-04-18 17:13:06', '2025-04-18 17:13:06'),
(5, 8, 'Non eos et ad.', 1, '2025-04-18 17:13:06', '2025-04-18 17:13:06'),
(7, 7, 'Hic est.', 1, '2025-04-18 17:13:06', '2025-04-18 17:13:06'),
(8, 4, 'Et aut placeat ut.', 1, '2025-04-18 17:13:06', '2025-04-18 17:13:06'),
(9, 8, 'Esse labore et.', 1, '2025-04-18 17:13:06', '2025-04-18 17:13:06'),
(10, 9, 'Enim accusantium aliquam sit.', 0, '2025-04-18 17:13:06', '2025-04-18 17:13:06');

-- --------------------------------------------------------

--
-- Table structure for table `inscriptions`
--

CREATE TABLE `inscriptions` (
  `id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `course_id` bigint UNSIGNED NOT NULL,
  `inscription_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `inscriptions`
--

INSERT INTO `inscriptions` (`id`, `user_id`, `course_id`, `inscription_date`, `created_at`, `updated_at`) VALUES
(2, 16, 9, '2025-04-18 17:13:06', '2025-04-18 17:13:06', '2025-04-18 17:13:06'),
(3, 7, 2, '2025-04-18 17:13:06', '2025-04-18 17:13:06', '2025-04-18 17:13:06'),
(4, 1, 9, '2025-04-18 17:13:06', '2025-04-18 17:13:06', '2025-04-18 17:13:06'),
(5, 2, 1, '2025-04-18 17:13:06', '2025-04-18 17:13:06', '2025-04-18 17:13:06'),
(10, 10, 2, '2025-04-18 17:13:06', '2025-04-18 17:13:06', '2025-04-18 17:13:06'),
(11, 9, 9, '2025-04-18 17:13:06', '2025-04-18 17:13:06', '2025-04-18 17:13:06'),
(12, 18, 1, '2025-04-18 17:13:06', '2025-04-18 17:13:06', '2025-04-18 17:13:06'),
(13, 11, 7, '2025-04-18 17:13:06', '2025-04-18 17:13:06', '2025-04-18 17:13:06'),
(14, 16, 8, '2025-04-18 17:13:06', '2025-04-18 17:13:06', '2025-04-18 17:13:06'),
(15, 20, 6, '2025-04-18 17:13:06', '2025-04-18 17:13:06', '2025-04-18 17:13:06'),
(18, 2, 7, '2025-04-18 17:13:06', '2025-04-18 17:13:06', '2025-04-18 17:13:06'),
(20, 8, 2, '2025-04-18 17:13:06', '2025-04-18 17:13:06', '2025-04-18 17:13:06');

-- --------------------------------------------------------

--
-- Table structure for table `migrations`
--

CREATE TABLE `migrations` (
  `id` int UNSIGNED NOT NULL,
  `migration` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `batch` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '0001_01_01_000000_create_users_table', 1),
(2, '2025_04_04_174250_create_courses_table', 1),
(3, '2025_04_04_174307_create_resources_table', 1),
(4, '2025_04_04_174314_create_inscriptions_table', 1),
(5, '2025_04_04_174321_create_comments_table', 1),
(6, '2025_04_04_174332_create_certificates_table', 1),
(7, '2025_04_06_105841_create_personal_access_tokens_table', 1),
(8, '2025_04_09_133209_create_exams_table', 1),
(9, '2025_04_09_133213_create_questions_table', 1),
(10, '2025_04_09_133219_create_califications_table', 1),
(11, '2025_04_12_110746_create_user_tests_table', 1);

-- --------------------------------------------------------

--
-- Table structure for table `personal_access_tokens`
--

CREATE TABLE `personal_access_tokens` (
  `id` bigint UNSIGNED NOT NULL,
  `tokenable_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `tokenable_id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `abilities` text COLLATE utf8mb4_unicode_ci,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `personal_access_tokens`
--

INSERT INTO `personal_access_tokens` (`id`, `tokenable_type`, `tokenable_id`, `name`, `token`, `abilities`, `last_used_at`, `expires_at`, `created_at`, `updated_at`) VALUES
(1, 'App\\Models\\User', 1, 'auth_token', '5c13b9cb5d00b9594b3c1b35142289a031a10ac49248a2e14cff98e6695a0d0b', '[\"*\"]', '2025-04-20 07:42:30', NULL, '2025-04-19 13:23:38', '2025-04-20 07:42:30'),
(2, 'App\\Models\\User', 1, 'auth_token', '9706545b234446da0f68238a68f7e29db271fd013ef0d169167686298b7b324d', '[\"*\"]', NULL, NULL, '2025-04-20 09:54:04', '2025-04-20 09:54:04');

-- --------------------------------------------------------

--
-- Table structure for table `questions`
--

CREATE TABLE `questions` (
  `id` bigint UNSIGNED NOT NULL,
  `exam_id` bigint UNSIGNED DEFAULT NULL,
  `statement` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `correct_answer` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `incorrect_answer_1` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `incorrect_answer_2` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `incorrect_answer_3` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `questions`
--

INSERT INTO `questions` (`id`, `exam_id`, `statement`, `correct_answer`, `incorrect_answer_1`, `incorrect_answer_2`, `incorrect_answer_3`, `created_at`, `updated_at`) VALUES
(1, 8, 'Et dolor ipsum ullam.', 'ut', 'quos', 'earum', 'repudiandae', '2025-04-18 17:13:06', '2025-04-18 17:13:06'),
(5, 9, 'Deleniti ea earum id eos vel facere.', 'inventore', 'eos', 'rerum', 'earum', '2025-04-18 17:13:06', '2025-04-18 17:13:06'),
(9, 3, 'Magni laborum fugit est quos.', 'reiciendis', 'nobis', 'laudantium', 'est', '2025-04-18 17:13:06', '2025-04-18 17:13:06'),
(10, 10, 'Perferendis animi autem iure ullam.', 'reprehenderit', 'aut', 'eum', 'qui', '2025-04-18 17:13:06', '2025-04-18 17:13:06'),
(11, 8, 'Distinctio ut quis suscipit voluptatibus pariatur perferendis quia.', 'explicabo', 'aliquam', 'provident', 'quis', '2025-04-18 17:13:06', '2025-04-18 17:13:06'),
(12, 8, 'Rerum natus necessitatibus ut inventore sint vel error.', 'saepe', 'inventore', 'quaerat', 'explicabo', '2025-04-18 17:13:06', '2025-04-18 17:13:06'),
(13, 4, 'Id repellat omnis nobis quibusdam.', 'distinctio', 'voluptatem', 'hic', 'et', '2025-04-18 17:13:06', '2025-04-18 17:13:06'),
(15, 4, 'Alias facilis autem vero doloremque nesciunt nihil doloribus.', 'impedit', 'soluta', 'qui', 'nostrum', '2025-04-18 17:13:06', '2025-04-18 17:13:06'),
(17, 9, 'Magnam nisi ea quasi et.', 'iusto', 'fugit', 'natus', 'vel', '2025-04-18 17:13:06', '2025-04-18 17:13:06'),
(18, 9, 'Laboriosam non eveniet earum expedita tempora ut vero.', 'libero', 'repellendus', 'minima', 'nesciunt', '2025-04-18 17:13:06', '2025-04-18 17:13:06'),
(19, 4, 'Explicabo rem sed ea adipisci sit voluptates enim.', 'voluptas', 'qui', 'aut', 'cumque', '2025-04-18 17:13:06', '2025-04-18 17:13:06'),
(20, 9, 'Velit voluptatem aut nostrum id est ratione.', 'occaecati', 'qui', 'quibusdam', 'similique', '2025-04-18 17:13:06', '2025-04-18 17:13:06'),
(21, 10, 'Veritatis sequi minus eveniet voluptatem necessitatibus.', 'non', 'voluptates', 'id', 'fugiat', '2025-04-18 17:13:06', '2025-04-18 17:13:06'),
(22, 3, 'Nulla autem reiciendis minima excepturi nostrum commodi.', 'quae', 'odio', 'enim', 'in', '2025-04-18 17:13:06', '2025-04-18 17:13:06'),
(23, 3, 'Quod facilis quo dolores.', 'aut', 'occaecati', 'enim', 'dignissimos', '2025-04-18 17:13:06', '2025-04-18 17:13:06'),
(24, 5, 'Voluptas a porro ducimus praesentium.', 'at', 'ab', 'dignissimos', 'aut', '2025-04-18 17:13:06', '2025-04-18 17:13:06'),
(26, 5, 'Vel eos illo molestiae deserunt.', 'optio', 'aut', 'quam', 'nulla', '2025-04-18 17:13:06', '2025-04-18 17:13:06'),
(27, 9, 'Pariatur vitae iste dolor culpa.', 'praesentium', 'quaerat', 'non', 'qui', '2025-04-18 17:13:06', '2025-04-18 17:13:06'),
(28, 3, 'Aut id exercitationem aspernatur deserunt alias.', 'eius', 'minima', 'quia', 'mollitia', '2025-04-18 17:13:06', '2025-04-18 17:13:06'),
(29, 9, 'Quis aut aliquid et incidunt.', 'quis', 'ut', 'consectetur', 'deserunt', '2025-04-18 17:13:06', '2025-04-18 17:13:06'),
(30, 3, 'Quis nobis reiciendis error tempora ad architecto suscipit quia.', 'sunt', 'qui', 'perferendis', 'quis', '2025-04-18 17:13:06', '2025-04-18 17:13:06'),
(31, 4, 'Omnis sapiente et iure quas et.', 'tempora', 'quas', 'a', 'laboriosam', '2025-04-18 17:13:06', '2025-04-18 17:13:06'),
(33, 5, 'Rerum porro autem nihil quod dolores.', 'quis', 'qui', 'modi', 'qui', '2025-04-18 17:13:06', '2025-04-18 17:13:06'),
(34, 10, 'Facilis commodi voluptatem aut quis suscipit occaecati voluptatem.', 'veritatis', 'quod', 'ex', 'neque', '2025-04-18 17:13:06', '2025-04-18 17:13:06'),
(35, 4, 'Sunt sunt enim et laboriosam voluptatem qui minus.', 'omnis', 'magnam', 'et', 'id', '2025-04-18 17:13:06', '2025-04-18 17:13:06'),
(37, 8, 'Qui error alias ducimus optio.', 'sint', 'minima', 'reiciendis', 'laboriosam', '2025-04-18 17:13:06', '2025-04-18 17:13:06'),
(39, 10, 'Facilis et quaerat officia et est sint.', 'quisquam', 'laboriosam', 'non', 'sit', '2025-04-18 17:13:06', '2025-04-18 17:13:06'),
(40, 5, 'Et dignissimos velit est molestiae ipsum est exercitationem.', 'sunt', 'odio', 'perferendis', 'odit', '2025-04-18 17:13:06', '2025-04-18 17:13:06'),
(42, 7, 'Et debitis non quidem aliquam.', 'consequuntur', 'deleniti', 'non', 'voluptas', '2025-04-18 17:13:06', '2025-04-18 17:13:06'),
(44, 10, 'Corrupti quibusdam et neque maxime ipsum recusandae hic.', 'quo', 'nam', 'impedit', 'assumenda', '2025-04-18 17:13:06', '2025-04-18 17:13:06'),
(45, 10, 'Dolorem consequatur maiores qui adipisci saepe.', 'doloribus', 'consequatur', 'id', 'labore', '2025-04-18 17:13:06', '2025-04-18 17:13:06'),
(47, 10, 'Odit tempora quia eius eos omnis enim suscipit.', 'delectus', 'est', 'esse', 'est', '2025-04-18 17:13:06', '2025-04-18 17:13:06'),
(48, 7, 'Ipsum itaque libero aliquam et laudantium odio nihil.', 'esse', 'fugit', 'aut', 'itaque', '2025-04-18 17:13:06', '2025-04-18 17:13:06'),
(49, 9, 'Aliquid architecto alias est aut.', 'sunt', 'sint', 'officia', 'consequatur', '2025-04-18 17:13:06', '2025-04-18 17:13:06'),
(50, 3, 'Aut maiores alias earum ut at nobis quia.', 'architecto', 'minus', 'omnis', 'eos', '2025-04-18 17:13:06', '2025-04-18 17:13:06'),
(55, 5, 'Quis et ratione provident ut dicta aliquid quia consectetur.', 'molestiae', 'non', 'debitis', 'tempora', '2025-04-18 17:13:06', '2025-04-18 17:13:06'),
(57, 10, 'Ut in molestiae rerum omnis rem provident.', 'autem', 'explicabo', 'et', 'sed', '2025-04-18 17:13:06', '2025-04-18 17:13:06'),
(58, 4, 'Et molestiae aliquam similique minima iusto.', 'facere', 'qui', 'nostrum', 'alias', '2025-04-18 17:13:06', '2025-04-18 17:13:06'),
(60, 10, 'Dolorem accusantium totam nisi placeat ut.', 'nostrum', 'eaque', 'quia', 'repellendus', '2025-04-18 17:13:06', '2025-04-18 17:13:06'),
(61, 5, 'Et qui maxime modi.', 'reiciendis', 'distinctio', 'possimus', 'optio', '2025-04-18 17:13:06', '2025-04-18 17:13:06'),
(63, 8, 'Soluta atque odit temporibus fugit.', 'aperiam', 'assumenda', 'ex', 'adipisci', '2025-04-18 17:13:06', '2025-04-18 17:13:06'),
(64, 7, 'Temporibus dicta temporibus quia reprehenderit sit temporibus.', 'repudiandae', 'sunt', 'et', 'laboriosam', '2025-04-18 17:13:06', '2025-04-18 17:13:06'),
(65, 9, 'Voluptas nulla voluptas perspiciatis ut ad pariatur ullam doloribus.', 'quis', 'debitis', 'et', 'iusto', '2025-04-18 17:13:06', '2025-04-18 17:13:06'),
(67, 8, 'Unde repellendus ratione ratione explicabo dignissimos non.', 'aperiam', 'eos', 'aut', 'rerum', '2025-04-18 17:13:06', '2025-04-18 17:13:06'),
(68, 5, 'Minus similique dolore laudantium dignissimos nam natus.', 'ullam', 'inventore', 'velit', 'aut', '2025-04-18 17:13:06', '2025-04-18 17:13:06'),
(69, 10, 'Exercitationem architecto repellat sapiente voluptatibus dicta saepe quidem.', 'sed', 'quis', 'asperiores', 'et', '2025-04-18 17:13:06', '2025-04-18 17:13:06'),
(70, 3, 'Dolorem illo dolor maiores commodi incidunt ratione.', 'ipsam', 'et', 'architecto', 'autem', '2025-04-18 17:13:06', '2025-04-18 17:13:06'),
(71, 8, 'Aut repudiandae qui eaque rem.', 'molestias', 'explicabo', 'et', 'blanditiis', '2025-04-18 17:13:06', '2025-04-18 17:13:06'),
(72, 3, 'Tenetur odit expedita dolor tenetur est fugiat et recusandae.', 'ullam', 'eos', 'eos', 'voluptatem', '2025-04-18 17:13:06', '2025-04-18 17:13:06'),
(73, 10, 'Fuga iusto nulla voluptas totam voluptatum praesentium omnis.', 'et', 'beatae', 'voluptatum', 'autem', '2025-04-18 17:13:06', '2025-04-18 17:13:06'),
(74, 3, 'Consequatur aspernatur est ut qui quaerat dicta ullam doloribus.', 'ab', 'iste', 'asperiores', 'perferendis', '2025-04-18 17:13:06', '2025-04-18 17:13:06'),
(75, 7, 'Quis praesentium voluptates aut vel voluptas laboriosam.', 'excepturi', 'exercitationem', 'sequi', 'aut', '2025-04-18 17:13:06', '2025-04-18 17:13:06'),
(76, 3, 'Error necessitatibus magni qui eos ut rem ipsam.', 'nihil', 'quia', 'nostrum', 'id', '2025-04-18 17:13:06', '2025-04-18 17:13:06'),
(77, 8, 'Aut voluptatem voluptatem temporibus harum.', 'est', 'vitae', 'incidunt', 'dolorem', '2025-04-18 17:13:06', '2025-04-18 17:13:06'),
(78, 7, 'Vitae at quia ullam saepe quas.', 'in', 'aut', 'non', 'dolor', '2025-04-18 17:13:06', '2025-04-18 17:13:06'),
(79, 3, 'Labore dolore quibusdam deserunt reiciendis.', 'eaque', 'repudiandae', 'tenetur', 'rerum', '2025-04-18 17:13:06', '2025-04-18 17:13:06'),
(81, 8, 'Laborum at unde et illo eligendi aliquam dolore dolorum.', 'sunt', 'voluptas', 'quia', 'sint', '2025-04-18 17:13:06', '2025-04-18 17:13:06'),
(85, 4, 'Ut id magni fuga officiis aut atque.', 'ipsa', 'minima', 'quae', 'ex', '2025-04-18 17:13:06', '2025-04-18 17:13:06'),
(86, 10, 'Optio et sint illum ipsam odio quae.', 'et', 'magni', 'nihil', 'vel', '2025-04-18 17:13:06', '2025-04-18 17:13:06'),
(87, 4, 'Laudantium veritatis est impedit nemo cum.', 'qui', 'eos', 'beatae', 'distinctio', '2025-04-18 17:13:07', '2025-04-18 17:13:07'),
(88, 3, 'Culpa ut repellat qui recusandae cum possimus.', 'laboriosam', 'adipisci', 'nostrum', 'vel', '2025-04-18 17:13:07', '2025-04-18 17:13:07'),
(89, 8, 'Labore et aut nihil quam fugiat ipsam non occaecati.', 'voluptas', 'sint', 'sed', 'quas', '2025-04-18 17:13:07', '2025-04-18 17:13:07'),
(90, 8, 'Et cupiditate quas eaque quos illum pariatur quia.', 'vel', 'voluptate', 'veritatis', 'repudiandae', '2025-04-18 17:13:07', '2025-04-18 17:13:07'),
(91, 3, 'Similique saepe laborum rerum vel deserunt ex eveniet.', 'sint', 'quis', 'aperiam', 'dolore', '2025-04-18 17:13:07', '2025-04-18 17:13:07'),
(93, 5, 'At autem maiores tempora voluptas tenetur possimus cum.', 'fugit', 'eaque', 'pariatur', 'dicta', '2025-04-18 17:13:07', '2025-04-18 17:13:07'),
(94, 9, 'Illo sapiente nihil sunt laboriosam doloribus eaque consectetur et.', 'tempore', 'pariatur', 'mollitia', 'et', '2025-04-18 17:13:07', '2025-04-18 17:13:07'),
(95, 8, 'Tenetur nam enim ullam numquam molestiae reiciendis.', 'id', 'aperiam', 'et', 'odio', '2025-04-18 17:13:07', '2025-04-18 17:13:07'),
(96, 7, 'Non minima dolor sit officia et.', 'voluptatibus', 'a', 'tenetur', 'aspernatur', '2025-04-18 17:13:07', '2025-04-18 17:13:07'),
(97, 8, 'Repellat omnis nobis quia.', 'sunt', 'molestiae', 'explicabo', 'neque', '2025-04-18 17:13:07', '2025-04-18 17:13:07'),
(98, 3, 'Magni cum est necessitatibus veniam omnis autem tempore adipisci.', 'debitis', 'id', 'aut', 'voluptas', '2025-04-18 17:13:07', '2025-04-18 17:13:07'),
(99, 10, 'Harum qui qui et quae.', 'voluptatem', 'alias', 'debitis', 'quaerat', '2025-04-18 17:13:07', '2025-04-18 17:13:07'),
(100, 4, 'Inventore architecto dolor similique perspiciatis ipsum laudantium velit.', 'quisquam', 'optio', 'voluptatibus', 'adipisci', '2025-04-18 17:13:07', '2025-04-18 17:13:07');

-- --------------------------------------------------------

--
-- Table structure for table `resources`
--

CREATE TABLE `resources` (
  `id` bigint UNSIGNED NOT NULL,
  `course_id` bigint UNSIGNED NOT NULL,
  `type` enum('document','video','link') COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `limit_date` timestamp NULL DEFAULT NULL,
  `url` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `resources`
--

INSERT INTO `resources` (`id`, `course_id`, `type`, `name`, `description`, `limit_date`, `url`, `created_at`, `updated_at`) VALUES
(1, 1, 'document', 'Facilis debitis dolores labore.', 'Modi non repudiandae voluptatum. Blanditiis quo iusto dolores itaque fugit.', '2025-05-06 03:25:17', 'http://gerhold.net/libero-commodi-esse-voluptatem-amet-veniam.html', '2025-04-18 17:13:06', '2025-04-18 17:13:06'),
(2, 7, 'document', 'Autem ut aliquid.', 'Accusamus corrupti consequuntur et et beatae totam. Beatae dolorem tenetur eveniet recusandae est. Expedita aliquid pariatur cupiditate eligendi dolor aut minima.', '2025-05-09 03:37:23', 'https://bauch.net/explicabo-sit-earum-qui-exercitationem-architecto.html', '2025-04-18 17:13:06', '2025-04-18 17:13:06'),
(3, 4, 'document', 'Natus nihil porro.', 'Ut voluptate dolores sunt. Rem est ut omnis similique modi molestiae. Id rerum et labore culpa vitae.', '2025-05-01 00:48:49', 'https://brown.biz/tenetur-sit-voluptas-aut-odio-officiis-ratione.html', '2025-04-18 17:13:06', '2025-04-18 17:13:06'),
(4, 1, 'link', 'Fuga rerum dolorem.', 'Aut quia dolorem maiores similique ab. Error libero a fuga quo consequatur id provident. Tempore consequuntur neque autem eaque sit.', '2025-04-19 22:17:40', 'http://www.ruecker.net/officiis-nam-velit-architecto-deserunt-alias-accusantium.html', '2025-04-18 17:13:06', '2025-04-18 17:13:06'),
(6, 1, 'video', 'Repellat dolor voluptas adipisci.', 'Eligendi consectetur quae beatae animi nostrum. Ut id vel omnis et in eos sunt. Placeat adipisci aut vel voluptatum sit accusantium.', '2025-05-14 00:41:40', 'http://www.cummings.com/', '2025-04-18 17:13:06', '2025-04-18 17:13:06'),
(7, 9, 'link', 'Ut aut amet.', 'Et accusamus sint alias commodi eius. Ut nobis voluptatibus ad ex debitis omnis natus. Natus consequatur unde laboriosam ut. Sit sint quo sint.', '2025-04-24 18:24:20', 'http://www.pfannerstill.net/molestiae-consequatur-fugiat-alias-nobis-excepturi.html', '2025-04-18 17:13:06', '2025-04-18 17:13:06'),
(8, 2, 'video', 'Dolorem nemo reprehenderit est.', 'Recusandae soluta vel maiores enim fugiat inventore. Debitis ut nesciunt debitis amet excepturi sequi quidem. Cupiditate non et possimus ut rem ab.', '2025-05-04 04:24:29', 'http://www.miller.com/rem-unde-quos-nobis-consequatur-quidem-ducimus-voluptatum-animi', '2025-04-18 17:13:06', '2025-04-18 17:13:06'),
(9, 4, 'document', 'Velit aperiam quaerat aliquid.', 'Ex voluptatem quam sit voluptas commodi et doloremque. Eum necessitatibus animi similique a. Qui et atque sequi error rerum.', '2025-05-07 18:09:52', 'http://graham.org/', '2025-04-18 17:13:06', '2025-04-18 17:13:06'),
(10, 8, 'document', 'Aut illo tempore et dignissimos.', 'Distinctio et deserunt nulla harum quam. Dicta a vel eius nihil harum et error. Commodi in consequatur tempora et voluptatem et molestiae. Facilis exercitationem consequatur vel consequatur rerum maxime consequatur.', '2025-04-26 17:39:00', 'http://aufderhar.com/consequatur-neque-esse-qui-dicta.html', '2025-04-18 17:13:06', '2025-04-18 17:13:06'),
(11, 9, 'link', 'Perferendis molestiae accusamus.', 'Nulla facere possimus similique et quibusdam omnis. Voluptate voluptatem reiciendis est qui nihil nemo quisquam. Rem earum reprehenderit minima eum.', '2025-04-23 15:38:29', 'http://mayer.com/qui-libero-quia-qui-occaecati-omnis-soluta', '2025-04-18 17:13:06', '2025-04-18 17:13:06'),
(12, 9, 'video', 'Nulla ipsam optio.', 'Nihil voluptatum delectus in dolorem quia veniam. Soluta officia reiciendis consequatur nihil. A sit id voluptatibus tempora sint laboriosam. Velit voluptatum adipisci nesciunt et rerum temporibus expedita.', '2025-05-01 01:29:33', 'http://heathcote.net/', '2025-04-18 17:13:06', '2025-04-18 17:13:06'),
(13, 1, 'video', 'Officia qui ullam facere.', 'Sunt et repellendus qui provident harum accusantium inventore. Eos natus unde alias deleniti quod natus magnam eos.', '2025-04-30 03:40:16', 'http://www.murray.com/eveniet-dolores-voluptatem-iure-quia-sint-officia-enim', '2025-04-18 17:13:06', '2025-04-18 17:13:06'),
(16, 9, 'document', 'Ea aut nisi.', 'Voluptatem dolorem commodi sunt perferendis. Dolor rerum cupiditate sed est sint laboriosam nihil nostrum. Sit autem ab rerum deserunt nihil ea incidunt et. Voluptatibus qui consectetur nihil quia et.', '2025-05-12 17:16:18', 'http://www.konopelski.com/reiciendis-aut-qui-quia-culpa.html', '2025-04-18 17:13:06', '2025-04-18 17:13:06'),
(17, 8, 'link', 'Et sed dolore.', 'In ut ratione dolor inventore animi. Iste et quidem modi omnis facilis tenetur. Expedita ut magnam eum ipsam deleniti modi. Aut quis sed quos.', '2025-04-22 16:35:23', 'http://www.hand.org/alias-saepe-rerum-modi-ullam-perspiciatis-laboriosam-qui-animi.html', '2025-04-18 17:13:06', '2025-04-18 17:13:06'),
(18, 1, 'video', 'Sit ipsa voluptas.', 'Id ut beatae officiis sequi ullam fugiat eos. Nihil aliquid tempore alias totam explicabo illo quo velit. Repudiandae minima velit voluptate est dolorum accusantium. Labore deleniti placeat dolor.', '2025-05-02 15:19:21', 'http://www.ward.org/', '2025-04-18 17:13:06', '2025-04-18 17:13:06'),
(19, 7, 'document', 'Et illo consequatur blanditiis iure.', 'Iste iusto maiores laborum sit maxime aut quae. Expedita expedita adipisci iure aut perspiciatis et. Ipsa earum dicta reprehenderit et. Est fugit officia cum recusandae occaecati nostrum. Veritatis porro veniam ex deleniti et.', '2025-04-27 22:28:25', 'http://kuvalis.com/', '2025-04-18 17:13:06', '2025-04-18 17:13:06'),
(20, 6, 'video', 'Id exercitationem odio.', 'Voluptatem et aut fugiat itaque debitis. Et labore ullam cupiditate numquam omnis quod dolorum. Aut voluptatibus nobis provident exercitationem.', '2025-05-08 06:02:00', 'https://carter.net/sit-est-deleniti-pariatur-sed-voluptatem-dolorum.html', '2025-04-18 17:13:06', '2025-04-18 17:13:06'),
(24, 2, 'video', 'Repudiandae sequi suscipit culpa.', 'Illo sint illum quas fugiat tempore eum. Eum est molestias quidem veniam dicta.', '2025-05-01 02:43:15', 'http://www.stoltenberg.org/soluta-voluptates-delectus-odio-quia-harum-aliquid-fuga', '2025-04-18 17:13:06', '2025-04-18 17:13:06'),
(25, 2, 'video', 'Tempora est mollitia.', 'Voluptas voluptas doloremque consequatur repudiandae. Autem sint itaque et voluptas vel voluptates tempore. Consequatur omnis quisquam quis optio rerum enim voluptates temporibus. Illo eos voluptas quia dolorum quibusdam aut.', '2025-05-14 14:10:13', 'http://conroy.com/ad-tenetur-vel-quibusdam-in.html', '2025-04-18 17:13:06', '2025-04-18 17:13:06'),
(26, 1, 'video', 'Excepturi iusto enim.', 'Aut excepturi ut minima in sequi laborum sunt. Quaerat facilis delectus neque nam. Omnis doloremque voluptas ut enim voluptas architecto illo. Magnam error illo et reiciendis exercitationem dignissimos rerum. Voluptatem enim tenetur facere occaecati.', '2025-05-09 15:37:52', 'http://www.kilback.com/error-possimus-corporis-aut-iusto-rem.html', '2025-04-18 17:13:06', '2025-04-18 17:13:06'),
(28, 4, 'document', 'Ad aut blanditiis.', 'Qui eos sed qui facilis velit. Magnam esse molestiae est atque. Veniam inventore quasi enim qui laudantium blanditiis eum.', '2025-04-27 03:51:16', 'http://www.crona.net/et-quae-iure-modi-quam-et-blanditiis-officia', '2025-04-18 17:13:06', '2025-04-18 17:13:06'),
(29, 9, 'link', 'Cum laboriosam.', 'Sequi laborum laborum eligendi et eligendi quod. Ipsam et et laborum est.', '2025-05-15 04:21:16', 'http://kautzer.info/autem-corrupti-vitae-est-aut-et-quia-provident.html', '2025-04-18 17:13:06', '2025-04-18 17:13:06'),
(30, 8, 'video', 'Expedita veritatis ipsa aut eligendi.', 'Veniam iure qui modi autem. Dolor quo ut qui quos non. Dolor et enim et. Est saepe a et amet.', '2025-05-07 20:29:35', 'http://www.swaniawski.org/rerum-eum-sint-eos-libero.html', '2025-04-18 17:13:06', '2025-04-18 17:13:06'),
(31, 1, 'document', 'Voluptate quo dolore.', 'Eum ut iste neque ipsam. Possimus dolores illum et velit nobis numquam et.', '2025-04-29 07:29:46', 'http://www.harber.com/', '2025-04-18 17:13:06', '2025-04-18 17:13:06'),
(32, 2, 'document', 'Nulla modi autem.', 'Molestias sequi consequatur neque est ullam culpa. Aperiam aspernatur autem repellendus illum.', '2025-05-09 09:55:32', 'http://www.prosacco.com/nesciunt-autem-omnis-adipisci-quos-voluptas-rem', '2025-04-18 17:13:06', '2025-04-18 17:13:06'),
(33, 9, 'document', 'Odit expedita quisquam.', 'Exercitationem sunt sapiente aut repellat. Ipsam est delectus dolor exercitationem. Repellat aspernatur quaerat placeat culpa. Culpa ea non minus sint numquam.', '2025-04-25 20:18:04', 'http://www.wilkinson.biz/', '2025-04-18 17:13:06', '2025-04-18 17:13:06'),
(35, 6, 'link', 'Repellendus quisquam molestiae magni.', 'Nam dicta nihil voluptatem cumque necessitatibus deserunt molestias quibusdam. Corrupti minima facilis est illum quia eaque aspernatur ut. Possimus a magni sequi excepturi. Facere enim est reprehenderit ea incidunt facere.', '2025-05-14 04:15:35', 'http://jerde.biz/quisquam-laboriosam-repellat-est-ut-voluptates-quidem', '2025-04-18 17:13:06', '2025-04-18 17:13:06'),
(38, 7, 'link', 'Velit laudantium numquam suscipit.', 'Tempora quis est modi amet. Iusto mollitia rerum eligendi quaerat et qui voluptates. Numquam aut praesentium omnis quaerat rerum id. Et suscipit a quia non hic alias quia.', '2025-05-03 20:49:06', 'http://oconnell.info/', '2025-04-18 17:13:06', '2025-04-18 17:13:06'),
(39, 8, 'video', 'Aut voluptas dolores.', 'Repellat ut consectetur fuga quo cum illum omnis quisquam. Neque qui placeat nulla voluptates ut. Odio quia nulla laborum. Quas dicta hic fugiat omnis labore voluptas est.', '2025-05-14 08:09:22', 'http://sipes.com/quam-sint-est-excepturi-unde-illum-laudantium-voluptatum-sed', '2025-04-18 17:13:06', '2025-04-18 17:13:06'),
(40, 1, 'link', 'Omnis debitis autem rerum.', 'Rerum quisquam temporibus molestias alias et maxime eum. Veniam voluptatem libero nobis autem vel cumque. Corporis deleniti amet voluptatum dolorem nostrum ut. Occaecati facilis sapiente omnis voluptatum corporis id.', '2025-04-26 04:43:50', 'https://www.schmidt.com/quaerat-quis-dolorem-dolore', '2025-04-18 17:13:06', '2025-04-18 17:13:06'),
(41, 6, 'link', 'Eaque quaerat recusandae ex.', 'Error officiis id laudantium. Omnis odio repudiandae cum sapiente accusantium natus vel. Qui labore et numquam delectus voluptatibus itaque sunt. In magni et consequatur.', '2025-05-12 13:30:59', 'http://langworth.com/', '2025-04-18 17:13:06', '2025-04-18 17:13:06'),
(42, 8, 'document', 'Dolor natus et aut.', 'Quaerat nihil vero omnis distinctio dolores repudiandae sed. Qui blanditiis pariatur laudantium repudiandae. Quia aliquid molestiae ducimus fuga nemo natus repellendus.', '2025-05-08 08:12:35', 'http://www.kulas.info/', '2025-04-18 17:13:06', '2025-04-18 17:13:06'),
(43, 6, 'video', 'Quam quae sed nihil.', 'Quos qui vel consequatur nihil. Enim ipsa sit hic illum praesentium voluptas. Atque quia alias quia necessitatibus nesciunt voluptates.', '2025-05-03 22:00:22', 'http://ernser.com/esse-nemo-sit-et-aliquid-est-nihil', '2025-04-18 17:13:06', '2025-04-18 17:13:06'),
(44, 2, 'video', 'Eaque perspiciatis quo.', 'Voluptatem corrupti minus soluta qui. Sed officiis itaque consectetur doloremque odio dignissimos ut illum. Repellat qui qui reprehenderit cupiditate non.', '2025-04-20 10:45:54', 'http://www.turcotte.com/voluptates-architecto-animi-aut', '2025-04-18 17:13:06', '2025-04-18 17:13:06'),
(45, 4, 'document', 'Dolorum corporis eligendi labore.', 'Non autem rerum aut repellendus. Autem necessitatibus sit quis sint. Ut totam iusto quidem natus laborum rerum earum. Eligendi animi quidem placeat omnis est enim sunt.', '2025-04-21 18:04:55', 'http://feil.org/quod-et-explicabo-neque-unde.html', '2025-04-18 17:13:06', '2025-04-18 17:13:06'),
(47, 9, 'video', 'Iste omnis nihil.', 'Velit ad sed error quae dolorem consequuntur. Ea inventore ad enim numquam qui voluptate ut. In velit similique ut ducimus. Non accusantium iusto in ab.', '2025-05-08 07:56:53', 'http://www.konopelski.org/repudiandae-nostrum-quae-aut-debitis-quis-deleniti-cupiditate', '2025-04-18 17:13:06', '2025-04-18 17:13:06'),
(48, 2, 'link', 'Tempore sunt ut est.', 'Quisquam in porro dolorum possimus iste sed deleniti. Et voluptatem qui omnis eum ullam. Dolor impedit est totam labore et eos. Odio et quo cupiditate error explicabo. Officia minus aut similique sunt qui accusamus.', '2025-04-26 16:32:37', 'http://www.weber.com/praesentium-aut-est-aliquam-qui-aperiam-ullam-nihil', '2025-04-18 17:13:06', '2025-04-18 17:13:06'),
(49, 4, 'document', 'In culpa deleniti amet.', 'Excepturi earum eius consequatur laboriosam saepe omnis dicta. Eos totam omnis quisquam aperiam voluptas sint.', '2025-05-18 10:18:15', 'http://gibson.com/numquam-enim-aperiam-voluptas-aut', '2025-04-18 17:13:06', '2025-04-18 17:13:06'),
(50, 6, 'link', 'Ut maiores minus rerum.', 'Placeat rerum ad id quas. Illo laborum nam voluptatem quos voluptatem aspernatur distinctio. Harum voluptatem iste quia veritatis.', '2025-05-12 14:52:03', 'http://www.ruecker.net/velit-voluptatem-accusamus-sapiente-laudantium-quis-excepturi-voluptatem', '2025-04-18 17:13:06', '2025-04-18 17:13:06');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `rol` enum('student','teacher','admin') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'student',
  `register_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `password`, `rol`, `register_date`, `created_at`, `updated_at`) VALUES
(1, 'Admin', 'admin@open.es', '$2y$12$2eh9sZQvFLo5rZR7jZZbG.mAJdTt5iV0y3Njstl0pgYlwf9Nl8VWi', 'admin', '2025-04-18 17:13:05', '2025-04-18 17:13:05', '2025-04-18 17:13:05'),
(2, 'Ms. Britney Runolfsson', 'walker.lemke@example.net', '$2y$12$sg7jtMa/hka8wzSmAWX.MuPPi/PMFiQ5VHB0nPFHnGfnFU/LWo28m', 'teacher', '2025-04-18 17:13:05', '2025-04-18 17:13:05', '2025-04-18 17:13:05'),
(3, 'Prof. Tobin Kertzmann MD', 'dietrich.otis@example.org', '$2y$12$sg7jtMa/hka8wzSmAWX.MuPPi/PMFiQ5VHB0nPFHnGfnFU/LWo28m', 'teacher', '2025-04-18 17:13:05', '2025-04-18 17:13:05', '2025-04-18 17:13:05'),
(4, 'Emil Runte', 'hailee04@example.com', '$2y$12$sg7jtMa/hka8wzSmAWX.MuPPi/PMFiQ5VHB0nPFHnGfnFU/LWo28m', 'teacher', '2025-04-18 17:13:05', '2025-04-18 17:13:05', '2025-04-18 17:13:05'),
(5, 'Adalberto Lind', 'delilah.hoeger@example.org', '$2y$12$sg7jtMa/hka8wzSmAWX.MuPPi/PMFiQ5VHB0nPFHnGfnFU/LWo28m', 'teacher', '2025-04-18 17:13:05', '2025-04-18 17:13:05', '2025-04-18 17:13:05'),
(7, 'Elsie Abshire II', 'ssanford@example.com', '$2y$12$sg7jtMa/hka8wzSmAWX.MuPPi/PMFiQ5VHB0nPFHnGfnFU/LWo28m', 'student', '2025-04-18 17:13:05', '2025-04-18 17:13:05', '2025-04-18 17:13:05'),
(8, 'Dr. Leopoldo Cummings', 'pfritsch@example.net', '$2y$12$sg7jtMa/hka8wzSmAWX.MuPPi/PMFiQ5VHB0nPFHnGfnFU/LWo28m', 'student', '2025-04-18 17:13:05', '2025-04-18 17:13:05', '2025-04-18 17:13:05'),
(9, 'Hobart Beahan', 'wcarroll@example.com', '$2y$12$sg7jtMa/hka8wzSmAWX.MuPPi/PMFiQ5VHB0nPFHnGfnFU/LWo28m', 'student', '2025-04-18 17:13:05', '2025-04-18 17:13:05', '2025-04-18 17:13:05'),
(10, 'Jairo Champlin', 'antonetta08@example.net', '$2y$12$sg7jtMa/hka8wzSmAWX.MuPPi/PMFiQ5VHB0nPFHnGfnFU/LWo28m', 'student', '2025-04-18 17:13:05', '2025-04-18 17:13:05', '2025-04-18 17:13:05'),
(11, 'Willy Prohaska', 'adolphus10@example.net', '$2y$12$sg7jtMa/hka8wzSmAWX.MuPPi/PMFiQ5VHB0nPFHnGfnFU/LWo28m', 'student', '2025-04-18 17:13:05', '2025-04-18 17:13:05', '2025-04-18 17:13:05'),
(12, 'Ada Hickle Sr.', 'bertrand.balistreri@example.com', '$2y$12$sg7jtMa/hka8wzSmAWX.MuPPi/PMFiQ5VHB0nPFHnGfnFU/LWo28m', 'student', '2025-04-18 17:13:05', '2025-04-18 17:13:05', '2025-04-18 17:13:05'),
(13, 'Mrs. Santina Price V', 'boyer.neoma@example.org', '$2y$12$sg7jtMa/hka8wzSmAWX.MuPPi/PMFiQ5VHB0nPFHnGfnFU/LWo28m', 'student', '2025-04-18 17:13:05', '2025-04-18 17:13:05', '2025-04-18 17:13:05'),
(14, 'Alaina Stark', 'prohaska.bud@example.net', '$2y$12$sg7jtMa/hka8wzSmAWX.MuPPi/PMFiQ5VHB0nPFHnGfnFU/LWo28m', 'student', '2025-04-18 17:13:05', '2025-04-18 17:13:05', '2025-04-18 17:13:05'),
(15, 'Rickie King', 'janessa40@example.com', '$2y$12$sg7jtMa/hka8wzSmAWX.MuPPi/PMFiQ5VHB0nPFHnGfnFU/LWo28m', 'student', '2025-04-18 17:13:05', '2025-04-18 17:13:05', '2025-04-18 17:13:05'),
(16, 'Dr. Marco Bayer MD', 'rosetta51@example.com', '$2y$12$sg7jtMa/hka8wzSmAWX.MuPPi/PMFiQ5VHB0nPFHnGfnFU/LWo28m', 'student', '2025-04-18 17:13:05', '2025-04-18 17:13:05', '2025-04-18 17:13:05'),
(17, 'Ms. Gail Durgan DVM', 'gleichner.abby@example.com', '$2y$12$sg7jtMa/hka8wzSmAWX.MuPPi/PMFiQ5VHB0nPFHnGfnFU/LWo28m', 'student', '2025-04-18 17:13:05', '2025-04-18 17:13:06', '2025-04-18 17:13:06'),
(18, 'Dr. Jacinthe Mitchell', 'wunsch.lelia@example.org', '$2y$12$sg7jtMa/hka8wzSmAWX.MuPPi/PMFiQ5VHB0nPFHnGfnFU/LWo28m', 'student', '2025-04-18 17:13:05', '2025-04-18 17:13:06', '2025-04-18 17:13:06'),
(19, 'Justina Smith PhD', 'iklein@example.org', '$2y$12$sg7jtMa/hka8wzSmAWX.MuPPi/PMFiQ5VHB0nPFHnGfnFU/LWo28m', 'student', '2025-04-18 17:13:05', '2025-04-18 17:13:06', '2025-04-18 17:13:06'),
(20, 'Mr. Lincoln Hackett Jr.', 'scottie22@example.org', '$2y$12$sg7jtMa/hka8wzSmAWX.MuPPi/PMFiQ5VHB0nPFHnGfnFU/LWo28m', 'student', '2025-04-18 17:13:05', '2025-04-18 17:13:06', '2025-04-18 17:13:06');

-- --------------------------------------------------------

--
-- Table structure for table `user_tests`
--

CREATE TABLE `user_tests` (
  `id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `question_id` bigint UNSIGNED NOT NULL,
  `exam_id` bigint UNSIGNED NOT NULL,
  `user_answer` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_correct` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `user_tests`
--

INSERT INTO `user_tests` (`id`, `user_id`, `question_id`, `exam_id`, `user_answer`, `is_correct`, `created_at`, `updated_at`) VALUES
(1, 4, 61, 7, 'nam', 0, '2025-04-18 17:13:07', '2025-04-18 17:13:07'),
(4, 17, 72, 10, 'repellat', 0, '2025-04-18 17:13:07', '2025-04-18 17:13:07'),
(5, 16, 21, 4, 'non', 0, '2025-04-18 17:13:07', '2025-04-18 17:13:07'),
(9, 15, 9, 4, 'dolores', 0, '2025-04-18 17:13:07', '2025-04-18 17:13:07'),
(11, 17, 100, 10, 'aperiam', 0, '2025-04-18 17:13:07', '2025-04-18 17:13:07'),
(12, 17, 1, 8, 'commodi', 1, '2025-04-18 17:13:07', '2025-04-18 17:13:07'),
(13, 20, 9, 7, 'veniam', 1, '2025-04-18 17:13:07', '2025-04-18 17:13:07'),
(16, 16, 93, 5, 'doloremque', 1, '2025-04-18 17:13:07', '2025-04-18 17:13:07'),
(18, 1, 75, 9, 'sit', 0, '2025-04-18 17:13:07', '2025-04-18 17:13:07'),
(20, 17, 94, 9, 'aut', 1, '2025-04-18 17:13:07', '2025-04-18 17:13:07'),
(25, 15, 1, 5, 'sequi', 1, '2025-04-18 17:13:07', '2025-04-18 17:13:07'),
(26, 14, 93, 10, 'reiciendis', 1, '2025-04-18 17:13:07', '2025-04-18 17:13:07'),
(28, 16, 29, 5, 'enim', 1, '2025-04-18 17:13:07', '2025-04-18 17:13:07'),
(29, 14, 5, 5, 'libero', 1, '2025-04-18 17:13:07', '2025-04-18 17:13:07'),
(30, 10, 15, 5, 'laborum', 0, '2025-04-18 17:13:07', '2025-04-18 17:13:07'),
(32, 8, 9, 9, 'molestias', 1, '2025-04-18 17:13:07', '2025-04-18 17:13:07'),
(33, 5, 5, 9, 'velit', 1, '2025-04-18 17:13:07', '2025-04-18 17:13:07'),
(36, 3, 21, 8, 'assumenda', 1, '2025-04-18 17:13:07', '2025-04-18 17:13:07'),
(37, 12, 88, 3, 'nostrum', 1, '2025-04-18 17:13:07', '2025-04-18 17:13:07'),
(38, 1, 87, 7, 'occaecati', 0, '2025-04-18 17:13:07', '2025-04-18 17:13:07'),
(40, 4, 48, 10, 'quos', 0, '2025-04-18 17:13:07', '2025-04-18 17:13:07'),
(41, 1, 37, 9, 'qui', 0, '2025-04-18 17:13:07', '2025-04-18 17:13:07'),
(44, 7, 11, 4, 'illo', 0, '2025-04-18 17:13:07', '2025-04-18 17:13:07'),
(46, 17, 19, 5, 'sed', 0, '2025-04-18 17:13:07', '2025-04-18 17:13:07'),
(49, 2, 65, 10, 'hic', 0, '2025-04-18 17:13:07', '2025-04-18 17:13:07'),
(50, 14, 19, 8, 'laboriosam', 0, '2025-04-18 17:13:07', '2025-04-18 17:13:07'),
(51, 7, 63, 10, 'consequatur', 1, '2025-04-18 17:13:07', '2025-04-18 17:13:07'),
(52, 9, 73, 7, 'aperiam', 0, '2025-04-18 17:13:07', '2025-04-18 17:13:07'),
(53, 8, 33, 9, 'ipsa', 0, '2025-04-18 17:13:07', '2025-04-18 17:13:07'),
(54, 17, 98, 9, 'molestiae', 1, '2025-04-18 17:13:07', '2025-04-18 17:13:07'),
(55, 18, 79, 10, 'debitis', 0, '2025-04-18 17:13:07', '2025-04-18 17:13:07'),
(63, 2, 65, 8, 'molestiae', 1, '2025-04-18 17:13:07', '2025-04-18 17:13:07'),
(69, 12, 28, 3, 'adipisci', 1, '2025-04-18 17:13:07', '2025-04-18 17:13:07'),
(77, 16, 75, 10, 'autem', 0, '2025-04-18 17:13:07', '2025-04-18 17:13:07'),
(78, 1, 23, 4, 'facere', 1, '2025-04-18 17:13:07', '2025-04-18 17:13:07'),
(85, 2, 28, 5, 'eius', 1, '2025-04-18 17:13:07', '2025-04-18 17:13:07'),
(87, 7, 77, 5, 'tempora', 1, '2025-04-18 17:13:07', '2025-04-18 17:13:07'),
(88, 10, 48, 10, 'sed', 0, '2025-04-18 17:13:07', '2025-04-18 17:13:07'),
(89, 4, 87, 9, 'rem', 0, '2025-04-18 17:13:07', '2025-04-18 17:13:07'),
(92, 7, 61, 8, 'repellendus', 1, '2025-04-18 17:13:07', '2025-04-18 17:13:07'),
(94, 10, 94, 9, 'molestias', 1, '2025-04-18 17:13:07', '2025-04-18 17:13:07'),
(95, 14, 79, 10, 'soluta', 0, '2025-04-18 17:13:07', '2025-04-18 17:13:07'),
(98, 15, 42, 7, 'et', 0, '2025-04-18 17:13:07', '2025-04-18 17:13:07'),
(99, 5, 39, 7, 'et', 1, '2025-04-18 17:13:07', '2025-04-18 17:13:07'),
(101, 16, 93, 5, 'fugit', 1, '2025-04-19 08:42:55', '2025-04-19 08:53:39');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `califications`
--
ALTER TABLE `califications`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `califications_user_id_exam_id_unique` (`user_id`,`exam_id`),
  ADD KEY `califications_exam_id_foreign` (`exam_id`);

--
-- Indexes for table `certificates`
--
ALTER TABLE `certificates`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `certificates_certificate_code_unique` (`certificate_code`),
  ADD KEY `certificates_user_id_foreign` (`user_id`),
  ADD KEY `certificates_course_id_foreign` (`course_id`);

--
-- Indexes for table `comments`
--
ALTER TABLE `comments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `comments_user_id_foreign` (`user_id`),
  ADD KEY `comments_resource_id_foreign` (`resource_id`),
  ADD KEY `comments_response_id_foreign` (`response_id`);

--
-- Indexes for table `courses`
--
ALTER TABLE `courses`
  ADD PRIMARY KEY (`id`),
  ADD KEY `courses_teacher_id_foreign` (`teacher_id`);

--
-- Indexes for table `exams`
--
ALTER TABLE `exams`
  ADD PRIMARY KEY (`id`),
  ADD KEY `exams_course_id_foreign` (`course_id`);

--
-- Indexes for table `inscriptions`
--
ALTER TABLE `inscriptions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `inscriptions_user_id_course_id_unique` (`user_id`,`course_id`),
  ADD KEY `inscriptions_course_id_foreign` (`course_id`);

--
-- Indexes for table `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `personal_access_tokens_token_unique` (`token`),
  ADD KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`);

--
-- Indexes for table `questions`
--
ALTER TABLE `questions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `questions_exam_id_foreign` (`exam_id`);

--
-- Indexes for table `resources`
--
ALTER TABLE `resources`
  ADD PRIMARY KEY (`id`),
  ADD KEY `resources_course_id_foreign` (`course_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_email_unique` (`email`);

--
-- Indexes for table `user_tests`
--
ALTER TABLE `user_tests`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_tests_question_id_foreign` (`question_id`),
  ADD KEY `user_tests_user_id_foreign` (`user_id`),
  ADD KEY `user_tests_exam_id_foreign` (`exam_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `califications`
--
ALTER TABLE `califications`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `certificates`
--
ALTER TABLE `certificates`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `comments`
--
ALTER TABLE `comments`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `courses`
--
ALTER TABLE `courses`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `exams`
--
ALTER TABLE `exams`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `inscriptions`
--
ALTER TABLE `inscriptions`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `questions`
--
ALTER TABLE `questions`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=101;

--
-- AUTO_INCREMENT for table `resources`
--
ALTER TABLE `resources`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=51;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `user_tests`
--
ALTER TABLE `user_tests`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=102;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `califications`
--
ALTER TABLE `califications`
  ADD CONSTRAINT `califications_exam_id_foreign` FOREIGN KEY (`exam_id`) REFERENCES `exams` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `califications_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `certificates`
--
ALTER TABLE `certificates`
  ADD CONSTRAINT `certificates_course_id_foreign` FOREIGN KEY (`course_id`) REFERENCES `courses` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `certificates_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `comments`
--
ALTER TABLE `comments`
  ADD CONSTRAINT `comments_resource_id_foreign` FOREIGN KEY (`resource_id`) REFERENCES `resources` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `comments_response_id_foreign` FOREIGN KEY (`response_id`) REFERENCES `comments` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `comments_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `courses`
--
ALTER TABLE `courses`
  ADD CONSTRAINT `courses_teacher_id_foreign` FOREIGN KEY (`teacher_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `exams`
--
ALTER TABLE `exams`
  ADD CONSTRAINT `exams_course_id_foreign` FOREIGN KEY (`course_id`) REFERENCES `courses` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `inscriptions`
--
ALTER TABLE `inscriptions`
  ADD CONSTRAINT `inscriptions_course_id_foreign` FOREIGN KEY (`course_id`) REFERENCES `courses` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `inscriptions_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `questions`
--
ALTER TABLE `questions`
  ADD CONSTRAINT `questions_exam_id_foreign` FOREIGN KEY (`exam_id`) REFERENCES `exams` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `resources`
--
ALTER TABLE `resources`
  ADD CONSTRAINT `resources_course_id_foreign` FOREIGN KEY (`course_id`) REFERENCES `courses` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `user_tests`
--
ALTER TABLE `user_tests`
  ADD CONSTRAINT `user_tests_exam_id_foreign` FOREIGN KEY (`exam_id`) REFERENCES `exams` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `user_tests_question_id_foreign` FOREIGN KEY (`question_id`) REFERENCES `questions` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `user_tests_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
