global gof spec x y

i = 0;
% for i=0:16
    data = dlmread(['TEK' sprintf('%04d', i) '.CSV'], ',', 'D1..E2500');
    rep = find(data(:,2) ~= data(1,2),1);
    x = data(rep:end,1);
    y = data(rep:end,2);
    % normalize intensity (correct slope)
    if ismember(i,[0,1,10])
        [rough, gof] = fit(x,y,'poly2','Robust','on');
        fine = refine_fit(rough);
        ultra = refine_fit(fine);
      % plot(fine,'r-',x,y,'k.',spec,'g.')
        y = y ./ feval(ultra,x);
    end;
% end;

P1 = fit(x,1-y,'gauss1', 'Exclude', x<-0.015 | x>-0.009);
P2 = fit(x,1-y,'gauss1', 'Exclude', x<-0.005 | x> 0.002);
P3 = fit(x,1-y,'gauss1', 'Exclude', x< 0.007 | x> 0.013);
P4 = fit(x,1-y,'gauss1', 'Exclude', x< 0.013 | x> 0.018);

plot(P1,x,1-y)
hold on
plot(P2)
plot(P3)
plot(P4)
hold off