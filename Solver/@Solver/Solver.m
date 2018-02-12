classdef Solver < matlab.mixin.Copyable
    
    properties(SetAccess = protected)
        name
        param
    end
    
    properties(GetAccess = protected, SetAccess = private)
        saveInfo
    end
    
    methods
        % constructor
        function solver = Solver(name)
            solver.name = name;
        end
        
        [x, info] = run(op, x0, param)
        
    end
    
    methods(Access = private)     
        parseParam(solver, param);
    end
    
    methods(Access = protected)
        [isStop, info] = testConvergence(solver, x);
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