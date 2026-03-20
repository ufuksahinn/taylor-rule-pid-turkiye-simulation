% Taylor Kuralı PID Simülasyonu — Türkiye (2010-2024)
%
% Kullanım:
%   1) Bu dosyanın bulunduğu klasörü MATLAB'da Current Folder yap
%   2) F5 ile çalıştır

clear; clc; close all;
addpath(pwd);

fprintf('--- Veriler okunuyor ---\n');
veri = verileri_oku('veriler');

fprintf('\n--- Potansiyel GDP hesaplanıyor ---\n');
[trend_gdp, output_gap] = potansiyel_gdp(veri.gdp, 6.25);

fprintf('\n--- Taylor PID modeli çalıştırılıyor ---\n');
params.pi_hedef = 5;
params.r_dogal  = 2;
params.Kp       = 1.5;
params.Ki       = 0.3;
params.Kd       = 0.5;
params.beta     = 0.5;

sonuc = para_politikasi(veri, output_gap, params);

fprintf('\n--- Grafikler oluşturuluyor ---\n');
grafikler(sonuc, veri, trend_gdp);

fprintf('\n=== ÖZET TABLO ===\n');
fprintf('%-6s  %-14s  %-14s  %-14s  %-14s\n', ...
    'Yıl', 'Enflasyon%', 'Model%', 'Gerçek%', 'Fark (puan)');
fprintf('%s\n', repmat('-', 1, 66));
for i = 1:length(sonuc.yil)
    fprintf('%-6d  %-14.1f  %-14.1f  %-14.1f  %-14.1f\n', ...
        sonuc.yil(i), veri.enflasyon(i), ...
        sonuc.model(i), sonuc.gercek(i), sonuc.sapma(i));
end
