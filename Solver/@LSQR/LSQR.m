classdef LSQR < Solver
    
    properties(Access = private)
    end
    
    properties(SetAccess = protected)
        AList
        bList
        lambdas
    end
    
    methods
        % constructor
        function lq = LSQR(AList, bList, lambdas)
            lq = lq@Solver('Least Squares QR');
            lq.AList = AList;
            lq.bList = bList;
            lq.lambdas = lambdas;
        end
        
        function setb(lq, bList)
            lq.bList = bList;
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



    