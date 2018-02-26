classdef ImResize < LinearOperator
    %RESHAPE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        siz
    end
    
    methods
        function ir = ImResize(inputList, siz)
            ir = ir@LinearOperator(inputList, 0);
            ir.siz = siz;
        end
        
        function set.siz(op, s)
            op.siz = s;
            if isfield(op.props, 'isConstant') && op.props.isConstant
                op.props.isConstant = [];
                op.broadcast({'isConstant'}, 0);
            end
        end
        
        
    end
    
    methods(Access = protected)
        y = apply_(ir, x, isCache)
    end
    
end

