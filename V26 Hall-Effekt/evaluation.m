%% iterate over temperature files, calculate hole density & mobility, plot result

d = 0.31e-4;        % sample thickness in cm
f = 1;              % correction factor, approximately 1
B = 0.508648;       % magnetic field in T
sgn = (-1).^(1:8);  % signs corresponding to V1...V8

% vector of temperatures, also used for accessing data files
T = [                                                                               82,  85,  87,  90,  93,  95,  98, ...
   103, 105, 110, 116, 120, 125, 130, 135, 140, 145, 150, 155, 160, 165, 170, 175, 180, 185,      191,      195,      ...
   200, 205, 210, 215, 220, 225, 230, 235, 242, 245, 250, 255, 261, 265, 270, 275, 280, 285,      290, 291, 295, 297, 300]';

p = zeros(size(T)); % resistivity \rho in \Ohm cm
m = zeros(size(T)); % mobility    \mu  in cm^2 / Vs

for i=1:length(T)
    data = dlmread(['T',num2str(T(i)),'_both.txt'],'\t');
    % data(:,1) contains voltages V1...V8 for resistivity measurement
    % data(:,3) contains corresponding Hall voltages
    % data(:,[2 4]) is the applied current I = 100 \micro A
    
    if (std([data(1:8,2);data(1:4,4)]) > 1e-6)
        disp('non-uniform current for T = ',num2str(T(i)),'K');
    end
    % calculate resistivity
    I=mean(data(1:8,2)); % average current in A
    p(i) = 1.1331 * f * d / I * sgn*data(1:8,1) / 2;
    
    % calculate mobility
    % no division by 2 as V5...V8 = 0
    m(i) = 2.5e3 * d / (B * I) * abs(sgn*data(1:8,3)) / p(i);
end
