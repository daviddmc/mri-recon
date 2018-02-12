function setVar(op, v)

if nargin > 1
    op.cache = v;
    if op.isConstant
        for ii = 1 : length(op.outputList)
            op.outputList{ii}.updateConstant(0);
        end
    else
        op.isConstant = 1;
        for ii = 1 : length(op.outputList)
            op.outputList{ii}.updateConstant(1);
        end
    end
else
    op.isConstant = 0;
    op.cache = [];
    for ii = 1 : length(op.outputList)
        op.outputList{ii}.updateConstant(1);
    end
end
