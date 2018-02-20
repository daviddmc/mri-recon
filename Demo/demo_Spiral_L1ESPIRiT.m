%% Demo Spiral L1-SPIRiT
%
% Non-uniform ESPIRiT
%
%   argmin_x,z   1/2*||FEx - d||^2 + lambda * ||Wz||_1
%        subject to x = z
%
% where E is the ESPIRiT operator, F is the NUFFT operator, x is the 
% reconstructed image and y is measured data.
%
% See also ESPIRiT, NUFT, WaveletTransformation, L1Norm, ALM
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
kSize = [6,6];                  % SPIRiT Kernel size
CalibSize = [30,30];            % size of the calibration region
N = [260,360];                  % size of the target image
lambda = 1;
mu = 0.5;
accel = 3;                      % Acceleration factor
eigThresh_k = 0.02; % threshold of eigenvectors in k-space
eigThresh_im = 0.95; % threshold of eigenvectors in image space
paramCG.maxIter = 15;       % number of CG iterations for the PI part
paramCG.verbose = 0;
paramCG.tol = 1e-6;
maxIter = 20;

%% load data
load spiral.mat
% perform SVD coil compression
[data, nc] = CCSVD( data, 0.05);
% griding k-space to get calibration data
GFFT1 = NUFT([], 0, N, 1, nc,k, w);
im_gt = GFFT1.adjoint(data.*repmat(sqrt(w),[1,1,nc]));
F = FourierTransformation([], 0, [1, 2]);
kData = F.apply(im_gt); % griding k-space data
kCalib = cropCenter(kData, CalibSize); % crop center k-space for calibration
% undersampling k-space data
idx = (1:accel:size(k,2));
k_u = k(:,idx);
w_u = w(:,idx);  
kData_u = data(:,idx,:);

%% setup operators
E = ESPIRiT('1', 0, kCalib, kSize, N, 1, eigThresh_k, eigThresh_im);
GFFT_u = NUFT([], 0, N, 1, nc,k_u, w_u);
im_zf = GFFT_u.adjoint(kData_u .* sqrt(w_u)) * accel;
x0 = E.adjoint(im_zf);
GFFT_u.setInput(1, E);
ZP = ZeroPad('2', 0, 2.^nextpow2(N), N);
W = WaveletTransformation(ZP, 0, 'Daubechies', 4, 4);

%% setup cost functions
ssd = SumSquaredDifference({GFFT_u, kData_u .* sqrt(w_u)}, 1);
l1norm = L1Norm(W, lambda);
l1norm.setProxOption('method',0);

%% setup solver
eq1.lhs = {'1'};
eq1.rhs = {'2'};
alm = ALM({ssd, l1norm}, {eq1});

%% run solver
param.mu = mu;
param.updateInterval = maxIter + 1;
param.maxIter = maxIter;
param.verbose = 2;
param.paramCG = paramCG;
param.plotFun = @(s)(imshow(abs(s.var{1}),[]));
x = alm.run({x0, x0}, param);

%% show results
figure,
subplot(1,3,1), imshow(rootSumSquare(im_gt),[]), title('ground truth');
subplot(1,3,2), imshow(rootSumSquare(im_zf),[]), title('zero-filling');
subplot(1,3,3), imshow(abs(x{1}),[]), title('L1ESPIRiT');

