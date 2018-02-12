close all
clear all

%load phantom.mat
load brain_8ch


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% Reconstruction Parameters %%%%%%%%%%%%%%%%%%%
%						     %	 			
kSize = [5,5];  % SPIRiT kernel size
nIterCG = 30; % number of iteration; phantom requires twice as much as the brain.
mask_type = 'random4'; % options are: 'unif','random4','random3'
CalibTyk = 0.01;  % Tykhonov regularization in the calibration
wavWeight = 0.0015;  % Wavelet soft-thresholding regularization in the reconstruction (SPIRiT only)
addNoiseSTD = 0.0; % add noise. Use only for phantom. Brain has enough noise!
skipGRAPPA = 1; % skip GRAPPA recon.

DATA = DATA+randn(size(DATA))*addNoiseSTD + 1i*randn(size(DATA))*addNoiseSTD;

F = FourierTransformation([], 0, [1,2]);
im = F.adjoint(DATA);

switch mask_type
    case 'random4'
            mask = mask_randm_x4;
            if skipGRAPPA==0
                gSkip=1;
            end
    otherwise
end

[CalibSize, dcomp] = getCalibSize(mask);  % get size of calibration area from mask
pe = size(DATA,2); fe = size(DATA,1); coils = size(DATA,3); % get sizes
DATA = DATA.*repmat(mask,[1,1,coils]); % multiply with sampling matrix

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% scale the data such that the zero-filled density compensated      %%%%%%%%%
% k-space norm is 1. This is useful in order to use similar         %%%%%%%%%
% regularization penalty values for different problems.             %%%%%%%%%

DATAcomp = DATA.*repmat(dcomp,[1,1,coils]);
scale_fctr = norm(DATAcomp(:))/sqrt(coils)/20;
DATA = DATA/scale_fctr;
DATAcomp = DATAcomp/scale_fctr;

im_dc = F.adjoint(DATAcomp);
im = im/scale_fctr;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% GRAPPA                                   %%%%%%%%%%%
if skipGRAPPA
    disp('skipping grappa, replacing with zero filling');
    res_grappa = DATA;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%		 Perform Calibration                       %%%%%%%%%%
disp('performing calibration for SPIRiT')
kCalib = cropCenter(DATA,CalibSize);

%kernel = calibSPIRiT(kCalib, kSize, coils, CalibTyk);
%GOP = SPIRiT(kernel, 'fft',[fe,pe]);
%G = SPIRiT(kCalib, kSize, CalibTyk, 'freq', [fe, pe], false);
GOP = SPIRiT([], 0, kCalib, kSize, CalibTyk, 'freq', [fe, pe], 1);
Macq = Undersampling([], 0, DATA ~= 0, false);
%W = WaveletTransformation('Daubechies',4,4);
ssd = SumSquaredDifference({GOP, 0}, 1);
l1norm = L1Norm([], 0.0015);
DC = LinearEquation({Macq, DATA});
%ZP = ZeroPad([256,256], [200, 200]);
%A = W * ZP * F';

A = WaveletTransformation(ZeroPad(FourierTransformation([], 1, [1,2]),...
    0, [256,256], [200, 200]),...
    0, 'Daubechies',4,4);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%                  Reconstruction                        %%%%%%%%%

disp('performing CG reconstruction')

param.maxIter = 30;
param.verbose = 2;
param.tau = 1;
x0 = DATA;
[res_cg, info] = FBPD( DC, l1norm, A, ssd, x0, param );
res_cg = res_cg .* (1-mask) + DATA;

im_cgspirit = F.adjoint(res_cg);
im_grappa = F.adjoint(res_grappa);

im_cgspirit_err = im_cgspirit - im;
im_grappa_err = im_grappa - im;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%		Display                                  %%%%%%%%%%%
im_cgspirit_sqr = rootSumSquare(im_cgspirit);
im_grappa_sqr = rootSumSquare(im_grappa);
im_dc_sqr = rootSumSquare(im_dc);
im_sqr = rootSumSquare(im);
im_cgspirit_err_sqr = rootSumSquare(im_cgspirit_err);
im_grappa_err_sqr = rootSumSquare(im_grappa_err);


figure, imshow(cat(1,cat(2,im_sqr,im_dc_sqr),cat(2,im_cgspirit_sqr,im_grappa_sqr)),[],'InitialMagnification',150);
title ('top-left:Full		top-right:zero-fill w/dc	bottom-left:SPIRiT 	 	bottom-right:GRAPPA');
figure, imshow(cat(2,im_cgspirit_err_sqr,im_grappa_err_sqr),[],'InitialMagnification',150);
title ('Difference images: SPIR-iT CG              GRAPPA');



