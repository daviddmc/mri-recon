function setInput(op, num, newInput)

newInput = parseInputList(newInput);
newInput = newInput{1};

if num > op.numInput
    error([class(op) 'has only ' num2str(op.numInput) ' input(s).']);
end

isStructChanged = newInput ~= op.inList{num};
if isStructChanged

    op.inList{num}.outList(op.inpos(num)) = [];
    op.inList{num}.outpos(op.inpos(num)) = [];
    op.inList{num} = newInput;
    op.inList{num}.outList{end+1} = op;
    op.inList{num}.outpos(end + 1) = num;
    op.inpos(num) = length(op.inList{num}.outList);

end

[propChanged, isStructChanged] = op.receive(num, {}, isStructChanged);
op.broadcast(propChanged, isStructChanged);


%{
newInput = parseInputList(newInput);
newInput = newInput{1};

if ~nums || isempty(nums)
    nums = [];
    for ii = 1 : length(op.inputList)
        if op.inputList{ii}.id == newInput.id
            nums(end+1) = ii;
        end
    end
end

for num = nums
    
    for ii = 1 : length(op.inputList{num}.outputList)
        if op.inputList{num}.outputList{ii}.id == op.id
            op.inputList{num}.outputList(ii) = [];
            break;
        end
    end

    op.inputList{num} = newInput;
    
    op.updateInput();

    op.inputList{num}.outputList{end+1} = op;

    for ii = 1 : length(op.outputList)
        op.outputList{ii}.setInput(0, op);
    end
    
end
%}
