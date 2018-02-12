function varargout = gradOp_( fs, preGrad )

for ii = 1 : length(fs.inputList)
    varargout{ii} = fs.inputList{ii}.mu * preGrad;
end

%varargout{1 : length(fs.inputList)} = preGrad;

end

