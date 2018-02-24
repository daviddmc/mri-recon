function state = update( pocs, state )

x = state.var;

for ii = 1 : length(pocs.inList)
    x = pocs.inList{ii}.prox(1, x);
end

state.var = x;

end

