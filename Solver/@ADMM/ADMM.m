classdef ADMM < Solver
    
    properties(Access = private)
        costf = []
        costg = []
    end
    
    properties(SetAccess = protected)
        f
        B
        g
    end
    
    methods
        % constructor
        function admm = ADMM(f, B, g)
            admm = admm@Solver('Alternating Direction Method of Multipliers');
            admm.f = f;
            admm.g = g;
            
            if isempty(B)
                admm.param.useB = 0;
               % admm.B = Identity([]);
            else
                admm.param.useB = 1;
                admm.B = B;
            end
            
        end
    end
       
    methods(Access = protected)
        checkFun(solver);
        parseParam_(solver, param);
        verboseOutput(solver, x);
        val = cost(solver, x);
        x= initalize(solver, x);
        x = finalize(solver, x);
        [isStop, convergenceInfo] = testConvergenceResidual( solver, state )
    end

   
end