%-- 19.01.2015 12:44 --%
index = 9;
extract
y=y(x>3.15 & x<4.2);
x=x(x>3.15 & x<4.2);
lin = fit( x(x>4), y(x>4), 'poly1');
y = y ./ feval(lin,x);
plot(x,y);
ylabel('normalized transmission intensity')
xlabel('Frequency \nu in GHz')
legend('Peak 1', 'Location','NorthWest')
print('-dpdf', 'peak1');

index = 3;
extract
lin = fit( x([1 end]), y([1 end]), 'poly1');
y = y ./ feval(lin,x);
plot(x,y);
y = y - 0.02;
therm = fit(x,1-y,'gauss1','Exclude', x>4.26 & x<4.46)
lamb = (1-y)./ feval(therm,x);
plot(therm,x,1-y)
legend('Peak 2', 'fit: doppler broadened peak', 'Location','NorthWest')
xlabel('Frequency \nu in GHz')
ylabel('normalized absorption')
print('-dpdf', 'peak2');

lamb2 = lamb(x>4.1 & x<4.5);
x2 = x(x>4.1 & x<4.5);
lfit = fit(x2,1-lamb2,'gauss4')
plot(lfit, x2, 1-lamb2, '-')
xlabel('Frequency \nu in GHz')
ylabel('additional transmission due to lamb dips')
legend('Peak 2', 'multi-gaussian fit', 'Location','NorthWest')
print('-dpdf', 'peak2_detail');

index = 5;
extract
plot(x,y)
extract
lin = fit( x([1 end]), y([1 end]), 'poly1');
y2 = y ./ feval(lin,x);
plot(x,y2)
extract
ylabel('additional transmission due to lamb dips')
plot(x,y2-1)
extract
ylabel('additional transmission due to lamb dips')
legend('Peak 3', 'Location','NorthWest')
print('-dpdf', 'peak3');

index=13;
extract
y = y(1:2150);
x = x(1:2150);
plot(x,y)
y4 = 1-y2;
y4 = y4 - 0.0011;
y3 = y4( (x>3.48 & x< 3.52) | (x>3.925 & x<4.2) );
x3 = x( (x>3.48 & x< 3.52) | (x>3.925 & x<4.2) );
gauss = fit( x3,y3, 'gauss1')
plot(gauss,x,y4)
ylabel('normalized absorption'),
xlabel('Frequency \nu in GHz')
legend('Peak 4', 'fit: doppler broadened peak', 'Location','NorthWest')
print('-dpdf', 'peak4');

lamb = y4./feval(gauss, x);
plot(x,lamb)
plot(gauss,x,y4)
lamb2 = y4-feval(gauss, x);
plot(x,lamb2)
xl = x(x<3.32 | x>4.1);
yl = 1 + lamb2(x<3.32 | x>4.1);
gauss_l = fit( xl,yl, 'gauss1')
plot(gauss_l, xl,yl)

lamb3 = (lamb2+1)./feval(gauss_l,x);
plot(x,lamb3)
legend('Peak 4')
xlabel('Frequency \nu in GHz')
ylabel('normalized absorption'),
print('-dpdf', 'peak4_detail');


%-- 20.01.2015 03:04 --%
% FMS

a = 2e-6 * 2*pi*5000;

index = 15;
extract
fig1 = figure();
plot(x,y)
lin = fit( x([1 end]), y([1 end]), 'poly1')
y = y - feval(lin,x);
legend('Peak 1')
ylabel('differential transmission')
xlabel('Frequency \nu in GHz')
print(fig1, '-dpdf', 'peak1_fms');

yf = filter(a, [1 a-1], y);
plot(x,yf);
plot(x,yf+0.0013*x -0.00538, [3 4], [0 0]);
xlim([3 4])
legend('Peak 1, filtered', 'Location','NorthWest')

index = 14;
extract
fig3 = figure();
plot(x,y)
legend('Peak 3')
ylabel('differential transmission')
xlabel('Frequency \nu in GHz')
print(fig3, '-dpdf', 'peak3_fms');

yf = filter(a, [1 a-1], y);
plot(x,yf+0.03*x- 0.119)
xlim([3.43 4.05]);
legend('Peak 3, filtered', 'Location','NorthWest')
print(fig3, '-dpdf', 'peak3_filter');