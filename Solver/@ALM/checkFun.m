function checkFun(alm)

varList = {};
varfList = {};

for ii = 1 : length(alm.fList)
    vs = alm.fList{ii}.varList;
    for jj = 1 : length(vs)
        flag = 0;
        for kk = 1 : length(varList)
            if vs{jj}.name < varList{kk}.name
                varList = [varList(1 : kk - 1), vs(jj), varList(kk : end)];
                varfList = [varfList(1 : kk - 1), alm.fList(ii), varfList(kk : end)];
                flag = 1;
                break;
            elseif vs{jj}.name == varList{kk}.name
                error(' ')
            end
        end
        if ~flag
            varList = [varList, vs(jj)];
            varfList = [varfList, alm.fList(ii)];
        end
    end
end

varEqList = cell(1, length(varList));
varEqPosList = cell(1, length(varList));

for ii = 1 : length(alm.eqList)

    for jj = 1 : length(alm.eqList{ii}.lhs)
        vs = alm.eqList{ii}.lhs{jj}.varList;
        for ll = 1 : length(vs)
            flag = 0;
            for kk = 1 : length(varList)
                if vs{ll}.name < varList{kk}.name
                    varList = [varList(1 : kk - 1), vs(ll), varList(kk : end)];
                    varfList = [varfList(1 : kk - 1), {[]}, varfList(kk : end)];
                    varEqList = [varEqList(1 : kk - 1), {ii}, varEqList(kk : end)];
                    varEqPosList = [varEqPosList(1 : kk - 1), {jj}, varEqPosList(kk : end)];
                    flag = 1;
                    break;
                elseif vs{ll}.name == varList{kk}.name
                    varEqList{kk}(end+1) = ii;
                    varEqPosList{kk}(end+1) = jj;
                    flag = 1;
                    break;
                end
            end
            if ~flag
                varList = [varList, vs(ll)];
                varfList = [varfList, {[]}];
                varEqList = [varEqList, {ii}];
                varEqPosList = [varEqPosList, {jj}];
            end
        end
    end
    
    for jj = 1 : length(alm.eqList{ii}.rhs)
        vs = alm.eqList{ii}.rhs{jj}.varList;
        for ll = 1 : length(vs)
            flag = 0;
            for kk = 1 : length(varList)
                if vs{ll}.name < varList{kk}.name
                    varList = [varList(1 : kk - 1), vs(ll), varList(kk : end)];
                    varfList = [varfList(1 : kk - 1), {[]}, varfList(kk : end)];
                    varEqList = [varEqList(1 : kk - 1), {ii}, varEqList(kk : end)];
                    varEqPosList = [varEqPosList(1 : kk - 1), {-jj}, varEqPosList(kk : end)];
                    flag = 1;
                    break;
                elseif vs{ll}.name == varList{kk}.name
                    varEqList{kk}(end+1) = ii;
                    varEqPosList{kk}(end+1) = -jj;
                    flag = 1;
                    break;
                end
            end
            if ~flag
                varList = [varList, vs(ll)];
                varfList = [varfList, {[]}];
                varEqList = [varEqList, {ii}];
                varEqPosList = [varEqPosList, {-jj}];
            end
        end
    end
    
end
   
varDualList = cell(1, length(alm.eqList));
for ii = 1 : length(alm.eqList)
    varDualList{ii} = Variable.getVariable(['ALM_DUAL_' num2str(ii)]);
    varDualList{ii}.setVar(0);
    sumDual{ii} = Sum([alm.eqList{ii}.lhs, alm.eqList{ii}.rhs, varDualList(ii)], ...
        [ones(1, length(alm.eqList{ii}.lhs)), -ones(1, length(alm.eqList{ii}.rhs)), 1]);
end

