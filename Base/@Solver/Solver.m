classdef Solver < OptimizationObject
    %Solver Superclass of optimization solvers
    
    properties(SetAccess = protected)
        name
    end
    
    properties(Access = protected)
        param
        paramUser
        isFunReady = 0;
        isParamReady = 0;
    end
    
    methods
        function solver = Solver(name, inList, param)
            solver = solver@OptimizationObject(inList);
            solver.name = name;
            solver.paramUser = param;
        end
        
        [x, info] = run(op, x0)
        function setParam(solver, param)
            solver.paramUser = param;
            solver.isParamReady = 0;
        end
    end
    
    methods(Access = private)     
        parseParam(solver);
    end
    
    methods(Access = protected)
        [isStop, info] = testConvergence(solver, x);
        function [isStop, convergenceInfo] = testConvergenceResidual( solver, state )
            error('not implemented');
        end
        function [propChanged, isStructChanged] = receive(solver, pos, propChanged, isStructChanged)
            solver.isFunReady = 0;
            solver.isParamReady = 0;
        end
    end
    
    methods(Access = protected, Abstract)
        verboseOutput(solver, x);
        checkFun(solver);
        param = parseParam_(solver, param);
        x = initalize(solver, x);
        x = finalize(solver, x);
        val = cost(solver, x);
    end
    

end