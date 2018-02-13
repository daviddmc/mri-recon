classdef ADMM < Solver
    
    properties(Access = private)
        costf = []
        costg = []
    end
    
    properties(SetAccess = protected)
        f
        g
        A
        h
    end
    
    methods
        % constructor
        function fbpd = FBPD(f, g, A, h)
            fbpd = fbpd@Solver('Forward Backward Primal Dual');
            fbpd.f = f;
            fbpd.g = g;
            
            if isempty(A)
                fbpd.param.useA = 0;
                fbpd.A = Identity([]);
            else
                fbpd.param.useA = 1;
                fbpd.A = A;
            end
            
            if isempty(h)
                fbpd.param.isPDHG = 1;
                fbpd.h = ZeroFunction([]);
            else
                fbpd.param.isPDHG = 0;
                fbpd.h = h;
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