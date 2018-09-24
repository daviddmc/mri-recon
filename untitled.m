%% In Vivo Single-Slice Brain MRSI (R=3, 12 averages, random undersampling)

clear; close all;clc

% Optional oversampling factor along each dimension (x,y,f)
oversampling_factor = [1,1,1];

N_c = [32,32,320];      % Number of pixels (x,y,f)
R = 3;                  % Reduction factor

%% Load data and coil sensitivities

addpath tmpData
load('kspace_traj_us.mat')                      % Spiral trajectory
load('DATA_kspace.mat')                         % Randomly undersampled k-space data (R = 3)
load('sens.mat')                                % Coil sensitivities
load('invivo_ground_truth_R1_TV0_50avg.mat')    % 50-avg fully sampled data (ground truth)
load('mask_brain_invivo.mat')                   % Brain mask
load('gre_TE4ms_rsos.mat')                      % Structural image for display
load('mask_grid.mat')                           % Spectra location

% Zero-pad coil sensitivities if there is oversampling
sens = padarray(sens,[((oversampling_factor(1:2)-1).*N_c(1:2))/2,0]);
N_chan = size(sens,3);

%% Ground truth

mask_brain = mask_brain_invivo;
x_ground_truth = invivo_ground_truth_R1_TV0(:,:,end:-1:1);

% Rotate data to have correct orientation
rotate_data_angle = 270;
mask_brain = imrotate(mask_brain, rotate_data_angle);
x_ground_truth = imrotate(x_ground_truth, rotate_data_angle);
x_ground_truth_masked = bsxfun(@times, x_ground_truth, mask_brain);

% sens
sens = reshape(sens, [size(sens,1), size(sens,2), 1, N_chan]);
sens = repmat(sens, [1, 1, N_c(3), 1]);

% data
data = cell2mat(DATA_kspace);

%% Create Cartesian to spiral operator
S = SensitivityMap([], false, sens, false);
F = FourierTransform(S, false, [1,2,3]);
A = Gridding(F, false, N_c, kspace_traj_us);
G = Gradient([], false, [1,2,3]);

%% cost functions
ssd = SumSquaredDifference({A, data}, 1);
mu1 = 1e-4;
mu2 = 1e-4;
nucNorm = SchattenNorm([], mu1, 0.1, 2);
l12norm = L12Norm([], mu2, 3);

%tv = L1Norm(G, 1e-4 / 2);

%FT_cart2spiral = FT_Cart2spiral(kspace_traj_us, oversampling_factor.*N_c);

%% Reconstruction
param.maxIter = 200;
param.verbose = 2;
param.tol = 1e-3;
param.stopCriteria = 'PRIMAL_UPDATE';
param.tau = 3e-5;
solver = FBPD(nucNorm, l12norm, G, ssd, param);

%x0 = A.adjoint(data);
%x0 = x0 / norm(x0(:)) * norm(x_ground_truth(:)) / 10;

[res, info] = solver.run(zeros(oversampling_factor.*N_c));

x_recon = res( (oversampling_factor(1)-1)*N_c(1)/2 + 1 : (oversampling_factor(1)+1)*N_c(1)/2,  (oversampling_factor(2)-1)*N_c(2)/2 + 1 : (oversampling_factor(2)+1)*N_c(2)/2, (oversampling_factor(3)-1)*N_c(3)/2 + 1 : (oversampling_factor(3)+1)*N_c(3)/2 );
x_recon = x_recon(:,:,end:-1:1);
x_recon = imrotate(x_recon, rotate_data_angle);
x_recon_masked = bsxfun(@times, x_recon, mask_brain);
%{
param.maxIter = 10;
param.verbose = 0;
param.tol = 0;
param.maxIterLS = 150;
param.beta = 0.6;


solver = NLCG({ssd, tv}, param);
res = zeros(oversampling_factor.*N_c);

for n = 1:50
    [res, info] = solver.run(res);
    obj_val = info.cost(end);
    % Display objective value, the percentage change of obj val, and the
    % percentage change of the solution
    
    x_recon = res( (oversampling_factor(1)-1)*N_c(1)/2 + 1 : (oversampling_factor(1)+1)*N_c(1)/2,  (oversampling_factor(2)-1)*N_c(2)/2 + 1 : (oversampling_factor(2)+1)*N_c(2)/2, (oversampling_factor(3)-1)*N_c(3)/2 + 1 : (oversampling_factor(3)+1)*N_c(3)/2 );
    x_recon = x_recon(:,:,end:-1:1);
    x_recon = imrotate(x_recon, rotate_data_angle);
    x_recon_masked = bsxfun(@times, x_recon, mask_brain);
    [map_naa, map_naa_gt, ~, ~] = get_mrsi_map(x_ground_truth_masked,x_recon_masked, 253, 275);
    [map_cr, map_cr_gt, ~, ~] = get_mrsi_map(x_ground_truth_masked,x_recon_masked, 221, 231);
    [map_cho, map_cho_gt, ~, ~] = get_mrsi_map(x_ground_truth_masked,x_recon_masked, 210, 221);
    
    
    if n > 1
        rmse_obj_val = 100*abs(obj_val_prev - obj_val)/abs(obj_val_prev);
        rmse_sol = 100*norm(res_prev(:) - res(:))/norm(res_prev(:));
        disp([num2str(n), ...
            '    , obj_val_rmse: ', num2str(rmse_obj_val) ,...
            ', res_rmse: ', num2str(rmse_sol),...
            ', obj_val: ', num2str(obj_val),...
            ', SSD: ', num2str([sum(abs(map_naa(:) - map_naa_gt(:)).^2),...
            sum(abs(map_cr(:) - map_cr_gt(:)).^2), sum(abs(map_cho(:) - map_cho_gt(:)).^2)])]);
    end

    % Stopping criterion
    if ( n>10 ) && ( rmse_obj_val < 1e-4 || rmse_sol < 1)
        break;
    end

    obj_val_prev = obj_val;
    res_prev = res;
end
%}

