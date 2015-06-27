function [ A ] = ComputeHistogram( binImg, binNum, mask, label )
if nargin < 3
    mask = true(size(binImg,1),size(binImg,2));
end
if nargin < 4
    label = 1;
end

if ( label == 0 )
    mask = ~mask;
end

index = binImg(mask);
num = size(index, 1);

A = sparse(index, ones(num, 1), ones(num, 1), binNum, 1);
A = full(A);
end
