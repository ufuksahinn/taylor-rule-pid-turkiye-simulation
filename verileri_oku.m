function veri = verileri_oku(klasor)
% Enflasyon, faiz ve büyüme verilerini okur, ortak yıl eksenine hizalar.

enf  = readtable(fullfile(klasor, 'enflasyon.csv'));
faiz = readtable(fullfile(klasor, 'faiz.csv'));
gdp  = readtable(fullfile(klasor, 'gdp.csv'));

enf_yil  = year(datetime(enf.tarih));
faiz_yil = year(datetime(faiz.tarih));
gdp_yil  = year(datetime(gdp.tarih));

yil_bas = max([min(enf_yil), min(faiz_yil), min(gdp_yil)]);
yil_son = min([max(enf_yil), max(faiz_yil), max(gdp_yil)]);
yillar  = (yil_bas:yil_son)';
N = length(yillar);

enflasyon = nan(N,1);
faiz_oran = nan(N,1);
buyume    = nan(N,1);

for i = 1:N
    y = yillar(i);
    idx = find(enf_yil  == y, 1); if ~isempty(idx), enflasyon(i) = enf.enflasyon_yuzde(idx); end
    idx = find(faiz_yil == y, 1); if ~isempty(idx), faiz_oran(i) = faiz.faiz_yuzde(idx);     end
    idx = find(gdp_yil  == y, 1); if ~isempty(idx), buyume(i)    = gdp.gdp_sabit_usd(idx);   end
end

veri.yil       = yillar;
veri.enflasyon = enflasyon;
veri.faiz      = faiz_oran;
veri.gdp       = buyume;

fprintf('Veri okundu: %d yıl (%d-%d)\n', N, yil_bas, yil_son);
end
