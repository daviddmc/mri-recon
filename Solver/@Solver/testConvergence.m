function [isStop, convergenceInfo] = testConvergence( solver, state )

isStop = 0;
switch solver.param.stopCriteria
    case 'COST_UPDATE'
        costUpdate = state.cost - state.costOld;
        if abs(costUpdate) < max(1, state.cost) * solver.param.tol
            isStop = 1;
        end
        convergenceInfo = {'cost update', costUpdate, 'cost update rel', costUpdate / state.cost};
    case 'PRIMAL_UPDATE'
        [x, dx] = getPrimalVar(state);
        primalUpdateNorm = norm(dx);
        primalNorm = norm(x);
        if primalUpdateNorm < max(1, primalNorm) * solver.param.tol
            isStop = 1;
        end
        convergenceInfo = {'primal update', primalUpdateNorm, 'primal update rel', primalUpdateNorm / primalNorm};
    case 'DUAL_UPDATE'
        [x, dx] = getDualVar(state);
        dualUpdateNorm = norm(x - dx);
        dualNorm = norm(x);
        if dualUpdateNorm < max(1, dualNorm) * solver.param.tol
            isStop = 1;
        end
        convergenceInfo = {'dual update', dualUpdateNorm, 'dual update rel', dualUpdateNorm / dualNorm};
    case 'PRIMAL_DUAL_UPDATE'
        [x, dx] = getPrimalVar(state);
        [xDual, dxDual] = getDualVar(state);
        primalUpdateNorm = norm(dx);
        dualUpdateNorm = norm(dxDual);
        primalNorm = norm(x);
        dualNorm = norm(xDual);
        if primalUpdateNorm < max(1, primalNorm) * solver.param.tol && ...
           dualUpdateNorm < max(1, dualNorm) * solver.param.tol
            isStop = 1;
        end
        convergenceInfo = {'primal update', primalUpdateNorm, 'primal update rel', primalUpdateNorm / primalNorm, ...
            'dual update', dualUpdateNorm, 'dual supdate rel', dualUpdateNorm / dualNorm};
    case 'RESIDUAL'
        %
    case 'GRAD'
        % 
    case 'MAX_ITERATION'
        % do nothing
        convergenceInfo = {};
    otherwise
        error('unknown criteria')
end

if state.iter < 2
    isStop = 0;
end

end

function [x, dx] = getPrimalVar(state)
if iscell(state.var)
    xs = state.var;
    dxs = state.varOld;
    for ii = 1 : length(xs)
        xs{ii} = xs{ii}(:);
        dxs{ii} = xs{ii} - dxs{ii}(:);
    end
    x = cat(1, xs{:});
    dx = cat(1, dxs{:});
else
    x = state.var(:);
    dx = x - state.varOld(:);
end
end

function [x, dx] = getDualVar(state)
if iscell(state.varDual)
    xs = state.varDual;
    dxs = state.varDualOld;
    for ii = 1 : length(xs)
        xs{ii} = xs{ii}(:);
        dxs{ii} = xs{ii} - dxs{ii}(:);
    end
    x = cat(1, xs{:});
    dx = cat(1, dxs{:});
else
    x = state.varDual(:);
    dx = x - state.varDualOld(:);
end
end
