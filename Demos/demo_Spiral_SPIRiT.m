%% Demo Spiral SPIRiT
%
% Non-uniform SPIRiT in image domain
%
%    find x
%    subject to (G-I)x = 0,
%               Ex = y
%
% where G is the SPIRiT operator, see reference for its definition, E is
% NUFFT operator, x is the reconstructed image and y is measured data. This 
% linear system can be solved by LSQR method.
%
% See also SPIRiT, NUFT, LSQR
%
% Reference:
% [1]Lustig, M., & Pauly, J. M. (2010). Spirit: iterative self-consistent 
% parallel imaging reconstruction from arbitrary k-space. Magnetic 
% Resonance in Medicine, 64(2), 457.
%
% Copyright 2018 Junshen Xu

%% set parameters
kSize = [7,7];                  % SPIRiT Kernel size
CalibSize = [30,30];            % size of the calibration region
N = [260,360];                  % size of the target image
nIterCG = 15;                   % number of reconstruction iterations
CalibTyk = 0.02;                % Tykhonov regularization for calibration 0.01-0.05 recommended
lambda = 1;                     % Ratio between data and calibration consistency. 1 recommended when density compensation is used.
accel = 3;                      % Acceleration factor

%% load data
load spiral.mat
% perform SVD coil compression
[data, nc] = CCSVD( data, 0.05);
% griding k-space to get calibration data
GFFT1 = NUFT([], 0, N, 1, nc,k, w);
im_gt = GFFT1.adjoint(data.*repmat(sqrt(w),[1,1,nc]));
F = FourierTransform([], 0, [1, 2]);
kData = F.apply(im_gt); % griding k-space data
kCalib = cropc(kData,[CalibSize,nc]); % crop center k-space for calibration
% undersampling k-space data
idx = (1:accel:size(k,2));
k_u = k(:,idx);
w_u = w(:,idx);  
kData_u = data(:,idx,:);

%% setup operators
GOP = SPIRiT([], 0, kCalib, kSize, CalibTyk, 'image', N, true);
GFFT_u = NUFT([], 0, N, 1, nc,k_u, w_u);

%% setup solver
b = kData_u .* repmat(sqrt(w_u), [1, 1, nc]);
im_zf = GFFT_u.adjoint(kData_u.*repmat(sqrt(w_u),[1,1,nc]))*accel;
param.maxIter = nIterCG;
param.verbose = 2;
lq = LSQR({GFFT_u, GOP}, {b, 0 * im_zf}, [1, 1], param);

%% run solver
im_spirit = lq.run(im_zf);

%% show results
imshow(cat(2,RSS(im_gt),RSS(im_zf),RSS(im_spirit)),[]), 
