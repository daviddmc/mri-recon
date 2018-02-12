function state = initialize( alm, state)

state.mu = alm.param.mu;
state.beta = alm.param.beta;
state.varDual = cell(1, length(alm.varDualList));
state.varDual(:) = {0};

for ii = 2 : length(alm.varList)
    alm.varList{ii}.setVar(state.var{ii});
end

end

