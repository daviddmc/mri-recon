function varList = uniqueVarList( varList1, varList2 )

len1 = length(varList1);
len2 = length(varList2);

if ~len1
    varList = varList2;
    return
elseif ~len2
    varList = varList1;
    return
end

ii = 1;
jj = 1;
kk = 1;

while(1)

    if varList1{ii}.name == varList2{jj}.name
        varList{kk} = varList1{ii};
        ii = ii + 1;
        jj = jj + 1;
    elseif varList1{ii}.name < varList2{jj}.name
        varList{kk} = varList1{ii};
        ii = ii + 1;
    else
        varList{kk} = varList2{jj};
        jj = jj + 1;
    end
    kk = kk + 1;
    
    if ii > len1
        varList(kk:len2-jj+kk) = varList2(jj:len2);
        break;
    end
    
    if jj > len2
        varList(kk:len1-ii+kk) = varList1(ii:len1);
        break;
    end

end

end

