classdef NLCG < Solver
    
    properties(SetAccess = protected)
        f
    end
    
    methods
        % constructor
        function nlcg = NLCG(fList, param)
            
            if iscell(fList) || isa(fList, 'Function')
                f = FunctionSum(fList);
            elseif isa(fList, 'FunctionSum')
                f = fList;
            else
                error(' ');
            end
            
            nlcg = nlcg@Solver('Non-Linear Conjugate Gradient', f, param);
            
            %nlcg.f = f;

        end
    end
       
    methods(Access = protected)
        checkFun(solver);
        param = parseParam_(solver, param);
        verboseOutput(solver, x);
        val = cost(solver, x);
        x= initalize(solver, x);
        x = finalize(solver, x);
    end

   
end