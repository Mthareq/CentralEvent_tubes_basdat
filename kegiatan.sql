SET NAMES utf8mb4;
DROP DATABASE IF EXISTS kegiatan;
CREATE DATABASE kegiatan CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE kegiatan;

CREATE TABLE user (
    id_user INT AUTO_INCREMENT PRIMARY KEY,
    nama VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(25) NOT NULL,
    role_global ENUM('admin', 'ketua', 'anggota') NOT NULL DEFAULT 'anggota',
    status_akun ENUM('aktif', 'nonaktif') NOT NULL DEFAULT 'aktif'
) ENGINE=InnoDB;

CREATE TABLE divisi (
    id_divisi INT AUTO_INCREMENT PRIMARY KEY,
    nama_divisi VARCHAR(100) NOT NULL,
    deskripsi TEXT
) ENGINE=InnoDB;

CREATE TABLE anggota_divisi (
    id_anggota_divisi INT AUTO_INCREMENT PRIMARY KEY,
    id_user INT NOT NULL,
    id_divisi INT NOT NULL,
    jabatan ENUM('koordinator', 'anggota') NOT NULL DEFAULT 'anggota',
    tanggal_bergabung DATE NOT NULL,
    CONSTRAINT fk_anggota_divisi_user FOREIGN KEY (id_user) REFERENCES user(id_user),
    CONSTRAINT fk_anggota_divisi_divisi FOREIGN KEY (id_divisi) REFERENCES divisi(id_divisi)
) ENGINE=InnoDB;

CREATE TABLE status_jobdesk (
    id_status INT AUTO_INCREMENT PRIMARY KEY,
    nama_status VARCHAR(50) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE jobdesk (
    id_jobdesk INT AUTO_INCREMENT PRIMARY KEY,
    id_divisi INT NOT NULL,
    id_pembuat INT NOT NULL,
    id_status INT NOT NULL,
    judul_jobdesk VARCHAR(100) NOT NULL,
    deskripsi TEXT,
    prioritas ENUM('rendah', 'sedang', 'tinggi') NOT NULL DEFAULT 'sedang',
    deadline DATETIME NOT NULL,
    tanggal_dibuat DATETIME NOT NULL,
    CONSTRAINT fk_jobdesk_divisi FOREIGN KEY (id_divisi) REFERENCES divisi(id_divisi),
    CONSTRAINT fk_jobdesk_pembuat FOREIGN KEY (id_pembuat) REFERENCES user(id_user),
    CONSTRAINT fk_jobdesk_status FOREIGN KEY (id_status) REFERENCES status_jobdesk(id_status)
) ENGINE=InnoDB;

CREATE TABLE penugasan (
    id_penugasan INT AUTO_INCREMENT PRIMARY KEY,
    id_jobdesk INT NOT NULL,
    id_user INT NOT NULL,
    peran_penugasan ENUM('koordinator', 'pelaksana') NOT NULL DEFAULT 'pelaksana',
    tanggal_penugasan DATETIME NOT NULL,
    CONSTRAINT fk_penugasan_jobdesk FOREIGN KEY (id_jobdesk) REFERENCES jobdesk(id_jobdesk),
    CONSTRAINT fk_penugasan_user FOREIGN KEY (id_user) REFERENCES user(id_user)
) ENGINE=InnoDB;

CREATE TABLE inventaris (
    id_inventaris INT AUTO_INCREMENT PRIMARY KEY,
    nama_barang VARCHAR(100) NOT NULL,
    stok INT NOT NULL DEFAULT 0,
    satuan VARCHAR(30) NOT NULL,
    kondisi ENUM('baik', 'rusak') NOT NULL DEFAULT 'baik'
) ENGINE=InnoDB;

CREATE TABLE status_permintaan (
    id_status_permintaan INT AUTO_INCREMENT PRIMARY KEY,
    nama_status VARCHAR(50)
) ENGINE=InnoDB;

CREATE TABLE permintaan_barang (
    id_permintaan INT AUTO_INCREMENT PRIMARY KEY,
    id_divisi INT NOT NULL,
    id_pembuat INT NOT NULL,
    id_status_permintaan INT NOT NULL,
    tanggal_permintaan DATETIME NOT NULL,
    catatan TEXT,
    CONSTRAINT fk_permintaan_barang_divisi FOREIGN KEY (id_divisi) REFERENCES divisi(id_divisi),
    CONSTRAINT fk_permintaan_barang_pembuat FOREIGN KEY (id_pembuat) REFERENCES user(id_user),
    CONSTRAINT fk_permintaan_barang_status FOREIGN KEY (id_status_permintaan) REFERENCES status_permintaan(id_status_permintaan)
) ENGINE=InnoDB;

CREATE TABLE detail_permintaan (
    id_detail INT AUTO_INCREMENT PRIMARY KEY,
    id_permintaan INT NOT NULL,
    id_inventaris INT,
    nama_barang VARCHAR(100) NOT NULL,
    jumlah INT NOT NULL,
    satuan VARCHAR(30) NOT NULL,
    catatan TEXT,
    CONSTRAINT fk_detail_permintaan_permintaan FOREIGN KEY (id_permintaan) REFERENCES permintaan_barang(id_permintaan),
    CONSTRAINT fk_detail_permintaan_inventaris FOREIGN KEY (id_inventaris) REFERENCES inventaris(id_inventaris)
) ENGINE=InnoDB;

CREATE TABLE riwayat_aktivitas (
    id_riwayat INT AUTO_INCREMENT PRIMARY KEY,
    id_user INT NOT NULL,
    id_jobdesk INT,
    id_permintaan INT,
    aktivitas VARCHAR(100) NOT NULL,
    nilai_lama TEXT,
    nilai_baru TEXT,
    waktu_aktivitas DATETIME NOT NULL,
    CONSTRAINT fk_riwayat_aktivitas_user FOREIGN KEY (id_user) REFERENCES user(id_user),
    CONSTRAINT fk_riwayat_aktivitas_jobdesk FOREIGN KEY (id_jobdesk) REFERENCES jobdesk(id_jobdesk),
    CONSTRAINT fk_riwayat_aktivitas_permintaan FOREIGN KEY (id_permintaan) REFERENCES permintaan_barang(id_permintaan)
) ENGINE=InnoDB;