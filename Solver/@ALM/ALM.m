classdef ALM < Solver
    
    properties(Access = private)
        %costf = []
        %costg = []
    end
    
    properties(SetAccess = protected)
        fList
        eqList
        
        varList
        varfList;
        varEqList;
        AList;
        bList;
        typeAtAList;
        FList;
        sumPrimal;
        sumDual;
        HList;
        fidxList;
        costList;
        typeList;
        varDualList
    end
    
    methods
        % constructor
        function alm = ALM(fList, eqList)
            alm = alm@Solver('Augmented Lagrangian Method');
            alm.fList = parseInputList(fList);
            for ii = 1 : length(eqList)
                eqList{ii}.lhs = parseInputList(eqList{ii}.lhs);
                eqList{ii}.rhs = parseInputList(eqList{ii}.rhs);
            end
            alm.eqList = eqList;
        end
    end
       
    methods(Access = protected)
        checkFun(solver);
        parseParam_(solver, param);
        verboseOutput(solver, x);
        val = cost(solver, x);
        x = initalize(solver, x);
        x = finalize(solver, x);
    end

   
end