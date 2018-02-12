function y = adjoint(linOp, x)

%if linOp.isLinear
%    
%else
%    error(' ');
%end
y = linOp.gradOp(x);

end