len = length(varList);
typeList = zeros(1, len);
AList = cell(1, len);
bList = cell(1, len);
HList = cell(1, len);
sumPrimal = cell(1, len);
%I = Identity([]);
for ii = 1 : length(varList)
    
    if length(unique(varEqList{ii})) ~= length(varEqList{ii})
        error(' ');
    end
    
    if isempty(varfList{ii}) % only eqs
        if length(varEqList{ii}) == 1 %SSD
            error(' ')
        end
    else
        if isa(varfList{ii}, 'SumSquaredDifference')
            typeList(ii) = 2;
            for jj = 1 : length(varfList{ii}.inputList{1}.varList)
                if varList{ii}.name == varfList{ii}.inputList{1}.varList{jj}.name
                    AList{ii}{1} = varfList{ii}.inputList{1};
                    bList{ii}{1} = varfList{ii}.inputList{2};
                    break;
                end
            end
            for jj = 1 : length(varfList{ii}.inputList{2}.varList)
                if varList{ii}.name == varfList{ii}.inputList{2}.varList{jj}.name
                    AList{ii}{1} = varfList{ii}.inputList{2};
                    bList{ii}{1} = varfList{ii}.inputList{1};
                    break;
                end
            end
        elseif isa(varfList{ii}, 'SumSquare')
            typeList(ii) = 2;
            AList{ii}{1} = varfList{ii}.inputList{1};
            bList{ii}{1} = [];    
        elseif length(varEqList{ii}) == 1
            typeList(ii) = 1;
            %%%%%
            
            k = varEqList{ii}(1);
            p = varEqPosList{ii}(1);

            if p > 0
                H = alm.eqList{k}.lhs{p};
            else
                H = alm.eqList{k}.rhs{-p};
            end
            
            if isa(H, 'Variable')
                HList{ii} = [];
            else
                HList{ii} = H;
            end

            if p > 0
                sumPrimal{ii} = Sum([alm.eqList{k}.lhs(1:p-1), alm.eqList{k}.lhs(p+1:end), alm.eqList{k}.rhs, varDualList(k)],...
                    [-ones(1,p-1), -ones(1, length(alm.eqList{k}.lhs) - p), ones(1, length(alm.eqList{k}.rhs)), -1]);
            else
                sumPrimal{ii} = Sum([alm.eqList{k}.lhs, alm.eqList{k}.rhs(1:-p-1), alm.eqList{k}.rhs(-p+1:end),varDualList(k)],...
                    [ones(1, length(length(alm.eqList{k}.lhs))), -ones(1, -p-1), -ones(1, length(alm.eqList{k}.rhs)+p), 1]);
            end
            
            %%%%%
        else
            error(' ');
        end
    end
    
    if typeList(ii) == 0 || typeList(ii) == 2
        for jj = 1 : length(varEqList{ii})    
            k = varEqList{ii}(jj);
            p = varEqPosList{ii}(jj);

            if p > 0
                A = alm.eqList{k}.lhs{p};
            else
                A = alm.eqList{k}.rhs{-p};
            end

            AList{ii}{end+1} = A;

            if p > 0
                bList{ii}{end+1} = Sum([alm.eqList{k}.lhs(1:p-1), alm.eqList{k}.lhs(p+1:end), alm.eqList{k}.rhs, varDualList(k)],...
                    [-ones(1,p-1), -ones(1, length(alm.eqList{k}.lhs) - p), ones(1, length(alm.eqList{k}.rhs)), -1]);
            else
                bList{ii}{end+1} = Sum([alm.eqList{k}.lhs, alm.eqList{k}.rhs(1:-p-1), alm.eqList{k}.rhs(-p+1:end),varDualList(k)],...
                    [ones(1, length(length(alm.eqList{k}.lhs))), -ones(1, -p-1), -ones(1, length(alm.eqList{k}.rhs)+p), 1]);
            end
        end
    end
    
end

typeAtAList = zeros(1 ,len);
FList = cell(1, len);
for ii = 1 : len
    if typeList(ii) == 0 || typeList(ii) == 2
        %typeAtA = zeros(1, length(AList{ii}));
        for jj = 1 : length(AList{ii})
            typeAtA{jj} = AList{ii}{jj}.typeAtA;
        end
        typeata = unique(cellfun(@(x)x.type, typeAtA));
        if ismember(typeata, [1,2])
            typeAtAList(ii) = 1;
        elseif ismember(typeata, [1,3])
            typeAtAList(ii) = 2;
            adj = 0;         
            for jj = 1 : length(AList{ii})
                if typeAtA{jj}.type == 3
                    if adj * typeAtA{jj}.F < 0
                        typeList(ii) = typeList(ii) - 3;
                    else
                        adj = adj + typeAtA{jj}.F;
                    end
                end
            end
            dimF = typeAtA{1}.dimF;
            dimN = typeAtA{1}.dimN;
            
            for jj = 2 : length(AList{ii})
                if typeAtA{jj}.type == 3
                    for kk = 1 : length(typeAtA{jj}.dimF)
                        if ~ismember(typeAtA{jj}.dimF(kk), dimF)
                            if isempty(dimN) || ismember(typeAtA{jj}.dimF(kk), dimN)
                                typeList(ii) = typeList(ii) - 3;
                            else
                                dimF = sort([dimF typeAtA{jj}.dimF(kk)]);
                            end
                        end
                    end
                    for kk = 1 : length(dimF)
                        if ~ismember(dimF(kk), typeAtA{jj}.dimF)
                            if isempty(typeAtA{jj}.dimN) || ismember(dimF(kk), typeAtA{jj}.dimN)
                                typeList(ii) = typeList(ii) - 3;
                            end
                        end
                    end
                    dimN = unique([dimN, typeAtA{jj}.dimN]);
                end
            end
            
            if typeList(ii) >= 0
                FList{ii} = FourierTransformation("ALM_F",adj < 0, dimF);
            end
        elseif ismember(typeata, [1,2,4])
            typeAtAList(ii) = 3;
        else
            typeList(ii) = typeList(ii) - 3;
        end
        %if typeList(ii) < 0
        %    
        %end
    end
end

alm.varList = varList;
alm.varfList = varfList;
alm.varEqList = varEqList;
alm.AList = AList;
alm.bList = bList;
alm.typeAtAList = typeAtAList;
alm.FList = FList;
alm.sumPrimal = sumPrimal;
alm.sumDual = sumDual;
alm.HList = HList;
alm.typeList = typeList;
alm.varDualList = varDualList;

fidxList = cell(1, length(alm.fList));
for ii = 1 : len
    if ~isempty(varfList{ii})
        for jj = 1 : length(alm.fList)
            if alm.fList{jj}.id == varfList{ii}.id
                fidxList{jj}(end+1) = ii;
                break
            end
        end
    end
end

alm.fidxList = fidxList;

end


