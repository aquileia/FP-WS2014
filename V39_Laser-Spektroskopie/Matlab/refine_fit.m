function [new_fit] = refine_fit(old_fit)
    global gof spec x y
    ind = abs (y - feval(old_fit,x)) > gof.rmse;
    spec = excludedata(x,y,'indices',ind);
    [new_fit, gof] = fit(x,y,'poly2','Robust','on','Exclude',spec);
end