function setInput(op, nums, newInput)

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

