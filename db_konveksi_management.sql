-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Waktu pembuatan: 04 Feb 2026 pada 06.50
-- Versi server: 10.4.32-MariaDB
-- Versi PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `db_konveksi_management`
--

-- --------------------------------------------------------

--
-- Struktur dari tabel `calendar_events`
--

CREATE TABLE `calendar_events` (
  `id` int(11) NOT NULL,
  `title` varchar(150) NOT NULL,
  `event_date` datetime NOT NULL,
  `description` text DEFAULT NULL,
  `type` enum('Meeting','Deadline','Restock','Holiday') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `materials`
--

CREATE TABLE `materials` (
  `id` int(11) NOT NULL,
  `material_name` varchar(100) NOT NULL,
  `stock_quantity` int(11) NOT NULL DEFAULT 0,
  `unit` varchar(20) NOT NULL,
  `price_per_unit` decimal(10,2) NOT NULL,
  `category` varchar(50) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `image_url` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `materials`
--

INSERT INTO `materials` (`id`, `material_name`, `stock_quantity`, `unit`, `price_per_unit`, `category`, `created_at`, `image_url`) VALUES
(1, 'Kain Cotton Combed 30s', 150, 'Meter', 42000.00, 'Kain', '2026-02-03 07:08:25', 'https://s3.knitto.co.id/fabrics/warna-kain/img_url/combed-30s-ash-blue-bwb7r.png'),
(2, 'Benang Jahit Putih Astra', 60, 'Roll', 18000.00, 'Benang', '2026-02-03 07:08:25', 'https://image.made-in-china.com/155f0j00GwsQKVTasZzt/100-Spun-Polyester-Sewing-Thread-40-2-5000y-Bleached-White.webp'),
(3, 'Resleting YKK 25cm', 200, 'Pcs', 5000.00, 'Aksesoris', '2026-02-03 07:08:25', 'https://www.istanakancing.com/cdn/shop/files/Strip-_Z_010_1680x.png'),
(4, 'Kain Drill American', 80, 'Meter', 55000.00, 'Kain', '2026-02-03 07:08:25', 'https://i0.wp.com/zaloraadmin.wpcomstaging.com/wp-content/uploads/2025/01/kain-american-drill.png'),
(5, 'Kancing Kemeja Putih', 500, 'Pcs', 500.00, 'Aksesoris', '2026-02-03 07:08:25', 'https://anekabenang.com/cdn/shop/files/id-11134207-7r991-ll4pdt73rhqc44.jpg'),
(6, 'Plastik OPP Bening', 100, 'Pack', 15000.00, 'Packaging', '2026-02-03 07:08:25', 'https://image.made-in-china.com/155f0j00ZslfrEotYuky/Clear-Transparent-Poly-Bag-OPP-Plastic-Bags-T-Shirt-Packaging-Cellopane-Bag.webp'),
(7, 'Toilet', 999, 'Skibidi', 700000.00, 'Packaging', '2026-02-03 09:19:09', 'https://media.sketchfab.com/models/1f7bbfc0955b4f148f55cdc7f2c35c27/thumbnails/45632ab5e38145b49ae6d4053547cf01/170c685528bf4140bb7837134f7d3923.jpeg');

-- --------------------------------------------------------

--
-- Struktur dari tabel `projects`
--

CREATE TABLE `projects` (
  `id` int(11) NOT NULL,
  `project_name` varchar(150) NOT NULL,
  `category` enum('Kemeja','Kaos','Jaket','Celana','Lainnya') NOT NULL,
  `urgency_level` enum('Low','Medium','High','Critical') NOT NULL,
  `status` enum('Pending','Cutting','Sewing','Finishing','Completed') DEFAULT 'Pending',
  `deadline` date NOT NULL,
  `assigned_to` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `projects`
--

INSERT INTO `projects` (`id`, `project_name`, `category`, `urgency_level`, `status`, `deadline`, `assigned_to`) VALUES
(1, 'Seragam Batik SMAN 5', 'Kemeja', 'High', 'Cutting', '2024-03-01', 1),
(2, 'Kaos Event Jalan Sehat', 'Kaos', 'Medium', 'Sewing', '2024-02-28', 1),
(3, 'Jaket Almamater Kampus', 'Jaket', 'Critical', 'Pending', '2024-02-20', 1);

-- --------------------------------------------------------

--
-- Struktur dari tabel `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `full_name` varchar(100) NOT NULL,
  `email` varchar(100) DEFAULT NULL,
  `phone_number` varchar(20) DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `role` varchar(50) NOT NULL,
  `photo_url` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `users`
--

INSERT INTO `users` (`id`, `full_name`, `email`, `phone_number`, `password`, `role`, `photo_url`) VALUES
(1, 'Sabrilia', 'admin@konveksi.com', '81235531683', '$2y$10$BIx0wZ0seeTF8L3W..vJNeL1xw.Tk.ceAzf7QU1LxvpNCEDH1kNc6', 'owner', 'http://192.168.0.162/api_web_fashion/uploads/profiles/user_1_1770134691.jpg'),
(32, 'Raphael', NULL, '81235531689', '$2y$10$ebELW2njB4n.amOCNNcDQeSf.UZV4onk40k1Rqf/NczkyvfGw40vq', 'owner', NULL),
(33, 'Admin', NULL, '787878', '$2y$10$/6vcz.gT96O7r4Ds.jRdDuva0xHNJNM6kh9Qfu626/shHnVEguf/S', 'owner', NULL);

--
-- Indexes for dumped tables
--

--
-- Indeks untuk tabel `calendar_events`
--
ALTER TABLE `calendar_events`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `materials`
--
ALTER TABLE `materials`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `projects`
--
ALTER TABLE `projects`
  ADD PRIMARY KEY (`id`),
  ADD KEY `assigned_to` (`assigned_to`);

--
-- Indeks untuk tabel `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT untuk tabel yang dibuang
--

--
-- AUTO_INCREMENT untuk tabel `calendar_events`
--
ALTER TABLE `calendar_events`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `materials`
--
ALTER TABLE `materials`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT untuk tabel `projects`
--
ALTER TABLE `projects`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT untuk tabel `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=34;

--
-- Ketidakleluasaan untuk tabel pelimpahan (Dumped Tables)
--

--
-- Ketidakleluasaan untuk tabel `projects`
--
ALTER TABLE `projects`
  ADD CONSTRAINT `projects_ibfk_1` FOREIGN KEY (`assigned_to`) REFERENCES `users` (`id`) ON DELETE SET NULL;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
