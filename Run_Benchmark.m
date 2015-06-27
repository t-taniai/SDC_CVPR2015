% We use a MATLAB wrapper of the Boykov-Kolmogorov maxflow algorithm
% available at http://vision.csd.uwo.ca/code/
addpath('../Bk_matlab');

% Change the place of the dataset
images = dir('F:/dataset/GrabCut/image/*.png');
groundtruths = dir('F:/dataset/GrabCut/boundary_GT/*.png');

imagenum = size(images,1);
EPRs = zeros(imagenum, 1);
EPR2s = zeros(imagenum, 1);
EORs = zeros(imagenum, 1);
ENGs = zeros(imagenum, 1);
DATAs = zeros(imagenum, 1);
SMOOTHs = zeros(imagenum, 1);
nDATAs = zeros(imagenum, 1);
nENGs = zeros(imagenum, 1);
nCuts = zeros(imagenum, 1);

% Number of bins per channel
z = 64;

dir_name = 'TEST';
dir_name = strcat(dir_name, num2str(z));
dir_labels = strcat('results/', dir_name, '/labels/');
dir_border = strcat('results/', dir_name, '/border/');
dir_masked = strcat('results/', dir_name, '/masked/');
mkdir(strcat('results/', dir_name));
mkdir(dir_labels);
mkdir(dir_border);
mkdir(dir_masked);
fp = fopen(strcat('results/', dir_name, '/benchmark.txt'), 'w');

fprintf(fp, '%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n', 'FILE', 'EPR', 'EOR', 'Cuts', 'Energy', 'Data', 'Smooth', 'N');
for i = 1:imagenum
    file = strrep(images(i).name, '.png', '');
    img = imread(strcat('F:/dataset/GrabCut/image/', file, '.png'));
    groundtruth = imread(strcat('F:/dataset/GrabCut/boundary_GT/', file, '.png')) == 255;

    Run_Unit_L1;
    
    ENGs(i) = Energy;
    DATAs(i) = Data;
    SMOOTHs(i) = Smooth;
    EPRs(i) = EPR;
    EORs(i) = EOR;
    nENGs(i) = nEnergy;
    nDATAs(i) = nData;
    nCuts(i) = Cuts;
    
    imwrite(S, strcat(dir_labels, file, '.png') );
    imwrite(drawcontour2(img, S), strcat(dir_border, file, '.png') );
    imwrite(img, strcat(dir_masked, file, '.png'), 'Alpha', double(S) );
    fprintf(fp, '%s\t%e\t%e\t%d\t%e\t%e\t%e\t%d\n', images(i).name, EPR, EOR, Cuts, Energy, Data, Smooth, N);
end

mENG = mean(ENGs);
mEPR = mean(EPRs)
mEOR = mean(EORs);
mnDATAs = mean(nDATAs);
mnENG = mean(nENGs);
mEnergy = mean(ENGs);
mData = mean(DATAs);
mSmooth = mean(SMOOTHs);
mCuts = mean(nCuts);

fprintf(fp, '%s\t%e\t%e\t%d\t%e\t%e\t%e\t%d\n', 'Mean', mean(EPRs), mean(EORs), mean(nCuts), mean(ENGs), mean(DATAs), mean(SMOOTHs), 0);
fprintf(fp, '%s\t%e\t%e\t%d\t%e\t%e\t%e\t%d\n', 'Std', std(EPRs), std(EORs), std(nCuts), std(ENGs), std(DATAs), std(SMOOTHs), 0);
fclose(fp);