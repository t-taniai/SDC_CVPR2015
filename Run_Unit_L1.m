
[height, width, ch] = size(img);
N = height*width;

% Compute an image with bin index
qimg = floor(double(img)/256.0*z) + 1;
binImg =  qimg(:,:,1) + (qimg(:,:,2)-1)*z + (qimg(:,:,3)-1)*z*z;
binNum = z*z*z;

% Set the data term
inputHF = ComputeHistogram(binImg, binNum, groundtruth, 1);
Fz =  @(z, x) abs(inputHF(z) - x).^1; % For L1
%Fz =  @(z, x) abs(inputHF(z) - x).^2; % For L2

% Set the smoothness term
lambda = 0.5; % for L1
% lambda = 1.0; % for L2
epsilon = 0.5; % for L1 and L2
imgR = double(img(:,:,1));
imgG = double(img(:,:,2));
imgB = double(img(:,:,3));
E4 = edges4connected(height,width);
sigma2 = mean( ((imgR(E4(:,1))-imgR(E4(:,2))).^2 + (imgG(E4(:,1))-imgG(E4(:,2))).^2 + (imgB(E4(:,1))-imgB(E4(:,2))).^2).^1.0 );
SmFunc = @(img, E, W) ( max(exp(-((imgR(E(:,1))-imgR(E(:,2))).^2 + (imgG(E(:,1))-imgG(E(:,2))).^2 + (imgB(E(:,1))-imgB(E(:,2))).^2) /(sigma2 * 2.0)), ones(size(W))* epsilon)) ./W * lambda;

% Initialize the Segmentation as all foreground
S0 = true(height, width);

tic;
[S, Energy, Data, Cuts] = SDC_GEO(S0, Fz, img, binImg, binNum, 16, SmFunc, 50, 8, 2.5);
toc
Smooth = Energy - Data;
EPN = sum(sum(xor(groundtruth,S)));
EPR = EPN/N * 100;
EOR = EPN/sum(sum(groundtruth)) * 100;
nData = Data/N;
nEnergy = Energy/N;