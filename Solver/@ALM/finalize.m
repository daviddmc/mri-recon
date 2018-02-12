function state = finalize( alm, state )

for ii = 1 : length(alm.varList)
    alm.varList{ii}.setVar();
end

end

