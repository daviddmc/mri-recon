%% DEMO MR reconcstruction using Regularized Nonlinear Inversion (NLINV)
%
% The multi-coil MR reconstruction can be considered as solving the
% following nonlinear inversion problem:
%
%   find x = (m, C)
%   subject to J(x) = PFCm = y
%
% where P is undersampling operator, F is Fourier transform, C is coil
% sensitivity maps, m is the image. The model tries to estimate sensitivity
% maps and image simultaneously.
%
% NLINV solves this problem using iteratively regularized Gauss-Newton 
% method (IRGNM).
%
% See also 
%
% Reference:
% [1]Uecker, M., Hohage, T., Block, K. T., & Frahm, J. (2008). Image 
% reconstruction by regularized nonlinear inversion--joint estimation of 
% coil sensitivities and image content. Magnetic Resonance in Medicine, 
% 60(3), 674.
%
% Copyright 2018 Junshen Xu

clear all
close all


%% set parameters
nIterOut = 8; % number of iterations for outer loop
maxIterCG = 500; % maximum number of iterations for inner CG step;
alpha = 1;
beta = 1/3;

%% load data
load brain_8ch
F = FourierTransform([], 0, [1,2]);
data = DATA/max(max(max(abs(F.adjoint(DATA))))) + eps;
mask = mask_nocalib_x2half;     % choose a 3x no calibration mask
datau = data .* repmat(mask,[1,1,size(data,3)]); % undersampling
im_zf = F.adjoint(datau); % zero-filling reconstruction
[nx, ny, nc] = size(datau);
yscale = 100. / sqrt(datau(:)'*datau(:));
YS = datau * yscale; % rescale data

%% setup operators
% weight for preconditioning 
[kx, ky] = meshgrid(linspace(-0.5, 0.5, nx), linspace(-0.5, 0.5, ny));
w = 1 ./ (1 + 220 * (kx.^2 + ky.^2)).^8; %16
% precondition operator
I = Identity([]);
W = Weighting([], 0, w);
Fw = FourierTransform(W, 1, [1,2]); % precondition operator for sensitivity maps
bd = BlockDiagonal('z', {I, Fw}, {1, 2:nc+1});
% Jacobian of nonlinear operator J
cmap = im_zf ./ RSS(im_zf);
C = SensitivityMap([], 0, cmap, 0);
Rho = Weighting([], 0, RSS(im_zf));
bm = BlockMatrix(bd, {C, Rho}, 0, 3, {1, 2:nc+1});
Fbm = FourierTransform(bm, 0, [1,2]);
Jac = Undersampling(Fbm, 0, mask, false);
% imaging operator
Img = Slice('x', 3, 1, [nx, ny, nc+1]); 
C1 = SensitivityMap(Img, 0, cmap, 0);
Fc = FourierTransform(C1, 0 ,[1,2]);
E = Undersampling(Fc, 0, mask, false);

%% setup solver
% parameters for CG step
param.maxIter = 500;
param.verbose = 0;
param.tol = 1e-3;
% init
X0 = cat(3, ones(size(Rho.w)), zeros(size(cmap)));
XN = X0;
normYS = norm(YS(:));
% res
resDC = Minus({YS, E});
resL2Reg = Minus({X0,'x'});
% cg solver
lq = LSQR({Jac, []}, {resDC, resL2Reg}, [], param);

%% main loop
xVar = Variable.getVariable('x');
xVar.setInput(XN);
for iter = 1 : nIterOut
    % cg step
    lq.setLambda([1, sqrt(alpha)]);
    [z, info] = lq.run(0*XN);
    % update variable
    XN = XN + z;
    xVar.setInput(XN);
    % update regularization parameter
    alpha = alpha / 3.;
    % update sensitivity maps
    cmap = Fw.apply(XN(:,:,2:end));    
    C.map = cmap;
    C1.map = cmap;
    Rho.w = XN(:,:,1);
    % display
    fprintf('iteration %d : niter for CG step = %d, rel residual = %f\n', ...
        iter, info.iter, norm(col(resDC.apply())) / normYS);
end

%% show results
im_recon = XN(:, :, 1) .* RSS(cmap) / yscale;
imshow(abs(im_recon), []);
    






