function [relTol, absTol] = analyzeRelAbsTol(y)
[rows, cols] = size(y);
relTol = ones(rows-1, cols);
absTol = ones(rows-1, cols);
for i = 1:cols
    for j = 1:rows-1 
        relTol(j,i) = (abs(y(j,i)) - abs(y(j+1,i)))/min(abs(y(j,i)), abs(y(j+1,i)));
        absTol(j,i) = abs(y(j,i) - y(j+1,i));
    end
end