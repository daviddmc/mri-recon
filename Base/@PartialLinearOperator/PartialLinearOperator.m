classdef PartialLinearOperator < Operator
    
    
    methods
        % constructor
        function linOp = PartialLinearOperator(inputList, numInput)
            linOp = linOp@Operator(inputList, numInput);
        end          
    end
    
    methods(Sealed)
        y = adjoint(op, x)
        y = pinv(op, x)
        p = isPinv(op)
        u = unitary(op)
        s = shape(op)
        t = typeAtA(op, t);
        a = AtA(op);
    end
    
    methods(Access = protected)
        t = typeAtA_(op, t)
        a = AtA_(op, a);
        function y = pinv_(op, x)
            u = op.unitary_;
            if u
                if u == 1
                    y = op.gradOp_(x);
                else
                    y = op.gradOp_(x) / u;
                end
            else
                error('not implemented');
            end
        end
        function p = unitary_(op)
            p = 0;
        end
        function p = isPinv_(op)
            p = logical(op.unitary_);
        end
        function p = shape_(op)
            p = 0;
        end
        function p = L_(op)
            p = op.unitary_;
        end
        function p = isGrad_(op)
            p = 1;
        end
        
        function [propChanged, isStructChanged] = receive(op, pos, propChanged, isStructChanged)
            
            if isStructChanged
                for ii = 1 : op.numInput
                    if isa(op.inList{ii}, 'Functional')
                        error(' ');
                    end
                end
            end
            
            [propChanged, isStructChanged] = receive@Operator(op, pos, propChanged, isStructChanged);
        end
        
    end

end