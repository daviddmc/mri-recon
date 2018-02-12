function state = update( alm, state )

len = length(state.var);
for ii = 1 : len
    if alm.typeList(ii) == 1 %prox
        state.var{ii} = alm.varfList{ii}.prox(1/state.mu(alm.varEqList{ii}), alm.sumPrimal{ii}.apply(), alm.HList{ii});
    elseif alm.typeList(ii) == 2
        state.var{ii} = subSSD(alm.AList{ii}, alm.bList{ii}, [alm.varfList{ii}.mu, state.mu(alm.varEqList{ii})], alm.typeAtAList(ii), alm.FList{ii});
    else
        state.var{ii} = subSSD(alm.AList{ii}, alm.bList{ii}, state.mu(alm.varEqList{ii}), alm.typeAtAList(ii), alm.FList{ii});
    end
    alm.varList{ii}.setVar(state.var{ii});
    if ii < len
        alm.varList{ii+1}.setVar();
    end
end

for ii = 1 : length(state.varDual)
    state.varDual{ii} = alm.sumDual{ii}.apply();
    alm.varDualList{ii}.setVar(state.varDual{ii});
end

alm.varList{1}.setVar();

state.mu = state.mu * state.beta;

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
