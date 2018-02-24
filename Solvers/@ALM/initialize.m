function state = initialize( alm, state)

alm.isRunning = true;

state.mu = alm.param.mu;
state.beta = alm.param.beta;
state.varDual = cell(1, length(alm.varDualList));
state.varDual(:) = {0};
state.numVar = length(state.var);
state.numVarDual = length(state.varDual);

for ii = 2 : length(alm.varList)
    alm.varList{ii}.setInput(state.var{ii});
end

for ii = 1 : state.numVar
    if alm.subProblem{ii}.type == 3
        alm.subProblem{ii}.lq.setParam(alm.param.paramCG);
    end
end

end

