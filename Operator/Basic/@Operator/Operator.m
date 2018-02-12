classdef Operator < matlab.mixin.Copyable
    
    properties(SetAccess = protected)
        cache = []
        
        isGrad_ = 0
        L_ = 0
        isLinear_ = 0
        isConstant = 0
        props = []
        
        topoSort
        refList = {[]}
        varList = {}
        clearIdx = {[]}
        inputList = {}
        outputList = {}
        isPreConstant = 0
        id
    end
    
    methods
        % constructor
        function op = Operator(inputList)
            persistent id;
            if isempty(id)
                id = 1;
            else
                id = id + 1;
            end
            op.id = id;
            
            inputList = parseInputList(inputList);
            op.inputList = inputList;
            
            if ~isempty(inputList)
                op.setConstant();
                op.setTopoList();
                for ii = 1 : length(inputList)
                    inputList{ii}.outputList{end+1} = op;
                end
            else
                op.topoSort = {op};
            end
        end
        
        y = apply(op, varargin)
        g = gradOp(op, y, varargin);
        setInput(op, num, newInput)
        
        p = L(op)
        p = isLinear(op)
        p = isGrad(op)
        
    end
    
    methods(Access = private)
        updateInput(op)
        setTopoList(op)
        setConstant(op)
    end
    
    methods(Access = protected)
        preConstant(op)
        updateConstant(op, flag)
    end
    
    methods(Access = protected, Abstract)
        y = apply_(op, varargin)
        g = gradOp_(op, preGrad)
        updateProp(op)
    end
    

end