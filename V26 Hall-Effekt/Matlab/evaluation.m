%% iterate over temperature files, plot hole density & mobility

% (c) Sebastian Koelle 2014
% GPL3 licence

%% constants and parametres
e   = 1.60217656535e-19;% electron charge
m_e = 9.10938291e-31;   % electron mass
k_B = 1.38064881e-23;   % Boltzmann constant
h   = 6.62606957e-34;   % Planck constant
mde = 0.3216 * m_e;     % effective mass of an electron
mdh = 0.689 * m_e;      % effective mass of a hole
Mc  = 6;                % conduction band minimum at X points, 6 thereof
Eg  = 1.15;             % band gap in eV
d   = 0.31e-4;          % sample thickness in cm
f   = 1;                % correction factor, approximately 1
B   = 0.508648;         % magnetic field in T
sgn = (-1).^(1:8);      % signs corresponding to V1...V8

% vector of temperatures, also used for accessing data files
% this list has to be created manually (depends on measurement)
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


%% calculate resistivity, hole density and mobility for each file
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


%% anonymous functions describing charge carrier densities
% density of states in the valence band, in cm^{-3}
Nv   = @(T) ...
    2 * (2*pi*mdh*k_B*T).^(3/2) ./ (100*h)^3;

% hole density equation
p_eq = @(Ea,Na,x) ...
    2 * Na./(1+sqrt( 1+16*Na./Nv(x).*exp(Ea*0.001*e/k_B./x) ));

p_approx = @(Ea,Na,x) ...
    1/2 * sqrt(Na*Nv(x)).*exp(-Ea*0.001*e./(2*k_B*x));

p_intrinsic = @(Eg,x) ...
    4.9e15*(0.3216*0.689)^(3/4)*sqrt(Mc*x.^3).*exp(-Eg*e./(2*k_B*x));


% p_opt defines bounds for [Na Ea] in meV
p_opt = fitoptions('Method','NonlinearLeastSquares', ...
       'Lower', [25 1.5e18], 'Upper', [50 2e18], 'StartPoint',[32 1.8e18]);

% p_fct contains the model for p(x)
p_fct = fittype(p_eq, 'options', p_opt);

p_fit = fit(T, p, p_fct);

% read and display the fit coefficients
p_coeff  = num2cell(coeffvalues(p_fit));
[Ea, Na] = p_coeff{:};
disp(['Bandlücke: ', num2str(Ea), ' meV']);
disp(['Akzeptor-Konzentration: ', num2str(Na), ' /cm^3']);

% 95% confidence interval: Ea = 31.7  (31.1, 32.4)
% Na doesn't seem to be varied as the start value already matches


%% Arrhenius-plot of the hole density p(T)
fig1 = figure;
set(gca,'FontSize',14);
semilogy(1000./T,p, 'o', 'LineWidth', 1.5);
hold on;

%define plot ranges for the theory curves
Tn  = 1000:200:3000;
Tg = logspace(1.9,3.5);

% now the theory for reference:
semilogy(1000./Tn,p_intrinsic(Eg,Tn), 'g:', 'LineWidth', 2);
semilogy(1000./Tg,p_eq(Ea,Na,Tg), 'k', 'LineWidth', 2);
semilogy(1000./Tg,p_approx(Ea,Na,Tg), 'r:', 'LineWidth', 2);

% axis lables and limits
ylim([9e16 1e20]);
ylabel('Löcherdichte $p~(\centi\metre^{-3})$');
xlim([0 12.5]);
xlabel('inverse Temperatur 1000/$T~(\kelvin^{-1})$');
legend('Messwerte', 'Gleichung \eqref{eq:p_intrinsic}', ...
       'Gleichung \eqref{eq:density_p}', 'Gleichung \eqref{eq:p_approx}');
hold off;


%% double-logarithmic plot of the mobility \mu(T)
fig2 = figure;      %('Units','normalized','Position',[0 0 1 1]);
loglog(T,m, 'o', 'LineWidth', 1.5);
hold on;

% draw asymptotic behavior: T^{3/2} and T^{-3/2}
% you might have to play with these values c1...c3 to match your data:
c = [6.3e5 0.61 0.38];
loglog([170 300], c(1)*[170 300].^(-3/2), 'k', 'LineWidth', 1.5);
loglog([38 63]  , c(2)*[35 60]  .^(3/2),  'r', 'LineWidth', 1.5);
loglog([46.5 83], c(3)*[46.5 83].^(3/2),  'g', 'LineWidth', 1.5);

% axis lables and limits
ylabel('Beweglichkeit $\mu~(\centi\metre^2/\volt\second)$');
xlim([40 300]);
xlabel('Temperatur $T$ (K)');
legend('Messwerte', '$c_1 \cdot T^{-3/2}$', ...
       '$c_2 \cdot T^{3/2}$', '$c_3 \cdot T^{3/2}$');
hold off;


%% Output with matlab2tikz:
if(exist('matlab2tikz.m','file'))
    matlab2tikz('p(T).tex', 'width', '\textwidth', 'encoding','UTF-8', ...
           'figurehandle', fig1, 'showInfo', false, 'parseStrings', false);

    matlab2tikz('mu(T).tex', 'width', '\textwidth', 'encoding','UTF-8', ...
           'figurehandle', fig2, 'showInfo', false, 'parseStrings', false);

% Output in case matlab2tikz isn't available:
else
    disp('matlab2tikz not available, switching to pdf output');
    print(fig1,'-dpdf', 'p(T)');
    print(fig2,'-dpdf', 'mu(T)');
end
