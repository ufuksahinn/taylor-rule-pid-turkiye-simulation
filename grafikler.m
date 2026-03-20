function grafikler(sonuc, veri, trend_gdp)
% Simülasyon sonuçlarını 5 ayrı grafik olarak kaydeder.

if ~exist('results', 'dir'), mkdir('results'); end

yil      = sonuc.yil;
siyah    = [0.00 0.00 0.00];
koyu     = [0.35 0.35 0.35];
acik     = [0.65 0.65 0.65];

% Pandemi ve sonrası dönem (faiz politikasının büyümeyi desteklediği yıllar)
donem_bas = 2020;
donem_son = 2022;

% --- Grafik 1: Enflasyon ---
f1 = figure('Position', [50 50 800 450]);
plot(yil, veri.enflasyon, '-', 'Color', siyah, 'LineWidth', 1.8);
hold on;
yline(sonuc.params.pi_hedef, '--', 'Color', acik, 'LineWidth', 1.2);
xregion(donem_bas, donem_son, 'FaceColor', acik, 'FaceAlpha', 0.18);
hold off;
xlabel('Yıl'); ylabel('(%)');
title('Türkiye TÜFE Enflasyonu (2010–2024)');
legend('Gerçek enflasyon', sprintf('Hedef (%%%d)', sonuc.params.pi_hedef), ...
    'Pandemi dönemi', 'Location', 'northwest');
grid on; box off; xlim([min(yil) max(yil)]);
exportgraphics(f1, fullfile('results','fig1_enflasyon.png'), 'Resolution', 150);

% --- Grafik 2: Faiz karşılaştırması ---
f2 = figure('Position', [100 50 800 450]);
plot(yil, sonuc.model,  '-',  'Color', koyu,  'LineWidth', 1.8); hold on;
plot(yil, sonuc.gercek, '--', 'Color', siyah, 'LineWidth', 1.8);
xregion(donem_bas, donem_son, 'FaceColor', acik, 'FaceAlpha', 0.18);
hold off;
xlabel('Yıl'); ylabel('(%)');
title('Faiz Oranı: Taylor PID Simülasyonu vs Gerçek (2010–2024)');
legend('Taylor PID (model)', 'Gerçek faiz (TCMB)', 'Pandemi dönemi', 'Location', 'northwest');
grid on; box off; xlim([min(yil) max(yil)]);
exportgraphics(f2, fullfile('results','fig2_faiz_karsilastirma.png'), 'Resolution', 150);

% --- Grafik 3: Model farkı ---
f3 = figure('Position', [150 50 800 450]);
bar(yil, sonuc.sapma, 'FaceColor', koyu, 'EdgeColor', 'none'); hold on;
yline(0, '-', 'Color', siyah, 'LineWidth', 1.0);
xregion(donem_bas, donem_son, 'FaceColor', acik, 'FaceAlpha', 0.25);
hold off;
xlabel('Yıl'); ylabel('Puan farkı');
title('Model Farkı: Taylor PID − Gerçek Faiz (2010–2024)');
legend('Fark (puan)', 'Sıfır çizgisi', 'Pandemi dönemi', 'Location', 'northwest');
grid on; box off; xlim([min(yil)-0.5 max(yil)+0.5]);
exportgraphics(f3, fullfile('results','fig3_model_farki.png'), 'Resolution', 150);

% --- Grafik 4: Output gap ---
f4 = figure('Position', [200 50 800 450]);
bar(yil, sonuc.gap, 'FaceColor', koyu, 'EdgeColor', 'none'); hold on;
yline(0, '-', 'Color', siyah, 'LineWidth', 1.0); hold off;
xlabel('Yıl'); ylabel('(%)');
title('Output Gap — Potansiyel GDP Sapması (2010–2024)');
legend('Output gap (%)', 'Location', 'southwest');
grid on; box off; xlim([min(yil)-0.5 max(yil)+0.5]);
exportgraphics(f4, fullfile('results','fig4_output_gap.png'), 'Resolution', 150);

% --- Grafik 5: PID terimleri ---
f5 = figure('Position', [250 50 800 450]);
plot(yil, sonuc.params.Kp * sonuc.hata,    '-',  'Color', siyah, 'LineWidth', 1.8); hold on;
plot(yil, sonuc.params.Ki * sonuc.birikim, '--', 'Color', koyu,  'LineWidth', 1.8);
plot(yil, sonuc.params.Kd * sonuc.degisim, ':',  'Color', acik,  'LineWidth', 1.8);
yline(0, '-', 'Color', [0.85 0.85 0.85], 'LineWidth', 0.8); hold off;
xlabel('Yıl'); ylabel('Katkı (puan)');
title('Taylor PID — P, I ve D Terimlerinin Katkısı (2010–2024)');
legend('P (anlık hata)', 'I (birikimli hata)', 'D (değişim hızı)', 'Location', 'northwest');
grid on; box off; xlim([min(yil) max(yil)]);
exportgraphics(f5, fullfile('results','fig5_pid_terimleri.png'), 'Resolution', 150);

fprintf('5 grafik kaydedildi → results/\n');
end
