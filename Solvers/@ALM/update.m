function state = update( alm, state )

%len = length(state.var);
for ii = 1 : state.numVar
    p = alm.subProblem{ii};
    switch p.type
        case 1 % prox
            state.var{ii} = p.f.prox(1/state.mu(p.eqIdx), p.sumPrimal.apply(), p.H);
        case 2 % ssd (analytic)
            if p.eqOnly
                lambdas = state.mu(p.eqIdx);
            else
                lambdas = [p.f.mu, state.mu(p.eqIdx)];
            end
            state.var{ii} = subSSD(p.AList, p.bList, lambdas, p.typeAtA, p.F);
        case 3 % ssd (cg-iteration)
            if p.eqOnly
                lambdas = sqrt(state.mu(p.eqIdx));
            else
                lambdas = sqrt([p.f.mu, state.mu(p.eqIdx)]);
            end
            p.lq.setLambda(lambdas);
            state.var{ii} = p.lq.run(state.var{ii});
        otherwise
            error('unknown error');
    end
    alm.varList{ii}.setInput(state.var{ii});
    if ii < state.numVar
        alm.varList{ii+1}.setInput();
    end
    %{
    switch alm.typeList(ii)
        case 1
            state.var{ii} = alm.varfList{ii}.prox(1/state.mu(alm.varEqList{ii}), alm.sumPrimal{ii}.apply(), alm.HList{ii});
        case 2
            state.var{ii} = subSSD(alm.AList{ii}, alm.bList{ii}, [alm.varfList{ii}.mu, state.mu(alm.varEqList{ii})], alm.typeAtAList(ii), alm.FList{ii});
        case 0
            state.var{ii} = subSSD(alm.AList{ii}, alm.bList{ii}, state.mu(alm.varEqList{ii}), alm.typeAtAList(ii), alm.FList{ii});
        case {-3, -1}
            for jj = 1 : length(alm.bList{ii})
                bList{jj} = alm.bList{ii}{jj}.apply();
            end
            if alm.typeList(ii) == -1
                lq = LSQR(alm.AList{ii}, bList, sqrt([alm.varfList{ii}.mu, state.mu(alm.varEqList{ii})]), alm.param.paramCG);
            else
                lq = LSQR(alm.AList{ii}, bList, sqrt(state.mu(alm.varEqList{ii})), alm.param.paramCG);
            end
            state.var{ii} = lq.run(state.var{ii});
        otherwise
            error(' ');
    end
    alm.varList{ii}.setInput(state.var{ii});
    if ii < len
        alm.varList{ii+1}.setInput();
    end
    %}
end

for ii = 1 : state.numVarDual
    state.varDual{ii} = alm.sumDual{ii}.apply();
    alm.varDualList{ii}.setInput(state.varDual{ii});
end

alm.varList{1}.setInput();

if mod(state.iter, alm.param.updateInterval) == 0
    for ii = 1 : length(state.varDual)
        state.mu(ii) = state.mu(ii) * state.beta(ii);
        state.varDual{ii} = state.varDual{ii} / state.beta(ii);
    end
end

end

function x = subSSD(AList, bList, muList, type, F)

if isempty(bList{1})
    rhs = 0;
else
    rhs = AList{1}.adjoint(bList{1}.apply());
end
R = AList{1}.AtA;
if muList(1) ~= 1
    rhs = muList(1) * rhs;
    R = muList(1) * R;
end

if type == 1 || type == 2
    for ii = 2 : length(AList)
        if muList(ii) == 1
            rhs = rhs + muList(ii) * AList{ii}.adjoint(bList{ii}.apply());
            R = R + muList(ii) * AList{ii}.AtA;   
        else
            rhs = rhs + AList{ii}.adjoint(bList{ii}.apply());
            R = R + AList{ii}.AtA;
        end
    end
else
    for ii = 2 : length(AList)
        tmp = AList{ii}.AtA;
        if muList(ii) == 1
            rhs = rhs + muList(ii) * AList{ii}.adjoint(bList{ii}.apply());
            
            nR = numel(R);
            nt = numel(tmp);
            if nR == nt
                R = R + muList(ii) * tmp;
            elseif nR > nt
                n = size(R, 1);
                R(1:n+1:end) = R(1:n+1:end) + muList(ii) * tmp;
            else
                n = size(tmp, 1);
                tmp(1:n+1:end) = muList(ii) * tmp(1:n+1:end) + R;
                R = tmp;
            end
        else
            rhs = rhs + AList{ii}.adjoint(bList{ii}.apply());
            nR = numel(R);
            nt = numel(tmp);
            if nR == nt
                R = R +  tmp;
            elseif nR > nt
                n = size(R, 1);
                R(1:n+1:end) = R(1:n+1:end) +  tmp;
            else
                n = size(tmp, 1);
                tmp(1:n+1:end) = tmp(1:n+1:end) + R;
                R = tmp;
            end
        end
    end
end


if type == 1
    x = rhs ./ R;
elseif type == 2
    x = F.adjoint(F.apply(rhs) ./ R);
else
    x = R \ rhs;
end

end
