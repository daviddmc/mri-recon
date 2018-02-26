function node = motion2node2D(motion, coef, spacing, sizeNode)


node = zeros(sizeNode(1), sizeNode(2), 2);

% cycle over all 4x4 patches of B-spline control points
for i = 1:sizeNode(1)-3
    for j = 1:sizeNode(2)-3

        in1=(i-1)*spacing+1:i*spacing;
        in2=(j-1)*spacing+1:j*spacing;
        
        tmp=motion(in1,in2,1);
        node(i:i+3,j:j+3,1)=node(i:i+3,j:j+3,1)+reshape(coef'*tmp(:),[4 4]);

        tmp=motion(in1,in2,2);
        node(i:i+3,j:j+3,2)=node(i:i+3,j:j+3,2)+reshape(coef'*tmp(:),[4 4]);
    
    end
end
