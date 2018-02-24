function c = cost( pocs, state )

c = 0;
for ii = 1 : length(pocs.inList)
    pocs.costList(ii) = pocs.inList{ii}.eval(state.var);
    c = c + pocs.costList(ii);
end


end

