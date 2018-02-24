function coef = BsplineCoef(spacing, is3D)

B=[-1 3 -3 1;
3 -6 3 0;
-3 0 3 0;
1 4 1 0]/6;
u=linspace(0,1,spacing+1)';
u=u(1:end-1);
T=[u.^3 u.^2 u ones(spacing,1)];
B=T*B;

if is3D
    coef = kron(B, kron(B,B));
else
    coef = kron(B,B);
end

  
  