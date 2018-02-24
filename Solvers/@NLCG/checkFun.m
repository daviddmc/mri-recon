function checkFun(nlcg)

nlcg.f = nlcg.inList{1};

if ~nlcg.f.isGrad
    error(' ');
end

end

