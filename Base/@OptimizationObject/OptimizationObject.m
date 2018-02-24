classdef OptimizationObject < handle
    %OPTIMIZATIONOBJECT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties(SetAccess = protected)
        inList = {};
        outList = {};
        outpos = [];
        inpos = [];
        id
    end
    
    methods
        function obj = OptimizationObject(inList)
            persistent id;
            if isempty(id)
                id = 1;
            else
                id = id + 1;
            end
            obj.id = id;
            obj.inList = parseInputList(inList);
            for ii = 1 : length(obj.inList)
                obj.inList{ii}.outList{end + 1} = obj;
                obj.inList{ii}.outpos(end + 1) = ii;
                obj.inpos(ii) = length(obj.inList{ii}.outList);
            end
            obj.receive([], {}, 1);
        end
        
        setInput(op, num, newInput)
        
        function isEq = eq(obj1, obj2)
            isEq = obj1.id == obj2.id;
        end
    end
    
    methods(Access = protected)
        function broadcast(obj, propChanged, isStructChanged)
            for ii = 1 : length(obj.outList)
                [propChanged, isStructChanged] = obj.outList{ii}.receive(obj.outpos(ii), propChanged, isStructChanged);
                obj.outList{ii}.broadcast(propChanged, isStructChanged);
            end
        end
        
        function [propChanged, isStructChanged] = receive(obj, pos, propChanged, isStructChanged)
        end
        
    end
    
end

