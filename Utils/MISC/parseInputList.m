function inputList = parseInputList( inputList )

if ~iscell(inputList)
    inputList = {inputList};
end

for ii = 1 : length(inputList)
    if ~isa(inputList{ii}, 'Operator')
        if isnumeric(inputList{ii}) || ischar(inputList{ii}) || isstring(inputList{ii})
            inputList{ii} = Variable.getVariable(inputList{ii});
        else
            error(' ');
        end
    end
end


end

