function updateConstant(op, flag)

op.isPreConstant = 0;

if flag
    tmp = op.isConstant;
    op.isConstant = 1;
    for ii = 1 : length(op.inputList)
        if ~op.inputList{ii}.isConstant
            op.isConstant = 0;
            break;
        end
    end

    op.props = [];
    op.updateProp();
    flag = (tmp && ~op.isConstant) || (~tmp && op.isConstant);
end

for ii = 1 : length(op.outputList)
    op.outputList{ii}.updateConstant(flag);
end

end

