%% script to read data

d = 0.31e-4% sample thickness in cm
f_a=1;% lazy assumption

T=[82];
for i=1:length(T)
    data=dlmread(['T',num2str(T(i)),'_both.txt'],'\t');
    if (std([data(1:8,2);data(1:4,4)]) > 1e-6)
        disp('non-uniform current for T = ',num2str(T(i)),'K');
    end
    % resistivity
    I=mean(data(1:8,2)); % average current in mA
    p=d*1.1331*sum(data(2:2:8,1)-data(1:2:7,1))/2;
end



