# Taylor Kuralı PID Simülasyonu — Türkiye (2010–2024)

Para politikasını kontrol teorisi çerçevesinde modelleyen bir MATLAB projesi. Taylor Kuralı, PID kontrolör denklemine dönüştürülmüş ve Türkiye'nin gerçek faiz kararlarıyla karşılaştırılmıştır.

---

## Arka Plan

Klasik Taylor Kuralı (1993), merkez bankalarının enflasyon ve büyüme sapmasına göre faiz belirlemesini matematiksel olarak tanımlar. Bu proje, söz konusu denklemi standart PID formuna yeniden yazar ve simüle eder:

```
i(t) = r* + π(t) + Kp·e(t) + Ki·∫e dt + Kd·ė(t) + β·gap(t)
```

| Sembol | Açıklama |
|---|---|
| `e(t) = π(t) − π*` | Enflasyon hatası |
| `Kp, Ki, Kd` | PID kazançları |
| `gap(t)` | Output gap (HP filtresi ile hesaplanır) |
| `r*` | Doğal reel faiz |

---

## Proje Yapısı

```
├── main.m                  # Ana script
├── verileri_oku.m          # CSV yükleme ve zaman ekseni hizalama
├── potansiyel_gdp.m        # Hodrick-Prescott filtresi
├── para_politikasi.m       # Taylor PID modeli ve model farkı
├── grafikler.m             # 5 ayrı figure (results/ klasörüne kaydedilir)
├── veriler/
│   ├── enflasyon.csv
│   ├── faiz.csv
│   └── gdp.csv
├── results/                # Grafik çıktıları
└── veri_indir.py           # World Bank API'den veri çekme
```

---

## Kurulum

### Gereksinimler
- MATLAB R2021a veya üzeri
- Python 3 + `requests` + `pandas`

### Adımlar

```bash
# 1. Veriyi indir
pip install requests pandas
python veri_indir.py

# 2. MATLAB'da çalıştır
# Proje klasörünü Current Folder yap, ardından:
main
```

---

## Parametreler

`main.m` içinden değiştirilebilir:

```matlab
params.pi_hedef = 5;    % enflasyon hedefi (%)
params.r_dogal  = 2;    % doğal reel faiz (%)
params.Kp       = 1.5;
params.Ki       = 0.3;
params.Kd       = 0.5;
params.beta     = 0.5;  % output gap ağırlığı
```

---

## Sonuçlar

Model, 2010–2019 döneminde gerçek faizle makul uyum göstermektedir. 2020 sonrasında ise fark belirgin biçimde açılmaktadır. Bu durum, Taylor modelinin büyüme öncelikli politika tercihlerini — pandemi borçlanmasının azaltılması ve ekonominin desteklenmesi gibi — yapısal olarak yansıtamamasından kaynaklanmaktadır. 2022'de model ile gerçek faiz arasındaki fark 216 puana ulaşmıştır.

---

## Veri Kaynakları

| Değişken | Gösterge | Kaynak |
|---|---|---|
| Enflasyon | `FP.CPI.TOTL.ZG` | World Bank |
| Faiz | `FR.INR.DPST` | World Bank |
| GDP | `NY.GDP.MKTP.KN` | World Bank |

---

## Veri Kısıtı

World Bank, ülke verilerini yayımlamadan önce ulusal istatistik kurumlarından derleme ve doğrulama süreci yürütür. Bu süreç genellikle 1–2 yıl sürmektedir. Dolayısıyla veri seti çekildiği tarih itibarıyla yalnızca 2024'e kadar tamamlanmış veri içermektedir; 2025 ve sonrası henüz yayımlanmamıştır.

---

## Referanslar

- Taylor, J. B. (1993). Discretion versus policy rules in practice. *Carnegie-Rochester Conference Series on Public Policy*, 39, 195–214.
- Hodrick, R. J., & Prescott, E. C. (1997). Postwar U.S. business cycles. *Journal of Money, Credit and Banking*, 29(1), 1–16.
- World Bank Open Data. (2024). World Development Indicators. https://data.worldbank.org
