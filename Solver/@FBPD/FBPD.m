classdef FBPD < Solver
% Reference:
% [1]Combettes, P. L., Condat, L., Pesquet, J. C., & V?, B. C. (2014). A 
% forward-backward view of some primal-dual optimization methods in image 
% recovery. IEEE International Conference on Image Processing 
% (pp.4141-4145). IEEE.
% [2]Goldstein, T., Li, M., Yuan, X., Esser, E., & Baraniuk, R. (2015). 
% Adaptive primal-dual hybrid gradient methods for saddle-point problems.
    
    properties(Access = private)
        costf = []
        costg = []
        costh = []
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