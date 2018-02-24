classdef POCS < Solver
    
    properties(SetAccess = protected)
        %fList
        costList
    end
    
    methods
        % constructor
        function pocs = POCS(fList, param)
            pocs = pocs@Solver('projections onto convex sets', fList, param);
            %pocs.fList = fList;
        end
    end
       
    methods(Access = protected)
        checkFun(solver);
        param = parseParam_(solver, param);
        verboseOutput(solver, x);
        val = cost(solver, x);
        x = initalize(solver, x);
        x = finalize(solver, x);
    end

   
end