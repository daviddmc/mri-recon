function motion = node2motion2D(node, coef, spacing)

[mg, ng, ~]=size(node);
motion = zeros(spacing*(mg-3), spacing*(ng-3), 2);

for i = 1 : mg-3
    for j = 1 : ng-3
        
        in1=(i-1)*spacing+1:i*spacing;
        in2=(j-1)*spacing+1:j*spacing;
   
        tmp=node(i:i+3,j:j+3,1);
        motion(in1,in2,1) = reshape(coef*tmp(:),[spacing spacing]);

        tmp=node(i:i+3,j:j+3,2);
        motion(in1,in2,2) = reshape(coef*tmp(:),[spacing spacing]);
    end
end
