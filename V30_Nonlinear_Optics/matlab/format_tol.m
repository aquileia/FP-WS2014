function [coeff] = format_tol(c, dc)
    %% Format a tolerance interval in physical notation
    n = floor(log10(dc/3));
    dc_r = ceil(dc*10^-n)*10^n;
    c_r = round(c*10^-n)*10^n;
    format = ['%0.' int2str(max(-n,0)) 'f'];
    coeff = [sprintf(format,c_r) ' \pm ' sprintf(format,dc_r) ];
end