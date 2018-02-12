function y = apply_(op, varargin)

if op.signList(1) > 0
    y = varargin{1};
else
    y = -varargin{1};
end

for ii = 2 : length(op.inputList)
    if op.signList(ii) > 0
        y = y + varargin{ii};
    else
        y = y - varargin{ii};
    end
end

end

