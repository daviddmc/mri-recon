function preConstant( op )

if ~op.isPreConstant

    for ii = 1 : length(op.inputList)
        op.inputList{ii}.preConstant();
    end

    if op.isConstant
        inputs = {};
        for ii = 1 : length(op.inputList)
            inputs{ii} = op.inputList{ii}.cache;
        end
        op.cache = op.apply_(inputs{:}, 0);
    end

    op.isPreConstant = 1;
    
end

end

