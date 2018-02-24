%% DEMO SPIRiT
%
% SPIRiT formularizes pMRI reconstruction problem as
%
%    find x
%    subject to (G-I)x = 0,
%               P(x) = y
%
% where G is the SPIRiT operator, see reference for its definition, P is
% undersampling operator, x is the reconstructed k-space data and y is
% measured data. This linear system can be solved by LSQR method.
%
% See also SPIRiT, Undersampling, LSQR
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
nIterCG = 30; % number of CG iteration
CalibTyk = 0.01;  % Tykhonov regularization for calibration
ReconTyk = 1e-5;  % Tykhovon regularization for CG 

%% load data
load brain_8ch
mask = mask_unif;
F = FourierTransform([], 0, [1,2]);
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
kCalib = cropc(DATA,[CalibSize,nc]);
zf = Undersampling([], 1, DATA == 0, true);
GOP = SPIRiT([], 0, kCalib, kSize, CalibTyk, 'freq', imSize, true);

%% setup solver
b = -GOP.apply(DATA);
GOP.setInput(1, zf);
x0 = zf.adjoint(DATA);
param.maxIter = nIterCG;
param.verbose = 2;
lq = LSQR({GOP, []}, {b, 0*x0}, [1, ReconTyk], param);

%% run solver
[x, info] = lq.run(x0);

%% show results
x = zf.apply(x) + DATA;
im_spirit = F.adjoint(x);

figure,
subplot(1,3,1), imshow(RSS(im_gt)), title('ground truth');
subplot(1,3,2), imshow(RSS(im_zf)), title('zero-filling');
subplot(1,3,3), imshow(RSS(im_spirit)), title('SPIRiT');





