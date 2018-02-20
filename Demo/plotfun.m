function  plotfun( s )
x = reshape(s.var{2}' * s.var{4}, [128,128,24]);
imshow(abs(x(:,:,12)),[]);
end

