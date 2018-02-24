function state = finalize( alm, state )

for ii = 1 : length(alm.varList)
    alm.varList{ii}.setInput();
end

alm.isRunning = false;

end

