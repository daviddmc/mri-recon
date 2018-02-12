function parseParam_(pg, param)

if ~isfield(param, 'stopCriteria')
    pg.param.stopCriteria = 'PRIMAL_UPDATE';
else
    pg.param.stopCriteria = param.stopCriteria;
end

end

