load('pre_data.mat')

% magnetic field in function of the applied current
fig1 = figure;
em = polyfit(Elektromagnet(:,1), Elektromagnet(:,2)*0.1172, 1);
plot(Elektromagnet(:,1),Elektromagnet(:,2)*0.1172, 'o')
hold on
plot(Elektromagnet(:,1), em(1)*Elektromagnet(:,1) + em(2), 'k')
axis([0 15 0 0.6])
xlabel('Strom $I_M$ (A)')
ylabel('Magnetfeldstärke $B$ (T)')
matlab2tikz('B(I).tex', 'width', '\textwidth', 'encoding','UTF-8', ...
            'figurehandle', fig1, 'showInfo', false, 'parseStrings', false);


% characteristic curve
fig2 = figure;
kl = polyfit(Kennlinie(:,1), Kennlinie(:,2), 1);
plot(Kennlinie(:,1), Kennlinie(:,2), 'o')
hold on
plot(Kennlinie(:,1), kl(1)*Kennlinie(:,1) + kl(2), 'k')
axis([0 150 0 700])
xlabel('Strom $I~(\mu\ampere)$')
ylabel('Spannung $U$ (mV)')
matlab2tikz('U(I).tex', 'width', '\textwidth', 'encoding','UTF-8', ...
            'figurehandle', fig2, 'showInfo', false, 'parseStrings', false);


% Hall voltage in function of the angle
fig3 = figure;
plot(Ausrichtung(:,1),Ausrichtung(:,2), 'o')
hold on
% 1 degree offset
plot(-96:5:94, 9.65+1.15*cosd(-95:5:95), 'k')
axis([-95 95 9.6 10.85])
xlabel('Winkel $\alpha$ (\degree)')
ylabel('Transversale Spannung $U_t$ (mV)')
matlab2tikz('U(alpha).tex', 'width', '\textwidth', 'encoding','UTF-8', ...
            'figurehandle', fig3, 'showInfo', false, 'parseStrings', false);