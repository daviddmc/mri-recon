function f = eval(fun, varargin)

    f = fun.apply(varargin{:});

end