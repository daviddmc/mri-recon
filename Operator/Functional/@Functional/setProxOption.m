function setProxOption(fun, varargin )

for ii = 1 : 2 : length(varargin)
    fun.proxOption.(varargin{ii}) = varargin{ii + 1};
end

end

