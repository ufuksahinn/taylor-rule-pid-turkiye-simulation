"""
Türkiye Ekonomik Veri İndirme v4
=================================
Kaynak: World Bank açık API
  - Enflasyon: FP.CPI.TOTL.ZG
  - Faiz:      FR.INR.DPST (deposit rate) + FR.INR.LEND (lending rate)
  - GDP:       NY.GDP.MKTP.KN
"""

import pandas as pd
import requests
import os

SAVE_DIR = r"C:\Users\ufuks\OneDrive\Masaüstü\Projeler\faiz_enflasyon_kontrolcusu\veriler"
os.makedirs(SAVE_DIR, exist_ok=True)

def wb_get(indicator, country="TR", start=2010, end=2025):
    url = (f"https://api.worldbank.org/v2/country/{country}"
           f"/indicator/{indicator}"
           f"?format=json&per_page=100&date={start}:{end}")
    r = requests.get(url, timeout=15)
    r.raise_for_status()
    raw = r.json()
    if len(raw) < 2 or raw[1] is None:
        raise ValueError("Bos veri")
    rows = []
    for d in raw[1]:
        if d["value"] is not None:
            rows.append({
                "tarih": pd.to_datetime(f"{d['date']}-01-01"),
                "deger": float(d["value"])
            })
    if not rows:
        raise ValueError("Hic satir yok")
    df = pd.DataFrame(rows).set_index("tarih").sort_index()
    return df

print("=" * 60)
print("Türkiye Veri Indirme v4")
print("=" * 60)

# 1. Enflasyon
print("\n[1/3] Enflasyon...")
try:
    enf = wb_get("FP.CPI.TOTL.ZG")
    enf.columns = ["enflasyon_yuzde"]
    p = os.path.join(SAVE_DIR, "enflasyon.csv")
    enf.to_csv(p)
    print(f"   OK  {len(enf)} satir, son: %{enf.iloc[-1,0]:.1f} ({enf.index[-1].year})")
except Exception as e:
    print(f"   HATA: {e}")

# 2. Faiz — önce deposit rate, olmazsa lending rate dene
print("\n[2/3] Faiz orani...")
faiz_bulundu = False
for kod, isim in [("FR.INR.DPST", "deposit rate"),
                   ("FR.INR.LEND", "lending rate"),
                   ("FR.INR.RINR", "reel faiz")]:
    try:
        faiz = wb_get(kod)
        faiz.columns = ["faiz_yuzde"]
        p = os.path.join(SAVE_DIR, "faiz.csv")
        faiz.to_csv(p)
        print(f"   OK  {isim} — {len(faiz)} satir, son: %{faiz.iloc[-1,0]:.1f} ({faiz.index[-1].year})")
        faiz_bulundu = True
        break
    except Exception as e:
        print(f"   {kod} ({isim}): {e}")

if not faiz_bulundu:
    print("   Tum faiz kodlari baskisiz — manuel CSV gerekiyor")

# 3. GDP
print("\n[3/3] GDP...")
try:
    gdp = wb_get("NY.GDP.MKTP.KN")
    gdp.columns = ["gdp_sabit_usd"]
    p = os.path.join(SAVE_DIR, "gdp.csv")
    gdp.to_csv(p)
    print(f"   OK  {len(gdp)} satir, son: {gdp.iloc[-1,0]:.3e} ({gdp.index[-1].year})")
except Exception as e:
    print(f"   HATA: {e}")

print("\n" + "=" * 60)
for f in ["enflasyon.csv", "faiz.csv", "gdp.csv"]:
    fp = os.path.join(SAVE_DIR, f)
    if os.path.exists(fp):
        print(f"  OK    {f}  ({os.path.getsize(fp)/1024:.1f} KB)")
    else:
        print(f"  EKSIK {f}")
print("=" * 60)
