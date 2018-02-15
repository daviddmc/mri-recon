%
% 2008-09-22 Martin Uecker <muecker@gwdg.de>
% Biomedizinische NMR Forschungs GmbH am
% Max-Planck-Institut fuer biophysikalische Chemie
%

clear all
close all


n = 8;
Y = simu(128, 128);

	disp('Start...')

	alpha = 1.;

	[x, y, c] = size(Y);

	R = zeros(x, y, n);
    
	% initialization x-vector
    
 	X0 = zeros(x, y, c + 1);
	X0(:,:,1) = 1.;	%object part
    %X0(:,:,:) = 1;
    
	% initialize mask and weights

	%P = pattern(Y);
    mask = (Y ~= 0); 
    [kx, ky] = meshgrid(linspace(-0.5, 0.5, x), linspace(-0.5, 0.5, y));
    W = 1 ./ (1 + 220 * (kx.^2 + ky.^2)).^16; %16
	% normalize data vector
    
	yscale = 100. / sqrt(Y(:)'*Y(:));
	YS = Y * yscale;

   	XN = X0;
    
    I = Identity([]);
    ww = Weighting([], 0, W);
    Fw = FourierTransformation(ww, 1, [1,2]);
    bd = BlockDiagonal('1', {I, Fw}, {1, 2:c+1});
    
    C = SensitivityMap([], 0, XN(:,:,2:end), 0);
    %C = Weighting([], 0, X0(:,:,2:end));
    Rho = Weighting([], 0, XN(:,:,1));
    
    bm = BlockMatrix(bd, {C, Rho}, 0, 3, {1, 2:c+1});
    
    Fbm = FourierTransformation(bm, 0, [1,2]);
    DG = Undersampling(Fbm, 0, mask, false);
    
    Fc = FourierTransformation(C, 0 ,[1,2]);
    G = Undersampling(Fc, 0, mask, false);
    
    tol = 1e-2;
	for i = 1:n
        
        Res1 = YS - G.apply(XN(:,:,1));
        Res2 = X0 - XN;
	    
        
        param.maxIter = 500;
        param.verbose = 2;
        param.tol = 1e-3;
        lq = LSQR({DG, []}, {Res1, Res2}, [1, sqrt(alpha)]);
        z = lq.run(XN, param);
		XN = XN + z;
		alpha = alpha / 3.;
        cmap = Fw.apply(XN(:,:,2:end));    
        R(:, :, i) = XN(:, : , 1) .* rootSumSquare(cmap) / yscale;
        
        C.map = cmap;
        Rho.w = XN(:,:,1);
        
	end
    






