% Initial Parameters

kSize = [7,7];                  % SPIRiT Kernel size
CalibSize = [30,30];            % size of the calibration region
N = [260,360];                  % size of the target image
nIterCG = 15;                   % number of reconstruction iterations
CalibTyk = 0.02;                % Tykhonov regularization for calibration 0.01-0.05 recommended
lambda = 1;                     % Ratio between data and calibration consistency. 1 recommended when density compensation is used.
accel = 3;                      % Acceleration factor

% load data
load spiral.mat

% perform SVD coil compression
disp('perform coil compression at  5\% tollerance.')
D = reshape(data,size(data,1)*size(data,2),size(data,3));
[U,S,V] = svd(D,'econ');
nCoil = max(find(diag(S)/S(1)>0.05));
data = reshape(D*V(:,1:nCoil),size(data,1),size(data,2),nCoil);
disp(sprintf('Using %d virtual channels',nCoil'));


% Calibration
% In this example, we calibrate from a fully sampled acquisition
% reconstructed with gridding and density compensation.
% Then undersample it to see how the reconstruction performs.

disp('Starting Calibration');
disp('Generating NUFFT object for calibration')

% Gridding and density compensation reconstruction
%GFFT1 = NUFFT(k,w, [0,0] , N);
GFFT1 = NUFT([], 0, N, 1, nCoil,k, w);
F = FourierTransformation([], 0, [1, 2]);
im = GFFT1.adjoint(data.*repmat(sqrt(w),[1,1,nCoil]));
kData = F.apply(im);

kCalib = cropCenter(kData,[CalibSize,nCoil]); % crop center k-space for calibration


%kernel = calibSPIRiT(kCalib, kSize, nCoil, CalibTyk);
%GOP = SPIRiT(kernel, 'image',N); % init the SPIRiT Operator
GOP = SPIRiT([], 0, kCalib, kSize, CalibTyk, 'image', N, true);
disp('Done Calibrating');


% Undersample the data and prepare new NUFFT operator for it
idx = (1:accel:size(k,2));
k_u = k(:,idx);
w_u = w(:,idx);  % use w_u = w(:,idx)*0+1; if you don't want to use density weighting
                 % this may improve noise, but will converge slower. use
                 % larger lambda.
kData_u = data(:,idx,:);

disp('generating nufft object for recon')
%GFFT_u = NUFFT(k_u,w_u, [0,0], N);
GFFT_u = NUFT([], 0, N, 1, nCoil,k_u, w_u);

im_dc = GFFT_u.adjoint(kData_u.*repmat(sqrt(w_u),[1,1,nCoil]))*accel;
res = im_dc;
disp('initiating reconstruction')
tic
param.lambda = lambda;
param.maxIter = nIterCG;
param.L = GOP;

A = GFFT_u;
b = kData_u .* repmat(sqrt(w_u), [1, 1, nCoil]);
x0 = res;
[res, info] = LSQR(A, b, x0, param);

%res = cgNUSPIRiT(kData_u.*repmat(sqrt(w_u),[1,1,nCoil]),res,GFFT_u,GOP,nIterCG,lambda);
toc
disp('done!');


figure(100), imshow(cat(2,rootSumSquare(im),rootSumSquare(im_dc),rootSumSquare(res)),[]), 
