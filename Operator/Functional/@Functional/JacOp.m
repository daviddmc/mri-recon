function y = JacOp(fun, varargin)

len = length(varargin);
dx = varargin(1:len/2);
x = varargin(len/2+1:1);

g = fun.gradOp(fun.mu, x{:});

y = 0;

for ii = 1 : len
    y = y + g{ii}(:)' * dx{ii}(:);
end

end

