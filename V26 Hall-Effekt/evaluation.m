%% iterate over temperature files, plot hole density & mobility

% (c) Sebastian Koelle 2014
% GPL3 licence

% constants and parametres
e   = 1.60217656535e-19;% electron charge
m_e = 9.10938291e-31;   % electron mass
k_B = 1.38064881e-23;   % Boltzmann constant
h   = 6.62606957e-34;   % Planck constant
mde = 0.3216 * m_e;     % effective mass of an electron
mdh = 0.689 * m_e;      % effective mass of a hole
d   = 0.31e-4;          % sample thickness in cm
f   = 1;                % correction factor, approximately 1
B   = 0.508648;         % magnetic field in T
sgn = (-1).^(1:8);      % signs corresponding to V1...V8

% vector of temperatures, also used for accessing data files
T = [                         82,  85,  90,  93,  95,  98, 103, ...
    105, 110, 116, 120, 125, 130, 135, 140,      145,      150, ...
    155, 160, 165, 170, 175, 180, 185, 191,      195,      200, ...
    205, 210, 215, 220, 225, 230, 235, 242,      245,      250, ...
    255, 261, 265, 270, 275, 280, 285, 290, 291, 295, 297, 300]';
% discarded one outlier @ 87K

[rho,R,m,p] = deal(zeros(size(T)));
% rho = resistivity      \rho in \Ohm cm
% R   = hall coefficient R_H  in cm^3 / C
% m   = mobility         \mu  in cm^2 / Vs
% p   = hole density     p    in cm^{-3}

for i=1:length(T)
    data = dlmread(['T',num2str(T(i)),'_both.txt'],'\t');
    % data(:,1) contains voltages V1...V8 for resistivity measurement
    % data(:,3) contains corresponding Hall voltages
    % data(:,[2 4]) is the applied current I = 100 \micro A
    
    if (std([data(1:8,2);data(1:4,4)]) > 1e-6)
        disp('non-uniform current for T = ',num2str(T(i)),'K');
    end
    
    I=mean(data(1:8,2)); % average current in A
    rho(i) = 1.1331 * f * d / I * sgn*data(1:8,1) / 2;
    R(i)   = 2.5e3 * d / (B * I) * sgn*data(1:8,3);
    p(i)   = 1 / (R(i) * e);
    m(i)   = abs(R(i)) / rho(i);
end

% density of states in the valence band, in cm^{-3}
Nv   = @(T)       2 * (2*pi*mdh*k_B*T).^(3/2) ./ (100*h)^3;
% hole density equation
p_eq = @(Ea,Na,x) 2*Na./(1+sqrt( 1+16*Na./Nv(x).*exp(Ea*0.001*e/k_B./x) ));
p_approx = @(Ea,Na,x) 1/2 * sqrt(Na*Nv(x)).*exp(-Ea*0.001*e./(2*k_B*x));

% p_opt defines bounds for [Na Ea] in meV
p_opt = fitoptions('Method','NonlinearLeastSquares', ...
       'Lower', [25 1.5e18], 'Upper', [50 2e18], 'StartPoint',[32 1.8e18]);

% p_fct contains the model for p(x)
p_fct = fittype(p_eq, 'options', p_opt);

p_fit = fit(T, p, p_fct);

p_coeff  = num2cell(coeffvalues(p_fit));
[Ea, Na] = p_coeff{:};
% Ea = 31.73  (31.07, 32.4)

% Arrhenius-Plot von p(T)
%f1 = figure('Units','normalized','Position',[0 0 1 1]);
set(gca,'FontSize',14);
f1a = semilogy(1000./T,p, 'o', 'LineWidth', 2);
hold on;
f1b = semilogy(1000./T,p_eq(Ea,Na,T), 'k--', 'LineWidth', 2);
f1c = semilogy(1000./T,p_approx(Ea,Na,T), 'k:', 'LineWidth', 2);
ylabel('Löcherdichte p (cm^{-3})');
xlabel('inverse Temperatur 1000/T (K^{-1})');
legend('Messwerte', 'Gleichung \eqref{p_ex}', 'Gleichung \eqref{p_ap}');
%print(f1,'-dpng', pic);

%f2 = figure('Units','normalized','Position',[0 0 1 1]);
%f2a = loglog(T,m);
%ylabel('\mu (cm^2 / Vs)');
%xlabel('T (K)');
