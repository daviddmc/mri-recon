function param = parseParam_(pg, param)

if ~isfield(param, 'stopCriteria')
    param.stopCriteria = 'PRIMAL_UPDATE';
end

end

