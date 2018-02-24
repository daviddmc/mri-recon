%% DEMO Simultaneous Autocalibrating and K-space Estimation (SAKE)
% 
% SAKE solves the following fesibility problem:
%
%       find   x
%   subject to P(x) = y,
%              rank(H(x)) <= r.
%
% where x is the estimated k-space data, y is the measured data, P is
% undersampling operator, H a operator that extract a block-Hankel matrix
% from x. This problem can be solved with the simple POCS solver.
%
% See also Undersampling, LowRank, Hankel, POCS
%
% Reference:
% [1]Shin, P. J., Larson, P. E. Z., Ohliger, M. A., Elad, M., Pauly, J. M.,
% & Vigneron, D. B., et al. (2014). Calibrationless parallel imaging 
% reconstruction based on structured low-rank matrix completion. Magnetic 
% Resonance in Medicine, 72(4), 959.
%   
% Copyright 2018 Junshen Xu

clear all
close all

%% set parameters
maxIter = 50;
ksize = [6,6]; % kernel-window-size
wnthresh = 1.8; % Window-normalized number of singular values to threshold

%% load data
load brain_8ch
F = FourierTransform([], 0, [1,2]);
data = DATA/max(max(max(abs(F.adjoint(DATA))))) + eps;
mask = mask_nocalib_x2half;     % choose a 3x no calibration mask
datau = data .* repmat(mask,[1,1,size(data,3)]);
im_zf = F.adjoint(datau); % zero-filling reconstruction
im_gt = F.adjoint(data);

%% setup operators
U = Undersampling([], 0, mask, false);
H = Hankel([], 0, size(im_zf), ksize);

%% setup constrains
DC = LinearEquation({U, datau});
LR = LowRank(H, wnthresh * prod(ksize));

%% setupd solver
param.maxIter = maxIter;
param.verbose = 2;
pocs = POCS({LR, DC}, param);

%% run solver
x0 = F.apply(im_zf);
[x, info] = pocs.run(x0);

%% show results
subplot(1,3,1),imshow(RSS(im_zf), []);
title('zero filling')
subplot(1,3,2),imshow(RSS(F.adjoint(x)), []);
title('SAKE')
subplot(1,3,3),imshow(RSS(im_gt), []);
title('ground truth')



