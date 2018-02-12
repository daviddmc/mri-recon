function y = pinv_( sm, x )

sm.isAdjoint = ~sm.isAdjoint;
y = sm.apply_(x);
sm.isAdjoint = ~sm.isAdjoint;

end

