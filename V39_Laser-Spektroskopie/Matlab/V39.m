%% Process absorption spectra 
function [ ] = V39(index, lines)
global gof spec model x y

model = 'poly2';

data = dlmread(['TEK' sprintf('%04d', index) '.CSV'], ',', 'D1..E2500');
rep = find(data(:,2) ~= data(1,2),1);
x = 3.774-255.55*data(rep:end,1);
y = data(rep:end,2);
% normalize intensity (correct slope)
if (lines > 1)
    [rough, gof] = fit(x,y,model,'Robust','on');
    fine = refine_fit(rough);
    ultra = refine_fit(fine);
    plot(ultra,'r-',x,y,'k.',spec,'g.')
    y = y ./ feval(ultra,x);
elseif  (lines == 1)
    lin = fit( x([1 end]), y([1 end]), 'poly1');
    y = y ./ feval(lin,x);
    plot(x,y)
end


% P1 = fit(x,1-y,'gauss1', 'Exclude', x<-15 | x> -9);
% P2 = fit(x,1-y,'gauss1', 'Exclude', x< -5 | x>  2);
% P3 = fit(x,1-y,'gauss1', 'Exclude', x<  7 | x> 13);
% P4 = fit(x,1-y,'gauss1', 'Exclude', x< 13 | x> 18);
% 
% plot(P1,x,1-y, 'k.')
% hold on
% plot(P2)
% plot(P3)
% plot(P4)
% hold off
% 
% legend('data', legend_fit(P1), legend_fit(P2), ...
%                legend_fit(P3), legend_fit(P4), 'Location','NorthWest')
end


%% Use a fit to discard outliers and fit again
function [new_fit] = refine_fit(old_fit)
global gof  spec model x y

    ind = abs (y - feval(old_fit,x)) > gof.rmse;
    spec = excludedata(x,y,'indices',ind);
    [new_fit, gof] = fit(x,y,model,'Robust','on','Exclude',spec);
end

%% Format a tolerance interval in physical notation

function [coeff] = format_tol(c, dc)
    n = floor(log10(dc/3));
    dc_r = ceil(dc*10^-n)*10^n;
    % c_r = round(dc*10^-n)*10^n;
    format = ['%0.' num2str(-n) 'f'];
    coeff = [sprintf(format,c) ' \pm ' sprintf(format,dc_r) ];
end

%% Prepare legend entry for gaussian fit
function [entry] = legend_fit(fit)

    h = [coeffvalues(fit); confint(fit)];
    c = h(1,:);
    dc = max(h(3,:)-c, c-h(2,:));
    entry = ['µ = ' format_tol(c(2), dc(2)) ' , ' ...
             '\sigma = ' format_tol(c(3)/sqrt(2), dc(3)/sqrt(2))];
end



% global x y
% V39(4,1)
% y = y - 0.02;
% therm = fit(x,1-y,'gauss1','Exclude', x>9.4 & x<10.3)
% lamb = (1-y)./ feval(therm,x);
% lamb= lamb(xl<10.5);
% xl= xl(xl<10.5);
% plot(xl,1-lamb, '.');
