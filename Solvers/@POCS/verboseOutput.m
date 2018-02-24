function verboseOutput(pocs, state)

if isempty(pocs.costList)
    c = pocs.cost(state);
else
    c = sum(pocs.costList);
end

len = length(pocs.inList);
infoStr = '';

if len > 1
    for ii = 1 : len
        infoStr = [infoStr, 'f', num2str(ii), ' = %f, '];
    end
    infoStr = [infoStr 'total cost = %f\n'];
    fprintf(infoStr, [pocs.costList, c]);
else
    infoStr = 'cost = %f\n';
    fprintf(infoStr, c);
end

pocs.costList = [];

end

