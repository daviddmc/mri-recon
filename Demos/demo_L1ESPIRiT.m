%% DEMO L1 ESPIRiT
%
% Similar to L1-SPIRiT, L1-ESPIRiT can be formularized as the following
% problem using variable spliting technique.
%
%   argmin_x,z   1/2*||PFEx - d||^2 + lambda * ||Wz||_1
%        subject to x = z
%
% See also ESPIRiT, FourierTransformation, Undersampling, 
% WaveletTransformation, ALM
%
% Reference:
% [1]Uecker, M., Lai, P., Murphy, M. J., Virtue, P., Elad, M., & 
% Pauly, J. M., et al. (2014). Espirit¡ªan eigenvalue approach to 
% autocalibrating parallel mri: where sense meets grappa. Magnetic 
% Resonance in Medicine Official Journal of the Society of Magnetic 
% Resonance in Medicine, 71(3), 990-1001.
%
% Copyright 2018 Junshen Xu

clear all
close all

%% set parameters
ksize = [6,6]; % ESPIRiT kernel-window-size
eigThresh_k = 0.02; % threshold of eigenvectors in k-space
eigThresh_im = 0.9; % threshold of eigenvectors in image space
paramCG.maxIter = 5;       % number of CG iterations for the PI part
paramCG.verbose = 0;
nIterSplit = 15;    % number of splitting iterations for CS part
splitWeight = 0.4;  % reasonable value
lambda = 0.0025;    % L1-Wavelet threshold

%% load data
load brain_8ch
[sx,sy,Nc] = size(DATA);
invF = FourierTransform([], 1, [1,2]);
im_gt = invF.apply(DATA);
DATA = DATA / max(abs(im_gt(:))) + eps;
im_gt = im_gt / max(abs(im_gt(:)));
mask = mask_randm_x4;
mask = repmat(mask,[1,1,8]);
ncalib = getCalibSize(mask_randm_x4);
DATAc = DATA.*mask;
calib = cropc(DATAc,[ncalib,Nc]);
im_zf = invF.apply(DATAc);
imSize = [size(im_zf, 1), size(im_zf, 2)];

%% setup operators
E = ESPIRiT('1', 0, calib, ksize, [sx, sy], 2, eigThresh_k, eigThresh_im);
F = FourierTransform(E,0, [1,2]);
P = Undersampling(F,0,mask,false);
ZP = ZeroPad('2', 0, 2.^nextpow2(imSize), imSize);
W = WaveletTransform(ZP, 0, 'Daubechies', 4, 4);

%% setup cost functions
ssd = SumSquaredDifference({P, DATAc}, 1);
l1norm = L1Norm(W, lambda);
l1norm.setProxOption('method',0);
%l1norm.proxOption.method = 0;

%% setup solver
param.mu = splitWeight;
param.updateInterval = nIterSplit + 1;
param.maxIter = nIterSplit;
param.verbose = 2;
param.paramCG = paramCG;
eq1.lhs = {'1'};
eq1.rhs = {'2'};
alm = ALM({ssd, l1norm}, {eq1}, param);

%% run solver
x0 = zeros([imSize, 2]);
x = alm.run({x0, x0});

%% show results
figure,
subplot(1,3,1), imshow(RSS(im_gt)), title('ground truth');
subplot(1,3,2), imshow(RSS(im_zf)), title('zero-filling');
subplot(1,3,3), imshow(RSS(x{1})), title('L1ESPIRiT');

