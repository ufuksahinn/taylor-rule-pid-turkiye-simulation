function sonuc = para_politikasi(veri, output_gap, params)
% Taylor Kuralını PID kontrolör formunda uygular.
%
% Denklem:
%   i(t) = r* + π(t) + Kp·e(t) + Ki·Σe + Kd·Δe + β·gap(t)
%   e(t) = π(t) - π*  →  enflasyonun hedeften sapması

if nargin < 3, params = struct(); end
if ~isfield(params,'pi_hedef'), params.pi_hedef = 5;   end
if ~isfield(params,'r_dogal'),  params.r_dogal  = 2;   end
if ~isfield(params,'Kp'),       params.Kp       = 1.5; end
if ~isfield(params,'Ki'),       params.Ki       = 0.3; end
if ~isfield(params,'Kd'),       params.Kd       = 0.5; end
if ~isfield(params,'beta'),     params.beta     = 0.5; end

e      = veri.enflasyon - params.pi_hedef;
birikim = cumsum(e);
degisim = [0; diff(e)];

faiz_model = params.r_dogal       ...
           + veri.enflasyon       ...
           + params.Kp * e        ...
           + params.Ki * birikim  ...
           + params.Kd * degisim  ...
           + params.beta * output_gap;

sonuc.yil     = veri.yil;
sonuc.model   = faiz_model;
sonuc.gercek  = veri.faiz;
sonuc.hata    = e;
sonuc.birikim = birikim;
sonuc.degisim = degisim;
sonuc.gap     = output_gap;
sonuc.sapma   = faiz_model - veri.faiz;
sonuc.params  = params;

gecerli = ~isnan(veri.faiz);
rmse = sqrt(mean((faiz_model(gecerli) - veri.faiz(gecerli)).^2));
fprintf('Model çalıştırıldı — RMSE: %.2f puan\n', rmse);
fprintf('  Kp=%.2f  Ki=%.2f  Kd=%.2f  beta=%.2f\n', ...
    params.Kp, params.Ki, params.Kd, params.beta);
end
