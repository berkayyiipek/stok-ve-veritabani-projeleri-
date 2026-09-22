-- ============================================================
-- SATIŞ VE STOK VERİTABANI (Basit Örnek Proje)
-- Berkay İpek
-- Amaç: Ürün, stok ve satış hareketlerini ilişkisel tablolarda
--        tutup temel raporlama sorguları çalıştırmak.
-- ============================================================

DROP TABLE IF EXISTS satis_detay;
DROP TABLE IF EXISTS satis;
DROP TABLE IF EXISTS urun;
DROP TABLE IF EXISTS kategori;

-- ------------------------------------------------------------
-- 1. TABLOLAR
-- ------------------------------------------------------------

CREATE TABLE kategori (
    kategori_id     INTEGER PRIMARY KEY,
    kategori_adi    TEXT NOT NULL
);

CREATE TABLE urun (
    urun_id         INTEGER PRIMARY KEY,
    urun_kodu       TEXT NOT NULL UNIQUE,
    urun_adi        TEXT NOT NULL,
    kategori_id     INTEGER NOT NULL,
    birim_fiyat     REAL NOT NULL,
    stok_miktari    INTEGER NOT NULL DEFAULT 0,
    min_stok        INTEGER NOT NULL DEFAULT 0,
    FOREIGN KEY (kategori_id) REFERENCES kategori(kategori_id)
);

CREATE TABLE satis (
    satis_id        INTEGER PRIMARY KEY,
    satis_tarihi    TEXT NOT NULL,
    musteri_adi     TEXT NOT NULL
);

CREATE TABLE satis_detay (
    satis_detay_id  INTEGER PRIMARY KEY,
    satis_id        INTEGER NOT NULL,
    urun_id         INTEGER NOT NULL,
    miktar          INTEGER NOT NULL,
    birim_fiyat     REAL NOT NULL,
    FOREIGN KEY (satis_id) REFERENCES satis(satis_id),
    FOREIGN KEY (urun_id) REFERENCES urun(urun_id)
);

-- ------------------------------------------------------------
-- 2. ÖRNEK VERİ
-- ------------------------------------------------------------

INSERT INTO kategori (kategori_id, kategori_adi) VALUES
    (1, 'Bağlantı Elemanı'),
    (2, 'Hammadde'),
    (3, 'Elektrik'),
    (4, 'Yedek Parça'),
    (5, 'Sarf Malzeme');

INSERT INTO urun (urun_id, urun_kodu, urun_adi, kategori_id, birim_fiyat, stok_miktari, min_stok) VALUES
    (1, 'STK-001', 'Vida M6x20',            1, 15.50,  380, 50),
    (2, 'STK-002', 'Saç Sacı 2mm',          2, 220.00, 350, 40),
    (3, 'STK-003', 'Motor Kablosu 1.5mm',   3, 8.75,   700, 100),
    (4, 'STK-004', 'Contalama Lastiği',     4, 32.00,  170, 30),
    (5, 'STK-005', 'Ambalaj Kutusu Büyük',  5, 12.00,  250, 50);

INSERT INTO satis (satis_id, satis_tarihi, musteri_adi) VALUES
    (1, '2026-09-02', 'Arçelik A.Ş.'),
    (2, '2026-09-05', 'Kabel Sanayi'),
    (3, '2026-09-10', 'Hawk Power Enerji'),
    (4, '2026-09-15', 'Turalı Group'),
    (5, '2026-09-18', 'Simpro Elektronik');

INSERT INTO satis_detay (satis_detay_id, satis_id, urun_id, miktar, birim_fiyat) VALUES
    (1, 1, 1, 120, 15.50),
    (2, 1, 3, 200, 8.75),
    (3, 2, 2, 50,  220.00),
    (4, 3, 4, 80,  32.00),
    (5, 3, 5, 100, 12.00),
    (6, 4, 1, 60,  15.50),
    (7, 5, 3, 150, 8.75);

-- ------------------------------------------------------------
-- 3. RAPORLAMA SORGULARI
-- ------------------------------------------------------------

-- 3.1 Ürün bazında toplam satış adedi ve cirosu
SELECT
    u.urun_kodu,
    u.urun_adi,
    SUM(sd.miktar)                     AS toplam_satis_adedi,
    SUM(sd.miktar * sd.birim_fiyat)    AS toplam_ciro
FROM satis_detay sd
JOIN urun u ON u.urun_id = sd.urun_id
GROUP BY u.urun_id
ORDER BY toplam_ciro DESC;

-- 3.2 Müşteri bazında toplam sipariş cirosu
SELECT
    s.musteri_adi,
    COUNT(DISTINCT s.satis_id)         AS siparis_sayisi,
    SUM(sd.miktar * sd.birim_fiyat)    AS toplam_ciro
FROM satis s
JOIN satis_detay sd ON sd.satis_id = s.satis_id
GROUP BY s.musteri_adi
ORDER BY toplam_ciro DESC;

-- 3.3 Kritik stok seviyesindeki ürünler (yeniden sipariş gerekenler)
SELECT
    urun_kodu,
    urun_adi,
    stok_miktari,
    min_stok
FROM urun
WHERE stok_miktari <= min_stok * 1.5
ORDER BY stok_miktari ASC;

-- 3.4 Kategori bazında stok değeri
SELECT
    k.kategori_adi,
    SUM(u.stok_miktari * u.birim_fiyat) AS toplam_stok_degeri
FROM urun u
JOIN kategori k ON k.kategori_id = u.kategori_id
GROUP BY k.kategori_id
ORDER BY toplam_stok_degeri DESC;

-- 3.5 Aylık toplam satış cirosu (tarih bazlı trend)
SELECT
    strftime('%Y-%m', s.satis_tarihi)  AS ay,
    SUM(sd.miktar * sd.birim_fiyat)    AS aylik_ciro
FROM satis s
JOIN satis_detay sd ON sd.satis_id = s.satis_id
GROUP BY ay
ORDER BY ay;
