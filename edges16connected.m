function [E,W] = edges16connected(height,width)

[E,W] = edges8connected(height, width);

N = height*width;
I = []; J = [];
% connect neighbors 9 and A
is = [1:N-height]'; is([height:height:N-height])=[]; is([height-1:height-1:(height-1)*(width-1)])=[];
js = is+2+height;
I = [I;is;js];
J = [J;js;is];
% connect neighbors B and C
is = is+2;
js = js-2;
I = [I;is;js];
J = [J;js;is];

% connect neighbors D and E
is = [1:N-height*2]'; is([height:height:N-height*2])=[];
js = is+1+height*2;
I = [I;is;js];
J = [J;js;is];
% connect neighbors F and G
is = is+2*height;
js = js-2*height;
I = [I;is;js];
J = [J;js;is];

E = [E;I,J];
W = [W;ones(size(I,1),1)*sqrt(5.0)];

end