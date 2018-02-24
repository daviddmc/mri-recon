function varargout = grad(fun, varargin)
    
    [varargout{1:length(varargin)}] = fun.gradOp(fun.mu, varargin{:});

end  