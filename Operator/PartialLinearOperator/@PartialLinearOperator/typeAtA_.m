function t = typeAtA_( op, t)

% 0 : no AtA
% 1 : const
% 2 : diagonal
% 3 : F
% 4 : MtM

if nargin > 1
    if t.type ~= 1 || ~op.unitary || op.shape > 0
        t.type = 0;
    end
else
    t.type = op.unitary && op.shape <= 0;
end

