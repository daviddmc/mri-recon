function [f, Dx, Dy] = DemonRegistration2D(f, g, Dx, Dy, param)

[ny, nx, nt] = size(f);

if nargin < 4 || isempty(Dx) || isempty(Dy)
    
    [Dx, Dy] = meshgrid(1:nx, 1:ny);
    Dx = repmat(Dx, [1, 1, nt]);
    Dy = repmat(Dy, [1, 1, nt]);
    
end

defaultParam = struct('alpha', 2.5,...
                      'sigma', 10,...
                      'ksize', [60, 60],...
                      'maxIter', 100);
if nargin == 5
    param = setDefaultField(defaultParam, param);
else
    param = defaultParam;
end
alpha = param.alpha;
Hsmooth = 3 * fspecial('gaussian', param.ksize, param.sigma);

for nframe = 1 : nt
    
    I1 = f(:,:,nframe); 
    I2 = g(:,:,nframe);
    S = I2; 
    
    Tx = Dx(:,:,nframe); 
    Ty = Dy(:,:,nframe);
    %M = I1;
    M = linearInterp2D_mex(I1, Tx, Ty);

    [Sx, Sy] = gradient(S);
    dS2 = abs(Sx).^2 + abs(Sy).^2;

    for iter = 1 : param.maxIter
        Idiff = S - M;
        alphaIdiff2 = alpha^2 * abs(Idiff).^2 + eps;
        [Mx, My] = gradient(M);
        dM2 = abs(Mx).^2 + abs(My).^2;
              
        Ux = Idiff.*((Sx./(dS2 + alphaIdiff2)) + (Mx./(dM2 + alphaIdiff2)));
        Uy = Idiff.*((Sy./(dS2 + alphaIdiff2)) + (My./(dM2 + alphaIdiff2)));
        
        Ux(isnan(Ux))=0; Uy(isnan(Uy))=0;
        
        Ux = imfilter(Ux, Hsmooth);
        Uy = imfilter(Uy, Hsmooth);
        
        Tx = Tx + Ux;
        Ty = Ty + Uy;

        M = linearInterp2D_mex(I1, Tx, Ty);
       
    end
    
Dx(:,:,nframe) = Tx;
Dy(:,:,nframe) = Ty;
f(:,:,nframe) = M;

end

end
