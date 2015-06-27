function [ seg ] = drawcontour2( img, contour, thickness, colIn, colOut )
if nargin < 3
    thickness = 1;
end
if nargin < 4
    colIn = [255, 0, 0];
end
if nargin < 5
    colOut = [255, 255, 255];
end

seg = drawcontour(img, contour, thickness*3, colOut);
seg = drawcontour(seg, contour, thickness, colIn);

end

