function  [topoSort, refList, varList, clearIdx] = getTopoList(op)

if isempty(op.topoSort)
    inputList = op.inList(1 : op.numInput);
    [topoSort, refList, varList, ~] = inputList{1}.getTopoList;
    idx = length(topoSort);

    for ii = 2 : op.numInput
        
        [topoSortii, refListii, varListii, ~] = inputList{ii}.getTopoList;
        [topoSort, refList, pos] = combineTopoSort(topoSort, refList,...
            topoSortii, refListii);
        idx = [idx pos];
        varList = uniqueVarList(varList, varListii);
        
    end

    op.topoSort = [topoSort {op}];
    op.refList = [refList idx];
    op.varList = varList;

    lastCall = zeros(1, length(op.topoSort));
    for ii = 1 : length(op.topoSort)
        lastCall(op.refList{ii}) = ii;
    end
    clearIdx = cell(1, length(op.topoSort));
    for ii = 1 : length(op.topoSort) - 1
        clearIdx{lastCall(ii)}(end+1) = ii;
    end
    op.clearIdx = clearIdx;
end

topoSort = op.topoSort;
refList = op.refList;
varList = op.varList;
clearIdx = op.clearIdx;
