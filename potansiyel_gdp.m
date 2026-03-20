function [trend, sapma] = potansiyel_gdp(gdp, lambda)
% Hodrick-Prescott filtresiyle ekonominin potansiyel büyüme trendini çıkarır.
% lambda: yıllık veri için 6.25 kullanılır (Hodrick-Prescott, 1997).

if nargin < 2
    lambda = 6.25;
end

N = length(gdp);
D = spdiags([ones(N,1) -2*ones(N,1) ones(N,1)], 0:2, N-2, N);
I = speye(N);

trend = (I + lambda * (D' * D)) \ gdp;
sapma = 100 * (gdp - trend) ./ trend;

fprintf('Potansiyel GDP hesaplandı (lambda=%.2f)\n', lambda);
fprintf('  Output gap: min=%.2f%%  maks=%.2f%%\n', min(sapma), max(sapma));
end
