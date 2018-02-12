function Y = upsamplingGrid(X, M)

[mg, ng,~] = size(X);

x=squeeze(X(:,:,1,:));
y=squeeze(X(:,:,2,:));

xnew=zeros(mg, 2*ng-2, M);
ynew=zeros(mg, 2*ng-2, M);

xfill=(x(:,1:end-1,:)+x(:,2:end,:))/2;
yfill=(y(:,1:end-1,:)+y(:,2:end,:))/2;
for i=1:ng-1
   xnew(:,2*i-1:2*i,:)=cat(2,x(:,i,:), xfill(:,i,:)); 
   ynew(:,2*i-1:2*i,:)=cat(2,y(:,i,:), yfill(:,i,:)); 
end
xnew=xnew(:,2:end,:);
ynew=ynew(:,2:end,:); 


x=xnew; 
y=ynew; 

xnew=zeros(2*mg-2, 2*ng-3, M);
ynew=zeros(2*mg-2, 2*ng-3, M);

xfill=(x(1:end-1,:,:)+x(2:end,:,:))/2;
yfill=(y(1:end-1,:,:)+y(2:end,:,:))/2;

for i=1:mg-1
   ynew(2*i-1:2*i,:,:)=cat(1,y(i,:,:), yfill(i,:,:)); 
   xnew(2*i-1:2*i,:,:)=cat(1,x(i,:,:), xfill(i,:,:)); 
end
xnew=xnew(2:end,:,:);
ynew=ynew(2:end,:,:);

Y=cat(4, xnew, ynew);
Y=permute(Y,[1 2 4 3]);
Y=2*Y-1;

