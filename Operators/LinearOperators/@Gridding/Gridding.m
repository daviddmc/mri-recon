classdef Gridding < LinearOperator
    
    properties(SetAccess = protected)
        k_traj
        im_size
        A
        %mask = []
        %idx = []
        %sizeMask = []
        %isReduced = 0;
    end
    
    methods
        function m = Gridding(inputList, isAdjoint, im_size, k_traj)
            m = m@LinearOperator(inputList, isAdjoint);
            m.k_traj = k_traj;
            m.im_size = im_size;
            assert(length(im_size) == size(k_traj, 2));
            m.A = m.create_gridding();
            %m.isReduced = isReduced;
            %if isReduced
            %    m.idx = find(mask);
            %    m.sizeMask = size(mask);
            %else
            %    m.mask = mask;
            %end
        end
    end
    
    methods(Access = protected)
        y = apply_(m, x, isCahce);
        a = AtA_(op, a);
        t = typeAtA_(op, t);
        %{
        function p = unitary_(m)
            p = 1;
        end
        function p = shapeNotAdjoint(m)
            p = 1;
        end
        %}
        A = create_gridding(m);
    end
    
end