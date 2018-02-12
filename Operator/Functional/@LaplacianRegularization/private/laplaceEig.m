function eigvalue = laplaceEig(size_in)

if length(size_in) == 1
    size_in(2) = 1;
end

eigvalue = zeros(size_in);

for ii = 1 : length(size_in)
    v = cos((pi/size_in(ii))*(0:size_in(ii)-1));
    dim = ones(1,length(size_in));
    dim(ii) = size_in(ii);
    v = reshape(v,dim);
    dim = size_in;
    dim(ii) = 1;
    eigvalue = eigvalue + repmat(v,dim);
end

eigvalue = 2 * (2 - eigvalue);

end


