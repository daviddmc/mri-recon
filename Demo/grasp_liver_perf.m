% GRASP (Golden-angle RAdial Sparse Parallel MRI)
% Combination of compressed sensing, parallel imaging and golden-angle
% radial sampling for fast dynamic MRI.
% This demo will reconstruct one slice of a contrast-enhanced liver scan.
% Radial k-space data are continously acquired using the golden-angle
% scheme and retrospectively sorted into a time-series of images using
% a number of consecutive spokes to form each frame. In this example, 21 
% consecutive spokes are used for each frame, which provides 28 temporal
% frames. The reconstructed image matrix for each frame is 384x384. The 
% undersampling factor is 384/21=18.2. TheNUFFT toolbox from Jeff Fessler 
% is employed to reconstruct radial data
% 
% Li Feng, Ricardo Otazo, NYU, 2012

clear all;close all;
nspokes=21;
% load radial data
load liver_data.mat
b1=b1/max(abs(b1(:)));
% data dimensions
[nx,ntviews,nc]=size(kdata);
for ch=1:nc,kdata(:,:,ch)=kdata(:,:,ch).*sqrt(w);end
% number of frames
nt=floor(ntviews/nspokes);
% crop the data according to the number of spokes per frame
kdata=kdata(:,1:nt*nspokes,:);
k=k(:,1:nt*nspokes);
w=w(:,1:nt*nspokes);
% sort the data into a time-series
for ii=1:nt
    kdatau(:,:,:,ii)=kdata(:,(ii-1)*nspokes+1:ii*nspokes,:);
    ku(:,:,ii)=k(:,(ii-1)*nspokes+1:ii*nspokes);
    wu(:,:,ii)=w(:,(ii-1)*nspokes+1:ii*nspokes);
end
% multicoil NUFFT operator
%param.E=MCNUFFT(ku,wu,b1);
E = NUFT([], 0, [size(b1,1), size(b1,2)], nt, nc, ku, wu, b1);
% undersampled data
%param.y=kdatau;
%clear kdata kdatau k ku wu w
% nufft recon
recon_nufft= E.adjoint(kdatau);
% parameters for reconstruction
G = Gradient([], 0, 3, []);
l1norm = L1Norm(G,  0.25*max(abs(recon_nufft(:))));
ssd = SumSquaredDifference({E, kdatau}, 1);
%param.W = TV_Temp();param.lambda=0.25*max(abs(recon_nufft(:)));
%param.nite = 8;
%param.display=1;

param.maxIter = 8;
param.stopCriteria = 'GRAD';
param.verbose = 2;
param.tol = 1e-6;
param.alpha = 0.01;  
param.beta = 0.6;

fprintf('\n GRASP reconstruction \n')
tic
recon_cs=recon_nufft;
nlcg = NLCG({ssd, l1norm});
for n=1:3,
    recon_cs = nlcg.run(recon_cs, param);
	%recon_cs = CSL1NlCg(recon_cs,param);
end
toc
recon_nufft=flipdim(recon_nufft,1);
recon_cs=flipdim(recon_cs,1);

% display 4 frames
recon_nufft2=recon_nufft(:,:,1);recon_nufft2=cat(2,recon_nufft2,recon_nufft(:,:,7));recon_nufft2=cat(2,recon_nufft2,recon_nufft(:,:,13));recon_nufft2=cat(2,recon_nufft2,recon_nufft(:,:,23));
recon_cs2=recon_cs(:,:,1);recon_cs2=cat(2,recon_cs2,recon_cs(:,:,7));recon_cs2=cat(2,recon_cs2,recon_cs(:,:,13));recon_cs2=cat(2,recon_cs2,recon_cs(:,:,23));
figure;
subplot(2,1,1),imshow(abs(recon_nufft2),[]);title('Zero-filled FFT')
subplot(2,1,2),imshow(abs(recon_cs2),[]);title('GRASP')
