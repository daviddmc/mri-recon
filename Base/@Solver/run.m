function [x, info] = run(solver, x0)
%RUN run optimization algorithm

isSaveInfo = nargout > 1;

if ~solver.isFunReady
    solver.checkFun();
    solver.isFunReady = 1;
end
if ~solver.isParamReady
    solver.parseParam();
    solver.isParamReady = 1;
end

param = solver.param;

state.var = x0;
state.varDual = [];
state.cost = [];
state.iter = 0;
state = solver.initialize(state);
useCost = param.verbose > 1 || isSaveInfo || strcmpi(param.stopCriteria, 'COST_UPDATE');
if useCost && isempty(state.cost)
    state.costOld = solver.cost(state);
else
    state.costOld = state.cost;
end
state.varOld = state.var;
state.varDualOld = state.varDual;

if isSaveInfo
    info.cost = zeros(1, param.maxIter);
end

useCost = param.verbose > 1 || isSaveInfo || strcmpi(param.stopCriteria, 'COST_UPDATE');

if param.verbose
    disp('---------- OPTIMIZATION START ----------');
end

optStart = tic;

for iter = 1 : param.maxIter
    
    iterStart = tic;
    
    state.iter = iter;
    state = solver.update(state);
    if useCost && isempty(state.cost)
        state.cost = solver.cost(state);
    end
    
    [isStop, convergeInfo] = solver.testConvergence(state);
    
    if param.verbose
        fprintf('Iteration %d, iter time: %f sec, total time:%f sec\n', ...
            iter, toc(iterStart), toc(optStart));
        if param.verbose > 1
            solver.verboseOutput(state);
            len = length(convergeInfo);
            if len
                formatStr = repmat(' %s : %f,', [1, len/2]);
                formatStr(end) = newline;
                fprintf(formatStr, convergeInfo{:});
            end
        end
    end
    
    if ~isempty(param.plotFun) && ...
            (~mod(iter, param.plotInterval) || iter == param.maxIter || isStop) 
        solver.param.plotFun(state);
        drawnow;
    end
    
    if isSaveInfo
        info.cost(iter) = state.cost;
    end

    if isStop
        break;
    end
    
    state.varOld = state.var;
    state.varDualOld = state.varDual;
    state.costOld = state.cost;
    state.cost = [];
    
end

state = solver.finalize(state);

if param.verbose
    disp('----------- OPTIMIZATION END -----------');
end

x = state.var;

if isSaveInfo
    if isStop
        info.stopCriteria = param.stopCriteria;
    else
        info.stopCriteria = 'MAX_ITERATION';
    end
    info.iter = iter;
    info.cost = info.cost(1 : info.iter);
    %info.costFinal = info.cost(1 : info.iter);
    info.algorithm = solver.name;
    info.time = toc(optStart);
end

end

