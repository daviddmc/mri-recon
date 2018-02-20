function y = apply_(E,x, ~)
% This method applies the ESPIRiT Eigen-Vecs operator

maps = E.eigenVecs;

[sx,sy,nc,nv] = size(maps);

if E.isAdjoint    
   %res = sum(conj(maps).*repmat(x,[1,1,1,nv]),3);    
    y = zeros(sx,sy,nv);
    for n=1:nv
        y(:,:,n) = sum(conj(maps(:,:,:,n)).*x,3);
    end
else
   %res = sum(maps.*repmat(x,[1,1,nc,1]),4);   
   y = zeros(sx,sy,nc);
   for n=1:nc
       y(:,:,n) =  sum(squeeze(maps(:,:,n,:)).*x,3);
   end
       
end

