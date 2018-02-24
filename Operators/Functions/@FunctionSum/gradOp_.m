function varargout = gradOp_( fs, preGrad )

for ii = 1 : fs.numInput
    varargout{ii} = fs.inList{ii}.mu * preGrad;
end

end

