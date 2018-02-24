function param = parseParam_(nlcg, param)

defaultParam = struct('alpha', 0.01,...
                      'beta', 0.5,...
                      't0', 1,...
                      'maxIterLS', 100,...
                      'method', 'FR');
param = setDefaultField(defaultParam, param);

if ~ismember(param.method, {'FR', 'PR', 'HS', 'DY'})
    error(' ');
end

end

