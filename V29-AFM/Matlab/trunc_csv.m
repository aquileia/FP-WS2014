function [ ] = trunc_csv( file )
data = csvread(file);
n = size(data,1);
step = sqrt(n);
if (mod(log2(step),1)~=0)
    error([file ': matrix dimension ~= 2^n']);
end
zn = data(n,3);

nz_lines = find(data(1:step:n,3) ~= zn);
y = nz_lines(end);
if (y > 0.9*step || data(step*y+10,3) ~= zn)
    return
end
nmax= step * y;
csvwrite( ['t-' file], data(1:nmax,:) );
end
