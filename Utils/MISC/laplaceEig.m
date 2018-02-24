function v = laplaceEig(sizeX, dim, w, type)
%LAPLACEEIG   Eigenvalue of the negative Laplacian operator
%   LAPLACEEIG(SIZ) is the eigenvalue of the negative laplacian operator.
%   SIZ is the size of the array on which the Laplacian operator acts.
%
%   LAPLACEEIG(SIZ, DIM) specifies the dimensions along which the Laplacian
%   is performed.
%
%   LAPLACEEIG(SIX, DIM, W) specifies the weight of each dimension. W(i) is 
%   the reciprocal of the step size along the i-th dimension.
%
%   LAPLACEEIG(SIX, DIM, W, TYPE) specifies the boundary condition of the 
%   Laplacian. The avaliable condition are:
%
%     'n' - (default) Neumann boundary condition (diagonalized by dct)
%     'p' - Periodic boundary condition (diagonalized by fft)

%   Copyright 2018 Junshen Xu

if nargin < 2 || isempty(dim)
    dim = 1 : length(sizeX);
end

if nargin < 3 || isempty(w)
    w = ones(size(dim));
end

if nargin < 4 || isempty(type)
    type = 'n';
end

if type == 'n' % Neumann
    v = 0;
    for ii = 1 : length(dim)
        d = dim(ii);
        s = sizeX(d);
        v = v + w(ii)^2 * reshape(2 - 2 * cos(pi*(0:s-1)/s), [ones(1, d-1), s, 1]);
    end
elseif type == 'p' % Periodic
    v = 0;
    for ii = 1 : length(dim)
        d = dim(ii);
        s = sizeX(d);
        v = v + w(ii)^2 * reshape(ifftshift(2 - 2 * cos(2*pi*(0:s-1)/s)), [ones(1, d-1), s, 1]);
    end
else
    error('Boundary condition must be ''n'' or ''p''!');
end


