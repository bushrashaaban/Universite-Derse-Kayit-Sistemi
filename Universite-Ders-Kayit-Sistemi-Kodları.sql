--  ÜNİVERSİTE DERSE KAYIT SİSTEMİ
-- MS SQL Server kullanılarak geliştirilmiş; öğrenci, akademisyen, 
-- ders seçimi ve notlandırma süreçlerini içeren veritabanı projesi.
CREATE DATABASE Universite_d_k_s;
GO

USE Universite_d_k_s
GO

CREATE TABLE tDanismanlar
(
    DanismanlarID INT IDENTITY (1,1) not null PRIMARY KEY,
    İsim NVARCHAR(15) not null,
    Soyisim NVARCHAR (31) not null
);
GO

CREATE TABLE tOgretimGorevlileri
(
    OgretimGorevlileriID INT IDENTITY (1,1) not null PRIMARY KEY,
    İsim NVARCHAR(15) not null,
    Soyisim NVARCHAR (31) not null,
    GorevliNumarasi CHAR (10) UNIQUE not null,
    Eposta VARCHAR (63) UNIQUE not null,
    Adres NVARCHAR(127) not null
);
GO

CREATE TABLE tOgrenciler
(
    OgrencilerID INT IDENTITY (1,1) not null PRIMARY KEY,
    İsim NVARCHAR(15) not null,
    Soyisim NVARCHAR (31) not null,
    OgrenciNumarasi CHAR (10) UNIQUE not null,
    Eposta VARCHAR (63) UNIQUE not null,
    -- İlişki: Her öğrencinin bir danışmanı vardır.
    DanismanlarID_OgrencilerID INT, 
    CONSTRAINT FK_DanismanlarID_OgrencilerID FOREIGN KEY (DanismanlarID_OgrencilerID) REFERENCES tDanismanlar(DanismanlarID)
);
GO

CREATE TABLE tSiniflar
(
    SiniflarID INT IDENTITY (1,1) not null PRIMARY KEY,
    İsmi NVARCHAR(31) not null,
    SiraSayisi int null,
    Projektor VARCHAR(7),
    CHECK (Projektor IN ('Var', 'Yok'))
);
GO

CREATE TABLE tDersler
(
    DerslerID INT IDENTITY (1,1) not null PRIMARY KEY,
    İsmi NVARCHAR(63) not null,
    OgretimGorevlileriID_DerslerID INT, 
    CONSTRAINT FK_OgretimGorevlileriID_DerslerID FOREIGN KEY (OgretimGorevlileriID_DerslerID) REFERENCES tOgretimGorevlileri(OgretimGorevlileriID),
    SiniflarID_DerslerID INT, 
    CONSTRAINT FK_SiniflarID_DerslerID FOREIGN KEY (SiniflarID_DerslerID) REFERENCES tSiniflar(SiniflarID)
);
GO

CREATE TABLE tDersKayitlari
(
    DersKayitlariID INT IDENTITY (1,1) not null PRIMARY KEY,
    DerslerID_DersKayitleriID INT, 
    CONSTRAINT FK_DerslerID_DersKayitleriID FOREIGN KEY (DerslerID_DersKayitleriID) REFERENCES tDersler(DerslerID),
    OgrencilerID_DersKayitlariID INT, 
    CONSTRAINT FK_OgrencilerID_DersKayitlariID FOREIGN KEY (OgrencilerID_DersKayitlariID) REFERENCES tOgrenciler(OgrencilerID)
);
GO

CREATE TABLE tNotlar
(
    NotlarID INT IDENTITY (1,1) not null PRIMARY KEY,
    Puan INT not null,
    DerslerID_NotlarID INT, 
    CONSTRAINT FK_DerslerID_NotlarID FOREIGN KEY (DerslerID_NotlarID) REFERENCES tDersler(DerslerID),
    OgrencilerID_NotlarID INT, 
    CONSTRAINT FK_OgrencilerID_NotlarID FOREIGN KEY (OgrencilerID_NotlarID) REFERENCES tOgrenciler(OgrencilerID)
);
GO

CREATE TABLE tDersOnayi
(
    DersOnayiID INT IDENTITY (1,1) not null PRIMARY KEY,
    OnayTarihi DATE not null,
    DanismanlarID_DersOnayiID INT, 
    CONSTRAINT FK_DanismanlarID_DersOnayiID FOREIGN KEY (DanismanlarID_DersOnayiID) REFERENCES tDanismanlar(DanismanlarID),
    OgrencilerID_DersOnayiID INT, 
    CONSTRAINT FK_OgrencilerID_DersOnayiID FOREIGN KEY (OgrencilerID_DersOnayiID) REFERENCES tOgrenciler(OgrencilerID)
);
GO

-- VERİ GİRİŞİ (INSERT) İŞLEMLERİ
-- Veri tabanı şeması hazırlandıktan sonra, ilişkileri doğrulamak ve veri akışını görmek için kullanılan örnek veri girişleri:
USE Universite_d_k_s
GO

INSERT INTO tDanismanlar(İsim, Soyisim)
VALUES ( 'Dilara', 'Demir')
GO

-- Öğrenci eklenirken Danışman ID (1) de eklendi:
INSERT INTO tOgrenciler(İsim, Soyisim, OgrenciNumarasi, Eposta, DanismanlarID_OgrencilerID)
VALUES ( 'Fatma', 'Demir', 'B231306560', 'abcde@gmail.com', 1)
GO

INSERT INTO tOgretimGorevlileri(İsim, Soyisim, GorevliNumarasi, Eposta, Adres)
VALUES ( 'Mehmet', 'Yilmaz', '1111111111', 'mehmet@uni.edu.tr', 'Serdivan')
GO

INSERT INTO tSiniflar(İsmi, SiraSayisi, Projektor)
VALUES ( 'B132', '60', 'Var')
GO

INSERT INTO tDersler(İsmi, OgretimGorevlileriID_DerslerID, SiniflarID_DerslerID)
VALUES ( 'Veri Tabani Yonetimi', 1, 1)
GO

INSERT INTO tDersKayitlari(DerslerID_DersKayitleriID, OgrencilerID_DersKayitlariID)
VALUES ( 1, 1)
GO

INSERT INTO tNotlar(Puan, DerslerID_NotlarID, OgrencilerID_NotlarID)
VALUES ( 95, 1, 1)
GO

INSERT INTO tDersOnayi(OnayTarihi, DanismanlarID_DersOnayiID, OgrencilerID_DersOnayiID)
VALUES ( '2024-09-18', 1, 1)
GO

/*
-- VERİ TABANI SIFIRLAMA / TEMİZLEME (OPTIONAL RESET)
USE Universite_d_k_s
GO

ALTER TABLE tOgrenciler DROP CONSTRAINT FK_DanismanlarID_OgrencilerID
GO
ALTER TABLE tDersler DROP CONSTRAINT FK_OgretimGorevlileriID_DerslerID, FK_SiniflarID_DerslerID
GO
ALTER TABLE tDersKayitlari DROP CONSTRAINT FK_DerslerID_DersKayitleriID, FK_OgrencilerID_DersKayitlariID
GO
ALTER TABLE tNotlar DROP CONSTRAINT FK_DerslerID_NotlarID, FK_OgrencilerID_NotlarID
GO
ALTER TABLE tDersOnayi DROP CONSTRAINT FK_DanismanlarID_DersOnayiID, FK_OgrencilerID_DersOnayiID
GO

DROP TABLE tDersOnayi, tNotlar, tDersKayitlari, tDersler, tOgrenciler, tSiniflar, tOgretimGorevlileri, tDanismanlar
GO
*/
