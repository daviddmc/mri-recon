classdef ALM < Solver
    
    properties(Access = private)
        isRunning = false
    end
    
    properties(SetAccess = protected)
        fList
        eqList
        
        varList
        %varfList;
        %varEqList;
        %AList;
        %bList;
        %typeAtAList;
        %FList;
        %sumPrimal;
        sumDual;
        %HList;
        fidxList;
        costList;
        %typeList;
        varDualList
        subProblem
    end
    
    methods
        % constructor
        function alm = ALM(fList, eqList, param)
            
            %
            for ii = 1 : length(eqList)
                eqList{ii}.lhs = parseInputList(eqList{ii}.lhs);
                eqList{ii}.rhs = parseInputList(eqList{ii}.rhs);
            end
            
            inList = fList;
            for ii = 1 : length(eqList)
                inList = [inList eqList{ii}.lhs eqList{ii}.rhs];
            end
            
            alm = alm@Solver('Augmented Lagrangian Method', ...
                inList, param);
            alm.fList = parseInputList(fList);
            alm.eqList = eqList;
        end
    end
       
    methods(Access = protected)
        checkFun(solver);
        param = parseParam_(solver, param);
        verboseOutput(solver, x);
        val = cost(solver, x);
        x = initalize(solver, x);
        x = finalize(solver, x);
        function [propChanged, isStructChanged] = receive(solver, pos, propChanged, isStructChanged)
            if ~solver.isRunning
                solver.isFunReady = 0;
                solver.isParamReady = 0;
            end
        end
    end

   
end