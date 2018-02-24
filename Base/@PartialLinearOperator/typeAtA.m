function t = typeAtA( op, t)

% 0 : no AtA
% 1 : const
% 2 : diagonal
% 3 : F
% 4 : MtM

if nargin == 1
    t.type = 1;
end

if isa(op, 'PartialLinearOperator')
    for ii = 1 : op.numInput
        if ~op.inList{ii}.isConstant
            t = op.typeAtA_(t);
            t = op.inList{ii}.typeAtA(t);
            break
        end
    end
else
    t.type = 0;
end

end

