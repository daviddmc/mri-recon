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
        function pg = PG(f, g)
            pg = pg@Solver('Proximal Gradient');
            pg.f = f;
            pg.g = g;
        end
    end
       
    methods(Access = protected)
        checkFun(solver);
        parseParam_(solver, param);
        verboseOutput(solver, x);
        val = cost(solver, x);
        x= initalize(solver, x);
        x = finalize(solver, x);
    end

   
end