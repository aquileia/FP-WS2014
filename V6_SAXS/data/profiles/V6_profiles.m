clear all;
close all;

xG = (-20:0.1:160)';
yG = zeros(1801,3);
files = {'Gunier_Reference.txt', 'Gunier_Silicon_powder.txt', 'Gunier_Polymer.txt'};
for n=1:length(files)
    data = dlmread(files{n});
    y = data(:,2);
    [~,I] = max(y);
    y = y(I-200:I+1600);
    yG(:,n) = y;
end;
% yG(:,3) = yG(:,3) + 10000;
% yG(:,1) = 0.35*yG(:,1);
fig1 = figure();
plot(xG,yG)
xlabel('Position $x$ in mm');
ylabel('Intensity $I$');
legend('reference crystal', 'silicon powder', 'unstretched polymer');

warning off matlab2tikz:deprecatedEnvironment
matlab2tikz('Guinier.tex', 'width', '\textwidth', 'encoding','UTF-8', ...
           'figurehandle', fig1, 'showInfo', false, 'parseStrings', false);