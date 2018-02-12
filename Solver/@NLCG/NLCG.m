classdef NLCG < Solver
    
    properties(SetAccess = protected)
        f
    end
    
    methods
        % constructor
        function nlcg = NLCG(fList)
            nlcg = nlcg@Solver('Non-Linear Conjugate Gradient');
            if iscell(fList) || isa(fList, 'Function')
                f = FunctionSum(fList);
            elseif isa(fList, 'FunctionSum')
                f = fList;
            else
                error(' ');
            end
            
            nlcg.f = f;

        end
    end
       
    methods(Access = protected)
        checkFun(solver);
        parseParam_(solver, param);
        verboseOutput(solver, x);
        val = cost(solver, x);
        x= initalize(solver, x);
        x = finalize(solver, x);
    end

   
end