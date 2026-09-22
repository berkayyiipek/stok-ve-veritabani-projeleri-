# stok-ve-veritabani-projeleri-
Proje
# Stok ve Veritabanı Projeleri

Üretim ve stok yönetimi alanında geliştirdiğim iki örnek proje.

## 📊 1. Excel ile Stok Takip Sistemi

Ürün bazlı giriş/çıkış hareketlerini, güncel stok seviyesini ve kritik stok
uyarısını otomatik hesaplayan bir Excel tablosu.

**Kullanılan yöntemler:**
- Formüllerle otomatik stok hesaplama (Açılış + Giriş - Çıkış)
- IF fonksiyonuyla durum sınıflandırması (Kritik / Düşük / Yeterli)
- Koşullu biçimlendirme ile görsel uyarı sistemi
- Ayrı bir sayfada stok hareket geçmişi (log) takibi

📁 Dosya: `stok_takip_sistemi.xlsx`

## 🗄️ 2. SQL ile İlişkisel Veritabanı Tasarımı

Ürün, kategori, satış ve satış detay tablolarından oluşan basit bir
ilişkisel veritabanı ve raporlama sorguları.

**Kullanılan yöntemler:**
- CREATE TABLE ile ilişkisel tablo tasarımı (FOREIGN KEY ile bağlantı)
- JOIN ve GROUP BY ile çok tablolu raporlama
- Ürün bazlı ciro, müşteri bazlı sipariş, kritik stok raporu sorguları
