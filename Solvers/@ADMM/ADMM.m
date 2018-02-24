classdef ADMM < Solver
    
% Reference:
% [1]Xu, Z., Figueiredo, M. A. T., Yuan, X., Studer, C., & Goldstein, T. 
% (2017). Adaptive Relaxed ADMM: Convergence Theory and Practical 
% Implementation. IEEE Conference on Computer Vision and Pattern 
% Recognition (pp.7234-7243). IEEE Computer Society.

    
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
        function admm = ADMM(f, B, g, param)
            
            if isempty(B)
                B = Identity([]);
            end
            
            admm = admm@Solver('Alternating Direction Method of Multipliers', ...
                {f, B, g}, param);
            
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