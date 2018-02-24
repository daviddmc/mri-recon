classdef Operator < OptimizationObject%matlab.mixin.Copyable
    
    properties(Access = protected)
        topoSort
        refList = {[]}
        varList = {}
        clearIdx = {[]}
    end
    
    properties(SetAccess = protected)
        cache = []
        props = []
        numInput = 0;
    end
    
    methods
        % constructor
        function op = Operator(inList, numInput)
            op = op@OptimizationObject(inList);
            op.numInput = numInput;
        end
        
        y = apply(op, varargin)
        g = gradOp(op, y, varargin);
        
        function varList = getVarList(op)
            [~,~,varList,~] = op.getTopoList();
        end
    end
    
    methods(Sealed)
        p = L(op)
        p = isLinear(op)
        p = isGrad(op)
        p = isConstant(op)
    end
    
    methods(Access = protected)
        [topoSort, refList, varList, clearIdx] = getTopoList(op)
        
    end
    
    methods(Access = protected)
        
        function p = isGrad_(op)
            p = 0;
        end
        function p = L_(op)
            p = 0;
        end
        function p = isLinear_(op)
            p = 0;
        end
        function [propChanged, isStructChanged] = receive(op, pos, propChanged, isStructChanged)
            if isStructChanged
                op.topoSort = {};
                op.props = [];
            else
                for ii = 1 : length(propChanged)
                    if isfield(op.props, propChanged{ii})
                        op.props.(propChanged{ii}) = [];
                    end
                end
                
                %op.props = rmfield(op.props, propChanged(isfield(op.props, propChanged)));
            end
        end
    end
    
    methods(Access = protected, Abstract)
        y = apply_(op, varargin)
        g = gradOp_(op, preGrad)
    end
    

end