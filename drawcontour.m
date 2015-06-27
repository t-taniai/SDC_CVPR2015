function [ seg ] = drawcontour( img, contour, thickness, col )
if nargin < 3
    thickness = 1;
end
if nargin < 4
    col = [255, 255, 255];
end
SiErode  = imerode(contour, strel('disk', thickness, 0));
SiDilate = imdilate(contour, strel('disk', thickness, 0));
contour  = xor(SiErode, SiDilate);
imgR = squeeze(img(:,:,1));
imgG = squeeze(img(:,:,2));
imgB = squeeze(img(:,:,3));
imgR(contour) = col(1);
imgG(contour) = col(2);
imgB(contour) = col(3);
seg(:,:,1) = imgR;
seg(:,:,2) = imgG;
seg(:,:,3) = imgB;

end

