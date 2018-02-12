function y = pinv_( rs, x )

rs.isAdjoint = ~rs.isAdjoint;
y = rs.apply_(x);
rs.isAdjoint = ~rs.isAdjoint;

end

