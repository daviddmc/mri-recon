function a = dctn(a, ndim)
%DCTN   Discrete cosine transform for N-D arrays
%   DCTN(X) is the N dimensional discrete cosine transform (type 2) of the 
%   N-D array X. The results is normalized so that DCTN is an unitary 
%   operator.
%
%   DCTN(X, NDIM) performs dct along the first NDIM dimension of X.
%
%   See also idctn

%   This code is modified from Andriy Myronenko's Medical Image 
%   Registration Toolbox (MIRT) for Matlab (version 1.0), 
%   https://sites.google.com/site/myronenko/

%   Copyright 2018 Junshen Xu

persistent siz ww ind isreala na;

% Check input 
if (nargin == 0) || isempty(a)
    error('Insufficient input');
end

ndimFull = ndims(a);
if nargin < 2
    ndim = ndimFull;
end

% Check for the row vector
transpose=0;
if (ndimFull == 2) && (size(a,1)==1)
    transpose=1; a=a';
end



% Check if the variable size has changed and we need to
% precompute weights and indicies
precompute=0;
sizeTrans = size(a);
sizeTrans = sizeTrans(1:ndim);
if  ~exist('siz','var')
    precompute=1;
elseif abs(numel(siz)-ndim) > 0
    precompute=1;
elseif sum(abs(siz-sizeTrans)) > 0
    precompute=1;
elseif isreala ~= isreal(a)
    precompute=1;
elseif na ~= numel(a)
    precompute=1;
end

% Precompute weights and indicies
if precompute
    siz=sizeTrans;
    isreala = isreal(a);
    na = numel(a);
    
    for i=1:ndim
        n=siz(i);
        
        ww{i} = 2*exp(((-1i*pi)/(2*n))*(0:n-1)')/sqrt(2*n);
        ww{i}(1) = ww{i}(1) / sqrt(2);
        ind{i}=bsxfun(@plus, [(1:2:n) fliplr(2:2:n)]', 0:n:n*(na/n-1));
        if (siz(i)==1)
            break; 
        end
    end
    
end

% Actual multidimensional DCT. Handle 1D and 2D cases
% separately, because .' is much faster than shiftdim.
% check for 1D or 2D cases
if ndimFull == 2
    if min(siz) == 1 && (ndim == 1)
        a = dct(a,ww{1},ind{1});
        if transpose 
            a = a'; 
        end  % 1D case
    elseif ndim == 2
        a = dct(dct(a,ww{1},ind{1}).',ww{2},ind{2}).'; % 2D case
    else
        a = dct(a,ww{1},ind{1});
    end       
else
    % ND case (3D and higher)
    sizeFull = size(a);
    for i=1:ndim
        a=reshape(dct(reshape(a,sizeFull(1),[]),ww{i},ind{i}), sizeFull); % run dct along vectors (1st dimension)
        sizeFull = [sizeFull(2:end) sizeFull(1)];                   % circular shift of size array by 1
        a=shiftdim(a,1);                           % circular shift dimensions by 1
    end

    if ndimFull > ndim
        a=shiftdim(a,ndimFull - ndim);
    end
end


function a=dct(a,ww,ind)
%DCT  Discrete cosine transform 1D (operates along first dimension)

isreala=isreal(a);
k=1; 
if ~isreala 
    ia = imag(a); 
    a = real(a); 
    k=2; 
end % check if complex
    
% k=1 (if 'a' is real) and 2 (if 'a' is complex)
for i=1:k
     a=a(ind);     % rearange
     a = fft(a);  % ifft
     a = real(bsxfun(@times,  ww, a)); % multiply weights

    % check if the data is not real
    if ~isreala
        if i==1 
            ra = a; 
            a = ia; 
            clear ia;  % proceed to imaginary part
        else 
            a = complex(ra,a); 
        end        % finalize the output
    end

end
      


