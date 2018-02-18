function t = typeAtA( op, t)

% 0 : no AtA
% 1 : const
% 2 : diagonal
% 3 : F
% 4 : MtM

if nargin == 1
    t.type = 1;
end

if op.isLinear
    for ii = 1 : length(op.inputList)
        if ~op.inputList{ii}.isConstant
            t = op.typeAtA_(t);
            t = op.inputList{ii}.typeAtA(t);
            break
        end
    end
else
    t.type = 0;
end

end

