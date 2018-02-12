classdef POCS < Solver
    
    properties(Access = private)
    end
    
    properties(SetAccess = protected)
        fList
    end
    
    methods
        % constructor
        function pocs = POCS(fList)
            pocs = pocs@Solver('projections onto convex sets');
            pocs.fList = fList;
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