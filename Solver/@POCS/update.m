function state = update( pocs, state )

x = state.var;

for ii = 1 : length(pocs.fList)
    x = pocs.fList{ii}.prox(1, x);
end

state.var = x;

end

