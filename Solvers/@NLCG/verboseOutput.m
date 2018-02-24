function verboseOutput(nlcg, ~)

len = length(nlcg.f.inList);
infoStr = '';

if len > 1
    for ii = 1 : len
        infoStr = [infoStr, 'f', num2str(ii), ' = %f, '];
    end
    infoStr = [infoStr 'total cost = %f\n'];
    fprintf(infoStr, [nlcg.f.savefun, sum(nlcg.f.savefun)]);
else
    infoStr = 'cost = %f\n';
    fprintf(infoStr, sum(nlcg.f.savefun));
end

end

