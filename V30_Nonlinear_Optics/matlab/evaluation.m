%% Evaluation script for V30 Nonlinear optics

warning off MATLAB:gui:latexsup:UnableToInterpretTeXString;
warning off matlab2tikz:deprecatedEnvironment;

%% Plot P and lambda graph
%load('evaluation.mat')
f1=figure;
plot(X1,P)
l1=legend('$15\degree\celsius$','$17\degree\celsius$','$19\degree\celsius$','$21\degree\celsius$','$23\degree\celsius$','$25\degree\celsius$','$27\degree\celsius$','$29\degree\celsius$','$31\degree\celsius$','$33\degree\celsius$','$35\degree\celsius$','Location','northwest');
xlabel('injection current $I(\milli\ampere)$');
ylabel('Detected photo detector power $P(\milli\watt)$');

f2=figure;
plot(X2,lambda,'LineStyle','none','Marker','x','MarkerSize',8)
l2=legend('$15\degree\celsius$','$17\degree\celsius$','$19\degree\celsius$','$21\degree\celsius$','$23\degree\celsius$','$25\degree\celsius$','$27\degree\celsius$','$29\degree\celsius$','$31\degree\celsius$','$33\degree\celsius$','$35\degree\celsius$','Location','northeastoutside');
xlabel('injection current $I(\milli\ampere)$');
ylabel('Wavelength $\lambda(\nano\metre)$');
hold on

%% Polynomial fit for P graph
n=1; %order of polynomial regression
y1=zeros(11,n+1); % data allocation for regression parameters
X3=transpose(220:20:500);
for j=1:11
    y1(j,:)=polyfit(X3,P(7:end,j),n);
end
avg_slope1=mean(y1(:,1));
stdev_slope1=std(y1(:,1));

%% Polynomial fit for lambda graph
 
y2=ones(11,n+1); % data allocation for regression parameters
lambda_lin=zeros(size(lambda));
for i=1:11
    if isnan(lambda(1,i)) % exclude NaN data at the beginning of each column
        y2(i,:)=polyfit(X2(2:end),lambda(2:end,i),n);
    else     
        y2(i,:)=polyfit(X2,lambda(:,i),n);
    end
    lambda_lin(:,i)=polyval(y2(i,:),X2);         
end
plot(X2,lambda_lin);

y2_mod=[y2(1:4,:);y2(6:end,:)];

% calculate relative temp.-dependent gap between slopes
X4=transpose([15:2:21,25:2:35]); % temperatures in °C
y3=polyfit(X4,y2_mod(:,2),n);

avg_slope2=mean(y2_mod(:,1));
stdev_slope2=std(y2_mod(:,1));

%% Compute mean lifetime of 3->2 energy level transition
tau=[5.85*0.5, 0.4*0.5;4*0.5, 1.1*0.2;5*0.5,0.42*0.5];
mean_tau=[mean(tau(:,2)),std(tau(:,2))];

%% Wavelength dependence of Power output P_1064 while P_Diode kept constant
% for P_Diode=50,100,150mW
% evaluate from P graph
I_min50=(50-y1(1,2))/y1(1,1);
I_max50=(50-y1(11,2))/y1(11,1);
I_gap50=I_max50-I_min50;
I_min100=(100-y1(1,2))/y1(1,1);
I_max100=(100-y1(11,2))/y1(11,1);
I_gap100=I_max100-I_min100;
I_min150=(150-y1(1,2))/y1(1,1);
I_max150=(150-y1(11,2))/y1(11,1);
I_gap150=I_max150-I_min150;

% evaluate from lambda graph
x_lambda50  = y3(2)+avg_slope2*(I_min50 + (P_lambda1064(:,1)-15)./20.*I_gap50 ) + y3(1).*P_lambda1064(:,1);
x_lambda100 = y3(2)+avg_slope2*(I_min100+ (P_lambda1064(:,1)-15)./20.*I_gap100) + y3(1).*P_lambda1064(:,1);
x_lambda150 = y3(2)+avg_slope2*(I_min150+ (P_lambda1064(:,1)-15)./20.*I_gap150) + y3(1).*P_lambda1064(:,1);

f4=figure;
plot(x_lambda50,P_lambda1064(:,4),x_lambda100,P_lambda1064(:,3),x_lambda150,P_lambda1064(:,2),'LineStyle','none','Marker','x','MarkerSize',8);
xlabel('Wavelength $\lambda(\nano\metre)$');
ylabel('Detected photo detector power $P(\milli\watt)$');

%% Power output P_1064 of the Nd:YAG depending on input power P_808
% max Nd:YAG power output at lambda=808nm resp. T=
f5=figure;
p_max=polyval(y1(8,:), P1064_P808(:,1)); % not taking I<220mA into account
plot(p_max,P1064_P808(:,2),'LineStyle','none','Marker','x','MarkerSize',8);
xlabel('Laser diode input power $P_\text{Diode,808}(\milli\watt)$');
ylabel('Detected photo detector power $P_{1064}(\milli\watt)$');
hold on
y5=polyfit(p_max,P1064_P808(:,2),n);
P1064_lin=polyval(y5,p_max);
plot(p_max,P1064_lin,'r');

%% Power output of the frequency-doubled P_532 depending on P_1064
f6=figure;
P6_808  = polyval(y1(8,:), P532_P808(:,1));
P6_1064 = polyval(y5, P6_808);
plot(P6_1064,P532_P808(:,2),'LineStyle','none','Marker','x','MarkerSize',8)
xlabel('Expected fundamental power $P_{1064}(\milli\watt)$');
ylabel('Detected second harmonic power $P_{532}(\milli\watt)$');
hold on
y6=polyfit(P6_1064,P532_P808(:,2),2);
P532_lin=polyval(y6,P6_1064);
plot(P6_1064,P532_lin,'r');

% matlab2tikz('P.tex', 'width', '0.9\textwidth','figurehandle',f1, 'encoding','UTF-8', 'showInfo', false, 'parseStrings', false);
% matlab2tikz('lambda1.tex', 'width', '0.9\textwidth','figurehandle',f2, 'encoding','UTF-8', 'showInfo', false, 'parseStrings', false);
% matlab2tikz('lambda2.tex', 'width', '0.9\textwidth','figurehandle',f4, 'encoding','UTF-8', 'showInfo', false, 'parseStrings', false);
% matlab2tikz('P1064.tex', 'width', '0.9\textwidth','figurehandle',f5, 'encoding','UTF-8', 'showInfo', false, 'parseStrings', false);
% matlab2tikz('P532.tex', 'width', '0.9\textwidth','figurehandle',f6, 'encoding','UTF-8', 'showInfo', false, 'parseStrings', false);