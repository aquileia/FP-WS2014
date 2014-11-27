% get a list of the 3d data files:
% find . -type f -size +20k -iname "*.csv" > csv.txt

fileID = fopen('csv.txt');
C = textscan(fileID, '%s');
C = C{1};
fclose(fileID);

for i=1:size(C)
    trunc_csv(C{i});
end