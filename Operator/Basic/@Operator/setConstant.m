function setConstant( op )

inputList = op.inputList;

op.isConstant = 1;
for ii = 1 : length(inputList)
    if ~inputList{ii}.isConstant
        op.isConstant = 0;
        break;
    end
end

%if op.isConstant
%    op.isLinear_ = 1;
%end


end

