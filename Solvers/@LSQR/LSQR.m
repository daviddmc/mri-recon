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
        function lq = LSQR(AList, bList, lambdas, param)
            lq = lq@Solver('Least Squares QR', [AList bList], param);
            %lq.bList = bList;
            lq.setLambda(lambdas);
        end
        
        function setLambda(lq, lambdas)
            lq.lambdas = lambdas;
            if any(lq.lambdas < 0)
                error('Lambdas must be positive numbers');
            end
        end
    end
    
    methods(Access = protected)
        checkFun(solver);
        param = parseParam_(solver, param);
        verboseOutput(solver, x);
        val = cost(solver, x);
        x= initalize(solver, x);
        x = finalize(solver, x);
        [isStop, convergenceInfo] = testConvergenceResidual( solver, state )
        function [propChanged, isStructChanged] = receive(solver, pos, propChanged, isStructChanged)
            solver.isFunReady = 0;
        end
    end

   
end



    