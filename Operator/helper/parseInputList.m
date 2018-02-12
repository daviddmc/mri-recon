function inputList = parseInputList( inputList )

if ~iscell(inputList)
    inputList = {inputList};
end

for ii = 1 : length(inputList)
    if ~isa(inputList{ii}, 'Operator')
        inputList{ii} = Variable.getVariable(inputList{ii});
    end
end


end

