classdef PG < Solver
    
    properties(Access = private)
        costf = []
        costg = []
    end
    
    properties(SetAccess = protected)
        f
        g
    end
    
    methods
        % constructor
        function pg = PG(f, g, param)
            if nargin < 3
                param = [];
            end
            pg = pg@Solver('Proximal Gradient', {f, g} ,param);
        end
    end
       
    methods(Access = protected)
        checkFun(solver);
        param = parseParam_(solver, param);
        verboseOutput(solver, x);
        val = cost(solver, x);
        x= initalize(solver, x);
        x = finalize(solver, x);
        function [propChanged, isStructChanged] = receive(solver, pos, propChanged, isStructChanged)
            solver.isFunReady = 0;
            if isempty(pos) || pos == 1
                solver.isParamReady = 0;
            end
        end
    end

   
end