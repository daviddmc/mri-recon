function Y = upsamplingGrid2D(X)
%UPSAMPLINGGRID2D   Upsampling 2D control points of Bspline
%   upsamplingGrid2D(X) upsamples the Bspline control points so that it is
%   twice denser.

%   This code is modified from Andriy Myronenko's Medical Image 
%   Registration Toolbox (MIRT) for Matlab (version 1.0), 
%   https://sites.google.com/site/myronenko/

%   Copyright 2018 Junshen Xu

[mg, ng, ~, M] = size(X);

x=squeeze(X(:,:,1,:));
y=squeeze(X(:,:,2,:));

xnew=zeros(mg, 2*ng-2, M);
ynew=zeros(mg, 2*ng-2, M);

xfill=(x(:,1:end-1,:)+x(:,2:end,:))/2;
yfill=(y(:,1:end-1,:)+y(:,2:end,:))/2;
for ii=1:ng-1
   xnew(:,2*ii-1:2*ii,:)=cat(2,x(:,ii,:), xfill(:,ii,:)); 
   ynew(:,2*ii-1:2*ii,:)=cat(2,y(:,ii,:), yfill(:,ii,:)); 
end
xnew=xnew(:,2:end,:);
ynew=ynew(:,2:end,:); 

x=xnew; 
y=ynew; 

xnew=zeros(2*mg-2, 2*ng-3, M);
ynew=zeros(2*mg-2, 2*ng-3, M);

xfill=(x(1:end-1,:,:)+x(2:end,:,:))/2;
yfill=(y(1:end-1,:,:)+y(2:end,:,:))/2;

for ii=1:mg-1
   ynew(2*ii-1:2*ii,:,:)=cat(1,y(ii,:,:), yfill(ii,:,:)); 
   xnew(2*ii-1:2*ii,:,:)=cat(1,x(ii,:,:), xfill(ii,:,:)); 
end
xnew=xnew(2:end,:,:);
ynew=ynew(2:end,:,:);

Y=cat(4, xnew, ynew);
Y=permute(Y,[1 2 4 3]);
Y=2*Y-1;

