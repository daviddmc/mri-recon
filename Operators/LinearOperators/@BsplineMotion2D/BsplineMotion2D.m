classdef BsplineMotion2D < LinearOperator
     
    properties(SetAccess = protected)
        coef
    end
    
    properties
        sizeNode
        spacing
    end
    
    methods
        function bm = BsplineMotion2D(inputList, isAdjoint, spacing, sizeNode)
            coef = BsplineCoef(spacing, 0);
            bm = bm@LinearOperator(inputList, isAdjoint);
            bm.coef = coef;
            bm.sizeNode = sizeNode;
            bm.spacing = spacing;
        end
        
        function set.sizeNode(op, siz)
            op.sizeNode = siz;
            if isfield(op.props, 'isConstant') && op.props.isConstant
                op.props.isConstant = [];
                op.broadcast({'isConstant'}, 0);
            end
        end
        
        function set.spacing(op, s)
            op.spacing = s;
            if isfield(op.props, 'isConstant') && op.props.isConstant
                op.props.isConstant = [];
                op.broadcast({'isConstant'}, 0);
            end
        end
    end
    
    methods(Access = protected)
        y = apply_(bm, x, isCache);
    end
        
end