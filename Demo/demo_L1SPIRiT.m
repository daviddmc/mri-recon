%% DEMO L1-SPIRiT
%
% The L1-SPIRiT problem can be formularized as
%
% (P1)   argmin 1/2 * ||Gx - x||^2 + mu * ||Wx||_1
%        subject to P(x) = y
%
% or
%
% (P2)   argmin mu * ||Wx||_1
%        subject to P(x) = y
%                   Gx = x
%
% where G is the SPIRiT operator, see reference for its definition, P is
% undersampling operator, W is wavelet transform, x is the reconstructed 
% k-space data and y is measured data. P1 can be solved with FBPD solver
% while P2 can be solved with POCS solver
%
% See also SPIRiT, Undersampling, FBPD, POCS, WaveletTransformation,
% L1Norm, SumSquaredDifference, LinearEquation, ZeroPad
%
% Reference:
% [1]Lustig, M., & Pauly, J. M. (2010). Spirit: iterative self-consistent 
% parallel imaging reconstruction from arbitrary k-space. Magnetic 
% Resonance in Medicine, 64(2), 457.
%
% Copyright 2018 Junshen Xu

clear all
close all

%% set parameters
kSize = [5,5];  % SPIRiT kernel size
nIter = 30; % number of iterations
CalibTyk = 0.01;  % Tykhonov regularization for calibration
wavWeight = 0.0015; % regularization parameter
isPOCS = 1; % use POCS or FBPD

%% load data
load brain_8ch
mask = mask_randm_x4;
F = FourierTransformation([], 0, [1,2]);
im_gt = F.adjoint(DATA);
[CalibSize, dcomp] = getCalibSize(mask);  % get size of calibration area from mask
imSize = [size(DATA, 1), size(DATA,2)];
nc = size(DATA,3);
DATA = DATA .* repmat(mask,[1,1,nc]); % undersampling
DATAc = DATA .* repmat(dcomp,[1,1,nc]); % density compensation
% normalization
scale_fctr = norm(DATAc(:)) / sqrt(nc) / 20;
DATA = DATA / scale_fctr;
DATAc = DATAc / scale_fctr;
im_zf = F.adjoint(DATAc); % zero-filling reconstruction
im_gt = im_gt / scale_fctr;

%% setup operators
kCalib = cropCenter(DATA, CalibSize);
if isPOCS
    GOP = SPIRiT([], 0, kCalib, kSize, CalibTyk, 'freq', imSize, false);
else
    GOP = SPIRiT([], 0, kCalib, kSize, CalibTyk, 'freq', imSize, true);
end
Macq = Undersampling([], 0, DATA ~= 0, false);
FT = FourierTransformation([], 1, [1,2]);
ZP = ZeroPad(FT, 0, 2.^nextpow2(imSize), imSize);
Wav = WaveletTransformation(ZP, 0, 'Daubechies', 4, 4);

%% setup cost functions
if isPOCS
    SC = DominantEigenspace([], GOP);
    l12norm = L12Norm(Wav, wavWeight, 3);
    l12norm.setProxOption('method', 0);
else
    ssd = SumSquaredDifference({GOP, 0}, 1);
    l12norm = L12Norm([], wavWeight, 3);
end

DC = LinearEquation({Macq, DATA});

%% setup solver
if isPOCS
    solver = POCS({SC, DC, l12norm});
else
    solver = FBPD(DC, l12norm, Wav, ssd);
end

%% run solver
param.maxIter = 30;
param.verbose = 2;
param.tau = 0.75;
x0 = DATA;
x = solver.run(DATA, param);

%% show results
im_spirit = F.adjoint(x);

figure,
subplot(1,3,1), imshow(rootSumSquare(im_gt)), title('ground truth');
subplot(1,3,2), imshow(rootSumSquare(im_zf)), title('zero-filling');
subplot(1,3,3), imshow(rootSumSquare(im_spirit)), title('SPIRiT');





