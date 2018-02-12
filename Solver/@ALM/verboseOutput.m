function verboseOutput(alm, state)

if isempty(alm.costList)
    c = alm.cost(state);
else
    c = sum(alm.costList);
end

len = length(alm.fList);
infoStr = '';

if len > 1
    for ii = 1 : length(alm.fList)
        infoStr = [infoStr, 'f', num2str(ii), ' = %f, '];
    end
    infoStr = [infoStr 'total cost = %f\n'];
    fprintf(infoStr, [alm.costList, c]);
else
    infoStr = 'cost = %f\n';
    fprintf(infoStr, c);
end

alm.costList = [];

end

