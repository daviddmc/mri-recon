% SAKE Reconstruction Demo
% This a demo on how to use the SAKE method to perform autocalibration with
% no autocalibration lines. It is based on P. Shin et. al, "Calibrationless Parallel 
% Imaging Reconstruction Based on Structured Low-Rank Matrix Completion"
% 2013, submitted to MRM. The demo here shows how to recover a calibration
% area and then use ESPIRiT to recover the image. 

clear all
close all


%% Prepare DATA

load brain_8ch

F = FourierTransformation([], 0, [1,2]);

DATA = DATA/max(max(max(abs(F.adjoint(DATA))))) + eps;

ncalib = 48;
ksize = [6,6]; % ESPIRiT kernel-window-size

sakeIter = 100;
wnthresh = 1.8; % Window-normalized number of singular values to threshold
eigThresh_im = 0.9; % threshold of eigenvectors in image space
[sx,sy,Nc] = size(DATA);


mask = mask_nocalib_x2half;     % choose a 3x no calibration mask
DATAc = DATA.* repmat(mask,[1,1,size(DATA,3)]);
calibc = cropCenter(DATAc,[ncalib,ncalib]);

%%
% Display sampling mask and root sos of zero-filled reconstruction

im = F.adjoint(DATAc);

figure, imshow(cat(2,mask,rootSumSquare(im)),[]); 


%% Perform SAKE reconstruction to recover the calibration area

disp('Performing SAKE recovery of calibration');

%tic;, calib = SAKE(calibc, [ksize], wnthresh,sakeIter, 0);toc

U = Undersampling([], 0, mask, false);
DC = LinearEquation({U, DATAc});
H = Hankel([], 0, size(im), ksize);

%option.maxIter = 1;
%option.type = 0;
%nucNorm = NuclearNorm(H, 3, 2, 1, option); %3 dim=2
LR = LowRank(H, wnthresh * prod(ksize));

pocs = POCS({LR, DC});

param.maxIter = sakeIter;
param.verbose = 2;
x0 = F.apply(im);
[x, info] = pocs.run(x0, param);


figure, imshow(rootSumSquare(F.adjoint(x)),[]); 