%{
param = init;
param.FT = FT_cart2spiral;      % Nonuniform Fourier transform operator
param.XFM = 1;                  % Sparsifying transform (Identity for now...could be Wavelet and others)                     
param.TV = TVOP3D;              % TV operator
param.Itnlim = 10;                  
param.xfmWeight = 0;            % Regularization parameter for sparsifying transform
param.TVWeight = 1e-4;          % Regularization parameter for TV
param.num_coils = N_chan;       % Number of channels
param.data = [];

param.sens = [];
for c = 1:N_chan
    param.sens{c} = repmat(sens(:,:,c),[1,1,N_c(3)]);
    param.data{c} = DATA_kspace{c};
end

maxIter = 50;

% Initialization
res = zeros(oversampling_factor.*N_c);

for n = 1:maxIter
    [res,obj_val] = fnlCg_SENSE3D(res, param);

    % Display objective value, the percentage change of obj val, and the
    % percentage change of the solution
    if n > 1
        rmse_obj_val = 100*abs(obj_val_prev - obj_val)/abs(obj_val_prev);
        rmse_sol = 100*norm(res_prev(:) - res(:))/norm(res_prev(:));
        disp([num2str(n), '    , obj_val_rmse: ', num2str(rmse_obj_val) , ', res_rmse: ', num2str(rmse_sol), ', obj_val: ', num2str(obj_val)])
    end

    % Stopping criterion
    if ( n>10 ) && ( rmse_obj_val < 1e-4 || rmse_sol < 1)
        break;
    end

    obj_val_prev = obj_val;
    res_prev = res;
end
%}    
% Get the recon




%% Display
%cd([currPath,'/Data/'])
load('gre_TE4ms_rsos.mat')                      % Structural image for display
load('mask_grid.mat')                           % Spectra location
%cd(currPath)

mask_grid = zeros(size(mask_grid));
mask_grid(10:4:18, 14:3:20) = 1;

% Metabolite range
overplot_spectra_specific_locations(x_ground_truth_masked, x_recon_masked, imrotate(gre_rsos,270), mask_grid, 176, 284, 1, 2, 3); close

% Simplest way to get the metabolite map (there are much better ways to do this...)
[map_naa, map_naa_gt, ~, ~] = get_mrsi_map(x_ground_truth_masked,x_recon_masked, 253, 275);
[map_cr, map_cr_gt, ~, ~] = get_mrsi_map(x_ground_truth_masked,x_recon_masked, 221, 231);
[map_cho, map_cho_gt, ~, ~] = get_mrsi_map(x_ground_truth_masked,x_recon_masked, 210, 221);
figure(3); imagesc(abs([map_naa_gt, map_naa]), [0,0.085]), title('NAA'), axis image off, colorbar
figure(4); imagesc(abs([map_cr_gt, map_cr]), [0,0.043]), title('Cr'), axis image off, colorbar
figure(5); imagesc(abs([map_cho_gt, map_cho]), [0,0.043]), title('Cho'), axis image off, colorbar


