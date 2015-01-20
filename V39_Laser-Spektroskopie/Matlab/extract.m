global x y

data = dlmread(['TEK' sprintf('%04d', index) '.CSV'], ',', 'D1..E2500');
rep = find(data(:,2) ~= data(1,2),1);
x = 3.774-255.55*data(rep:end,1);
y = data(rep:end,2);

ylabel('normalized transmission intensity')
xlabel('Frequency \nu in GHz')