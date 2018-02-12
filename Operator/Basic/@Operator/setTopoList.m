function setTopoList( op )


inputList = op.inputList;
%{
if op.isConstant
    op.cache = [];
    op.topoSort = {op};
    op.refList = {[]};
    op.varList = {};
    op.clearIdx = {[]};
else
  %}  
    
    topoSort = inputList{1}.topoSort;
    refList = inputList{1}.refList;
    varList = inputList{1}.varList;
    idx = length(topoSort);

    for ii = 2 : length(inputList)
        [topoSort, refList, pos] = combineTopoSort(topoSort, refList,...
            inputList{ii}.topoSort, inputList{ii}.refList);
        idx = [idx pos];
        varList = uniqueVarList(varList, inputList{ii}.varList);
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

%end

