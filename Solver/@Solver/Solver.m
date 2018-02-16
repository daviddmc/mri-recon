classdef Solver < matlab.mixin.Copyable
    %Solver Superclass of optimization solvers
    
    properties(SetAccess = protected)
        %name name of the solver
        name
        %param parameters for solver
        param
    end
    
    properties(GetAccess = protected, SetAccess = private)
        % name of the solver
        saveInfo % name of the solver
        % name of the solver
    end
    
    methods
        function solver = Solver(name)
            % For now it only assign the name of the solver.
            solver.name = name;
        end
        
        [x, info] = run(op, x0, param)
    end
    
    methods(Access = private)     
        parseParam(solver, param);
    end
    
    methods(Access = protected)
        [isStop, info] = testConvergence(solver, x);
        [isStop, convergenceInfo] = testConvergenceResidual( solver, state )
    end
    
    methods(Access = protected, Abstract)
        verboseOutput(solver, x);
        checkFun(solver);
        parseParam_(solver, param);
        x = initalize(solver, x);
        x = finalize(solver, x);
        val = cost(solver, x);
    end
    

end