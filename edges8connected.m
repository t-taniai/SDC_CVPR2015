function [E,W] = edges8connected(height,width)

E = edges4connected(height, width);
W = ones(size(E,1), 1);

N = height*width;
I = []; J = [];
% connect neighbors 5 and 6
is = [1:N-height]'; is([height:height:N-height])=[];
js = is+1+height;
I = [I;is;js];
J = [J;js;is];
% connect neighbors 7 and 8
is = is+1;
js = js-1;
I = [I;is;js];
J = [J;js;is];

E = [E;I,J];
W = [W;ones(size(I,1),1)*sqrt(2.0)];

end