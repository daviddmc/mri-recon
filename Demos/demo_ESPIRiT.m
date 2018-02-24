%% DEMO ESPIRiT
%
% ESPIRiT formularizes pMRI reconstruction problem as
%
%    find x
%    subject to FEE'F'x = x,
%               P(x) = y
%
% where E is the ESPIRiT operator, see reference for its definition, P is
% undersampling operator, x is the reconstructed k-space data and y is
% measured data. This linear system can be solved by LSQR method.
%
% See also ESPIRiT, FourierTransformation, Undersampling, LSQR
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
ncalib = 24; % use 24 calibration lines to compute compression
ksize = [6,6]; % ESPIRiT kernel-window-size
eigThresh_k = 0.02; % threshold of eigenvectors in k-space
eigThresh_im = 0.9; % threshold of eigenvectors in image space
lambda = 0.01;

%% load data
load brain_alias_8ch
[sx,sy,Nc] = size(DATA);
invF = FourierTransform([], 1, [1,2]);
im_gt = invF.apply(DATA);
DATA = DATA / max(abs(im_gt(:))) + eps;
im_gt = im_gt / max(abs(im_gt(:)));
mask = zpadc(ones(sx, ncalib),[sx, sy]);
mask = repmat(mask,[1,1,8]);
mask(:,1:2:end,:) = 1;
DATAc = DATA .* mask;
calib = cropc(DATAc,[sx,ncalib]);
im_zf = invF.apply(DATAc);

%% setup operators
E = ESPIRiT(invF, 1, calib, ksize, [sx, sy], 2, eigThresh_k, eigThresh_im);
EEt = ATA([], E);
I = Identity([]);
A = LinearSum([], 0, {EEt, I}, [1, -1]);
b = -A.apply(DATAc);
Mnacq = Undersampling([], 1, ~mask, true);
A.setInput(1, Mnacq);

%% setup solver
x0 = Mnacq.adjoint(0 * DATAc);
param.maxIter = 12;
param.verbose = 2;
lq = LSQR({A, []}, {b, 0*x0}, [1, lambda], param);

%% run solver
[x, info] = lq.run(x0);

%% show results
x = Mnacq.apply(x) + DATAc;
im_espirit = E.apply(x);

figure,
subplot(1,3,1), imshow(RSS(im_gt)), title('ground truth');
subplot(1,3,2), imshow(RSS(im_zf)), title('zero-filling');
subplot(1,3,3), imshow(RSS(im_espirit)), title('ESPIRiT');

