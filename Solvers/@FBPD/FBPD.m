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
        function fbpd = FBPD(f, g, A, h, param)
            
            if isempty(A)
                A = Identity([]);
            end
            if isempty(h)
                h = ZeroFunction([]);
            end
            
            fbpd = fbpd@Solver('Forward Backward Primal Dual',...
                {f, g, A, h},param);
            
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
    end

   
end