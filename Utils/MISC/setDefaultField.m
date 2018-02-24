function param = setDefaultField(defaultParam, param)
%SETDEFAULTFIELD   Set default field of a structure
%   setDefaultField(DPARAM, PARAM) set field in PARAM with default value in
%   DPARAM

%   Copyright 2018 Junshen Xu

fnames = fieldnames(defaultParam);
for ii = 1 : length(fnames)
    if ~isfield(param, fnames{ii})
        param.(fnames{ii}) = defaultParam.(fnames{ii});
    end
end

end

