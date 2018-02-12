
clear all
close all
%load phantom.mat
load brain_8ch


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% Reconstruction Parameters %%%%%%%%%%%%%%%%%%%
%						     %	 			
kSize = [5,5];  % SPIRiT kernel size
nIterCG = 30; % number of iteration; phantom requires twice as much as the brain.
mask_type = 'unif'; % options are: 'unif','random4','random3'
CalibTyk = 0.01;  % Tykhonov regularization in the calibration
ReconTyk = 1e-5;  % Tykhovon regularization in the reconstruction (SPIRiT only)
addNoiseSTD = 0.0; % add noise. Use only for phantom. Brain has enough noise!
skipGRAPPA = 1; % skip GRAPPA recon.

DATA = DATA+randn(size(DATA))*addNoiseSTD + 1i*randn(size(DATA))*addNoiseSTD;

F = FourierTransformation([], 0, [1,2]);
im = F.adjoint(DATA);

switch mask_type
    case 'unif'
           mask = mask_unif;
           disp('Using uniform undersampling.')
           disp('Change mask_type in the code for other sampling patterns.');
           disp(' ');
           disp(' ');
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
kCalib = cropCenter(DATA,[CalibSize,coils]);

%kernel = calibSPIRiT(kCalib, kSize, coils, CalibTyk);
%GOP = SPIRiT(kernel, 'fft',[fe,pe]);
GOP = SPIRiT([], 0, kCalib, kSize, CalibTyk, 'freq', [fe, pe], true);

Mnacq = Undersampling([], 1, DATA == 0, true);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%                  Reconstruction                        %%%%%%%%%


disp('performing CG reconstruction')

%[res_cg, RESVEC] = cgSPIRiT(DATA,GOP,nIterCG,ReconTyk, DATA);

%param.lambda = ReconTyk;
param.maxIter = nIterCG;
param.verbose = 2;
b = -GOP.apply(DATA);
GOP.setInput(1, Mnacq);
x0 = Mnacq.adjoint(DATA);

lq = LSQR({GOP, []}, {b, 0*x0}, [1, ReconTyk]);
%[res_cg, info] = LSQR(GOP, b, x0, param);
[res_cg, info] = lq.run(x0, param);

res_cg = Mnacq.apply(res_cg);
res_cg = res_cg + DATA;

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



