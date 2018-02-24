function y = eval_( fs, varargin)

y = 0;
for ii = 1 : length(varargin) - 1
    y = y + varargin{ii};
    fs.savefun(ii) = varargin{ii};
end


end

