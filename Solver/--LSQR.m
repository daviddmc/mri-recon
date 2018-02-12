function [ x, info ] = LSQR( A, b, x0, param)

t1 = tic;

if nargin < 4
    param = struct();
end

if ~isfield(param, 'lambda')
    lambda = 0;
else
    lambda = param.lambda;
end

if ~isfield(param, 'L')
    L = Identity("LSQR_IDENTITY");
else
    L = param.L;
end

if ~isfield(param, 'maxIter')
    maxIter = 100;
else
    maxIter = param.maxIter;
end

if ~isfield(param, 'tol')
    tol = 1e-6;
else
    tol = param.tol;
end

if ~isfield(param, 'verbose')
    verbose = 1;
else
    verbose = param.verbose;
end

sizeX = size(x0);
sizeAX = size(A.apply(x0));
sizeLX = size(L.apply(x0));

if lambda
    AfunHandle = @(x, tflag) AfunReg(A, lambda, L, sizeX, sizeAX, sizeLX, x, tflag);
    b = [b(:); 0*x0(:)];
else
    AfunHandle = @(x, tflag) Afun(A, sizeX, sizeAX, x, tflag);
    b = b(:);
end

[x, flag, relRes, iter, resVec] = lsqr(AfunHandle, b, tol, maxIter, [], [], x0(:));
x = reshape(x, sizeX);

info.iter = iter;
info.flag = flag;
info.relRes = relRes;
info.resVec = resVec;
info.algo = mfilename;
info.time = toc(t1);
    
function [y,tflag] = AfunReg(A, lambda, L, sizeX, sizeAX, sizeLX, x, tflag)
if strcmp(tflag,'transp')
    numelAX = prod(sizeAX);
    y = A.adjoint(reshape(x(1:numelAX), sizeAX));
    y = y + lambda * L.adjoint(reshape(x(numelAX+1:end), sizeLX));
    y = y(:);
else
    y = A.apply(reshape(x, sizeX));
    x = L.apply(reshape(x, sizeX));
    y = [y(:) ; lambda * x(:)];
end

    
function [y, tflag] = Afun(A, sizeX, sizeAX, x, tflag)
if strcmp(tflag,'transp')
    y = A.adjoint(reshape(x, sizeAX));
    y = y(:);
else
    y = A.apply(reshape(x, sizeX));
    y = y(:);
end

    