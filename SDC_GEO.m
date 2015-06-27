
function [labeling,energy,dataTerm, cuts] = SDC_GEO(S0, Fz, img, binImg, binNum, neighbor, SmFunc, T, th_a, th_kappa)

[height, width, ch] = size(img);
N = height*width;
Si = true(height, width);
if ~isempty(S0)
    Si = S0;
end

doubleImg = im2double(img);

% construct graph
% E is a set of neighbor pairs (p, q), direction-aware
if ( neighbor == 4 )
    E = edges4connected(height,width);
    W = ones(size(E,1), 1);
elseif ( neighbor == 8 )
    [E,W] = edges8connected(height,width);
elseif ( neighbor == 16 )
    [E,W] = edges16connected(height,width);
end
EW = SmFunc(img,E,W);
A0 = sparse(E(:,1),E(:,2),EW,N,N,neighbor*N);

entireHist  = ComputeHistogram(binImg, binNum, true(height, width), 1);

gamma = 10^2;
erodeW = 5;
% for SC-DIST
% gamma = 0;
% erodeW = 0;

hGraph = BK_Create(N, neighbor*N/2);
BK_SetNeighbors(hGraph, A0);


for t = 1:T
    % Compute the robust geodesic distance in 
    % | A. Criminisi, T. Sharp, and A. Blake:
    % | "GeoS: Geodesic Image Segmentation" (ECCV 2008)
    SiOuter = ComputeGeodesicDistanceImage(doubleImg, double( Si), gamma, 5) <= erodeW;
    SiInner = ComputeGeodesicDistanceImage(doubleImg, double(~Si), gamma, 5) > erodeW;
    distOuter = ComputeGeodesicDistanceImage(doubleImg, double( SiInner), gamma, 5) - erodeW;
    distInner = ComputeGeodesicDistanceImage(doubleImg, double(~SiOuter), gamma, 5) - erodeW;
    dist = zeros(height, width);
    dist( Si) = +distInner( Si);
    dist(~Si) = -distOuter(~Si);
    
    currentHist = ComputeHistogram(binImg, binNum, Si, 1);
    [permImg, groupsize] = ComputeGroupedPermutation(binImg, double(dist), entireHist, currentHist, t, th_a, th_kappa);
    fC1 = (Fz(binImg, permImg) - Fz(binImg, permImg-groupsize))./groupsize;
    fC0 = zeros(height, width);
    
    % Compute the max-flow min-cut using a dynamic maxflow algorithm (with the BK-maxflow in PAMI 2004) in
    % | P. Kohli and P. H.S. Torr:
    % | "Efficiently Solving Dynamic Markov Random Fields Using Graph Cuts"
    % | (ICCV 2005)
    BK_SetUnary(hGraph, [fC0(:)'; fC1(:)']);
    flow = BK_Minimize(hGraph)
    labels = BK_GetLabeling(hGraph);
    Sj = Si;
    Si = reshape(labels,[height width]) > 1;
    
    % ----- visualize img with boundary -----
    imshow(drawcontour2(img, Si));
    drawnow;
    
    if sum(sum(xor(Si, Sj))) <= 0.00001*N && t >= 3
        break;
    end
end
BK_Delete(hGraph);

labeling = Si;
currentHist = ComputeHistogram(binImg, binNum, Si, 1);
dataTerm = sum(Fz(1:binNum, currentHist(1:binNum)));
pairwise = sum( EW(Si(E(:,1)) ~= Si(E(:,2))) ) / 2;
energy = pairwise + dataTerm;
cuts = t;

end