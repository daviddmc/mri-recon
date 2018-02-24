function f = apply_( fun, varargin )

if nargout > 0
    f = fun.eval_(varargin{:});
    f = fun.mu * f;
else
    fun.eval_(varargin{:});
end

end

