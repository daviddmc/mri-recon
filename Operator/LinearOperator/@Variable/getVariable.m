function var = getVariable(v)
    persistent vars

    if isempty(v) || ischar(v) || isstring(v)
        if isempty(v)
            v = "1";
        else
            v = string(v);
        end

        for ii = 1 : length(vars)
            if vars{ii}.name == v
                var = vars{ii};
                return
            end
        end

        var = Variable(v);
        vars{end+1} = var;
    else
        var = Variable(v);
    end
end