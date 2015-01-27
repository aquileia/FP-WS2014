function [coeff] = format_tol(c, dc)
    %% Format a tolerance interval in physical notation
    n = floor(log10(dc/3));
    dc_r = ceil(dc*10^-n)*10^n;
    % c_r = round(dc*10^-n)*10^n;
    format = ['%0.' num2str(-n) 'f'];
    coeff = [sprintf(format,c) ' \pm ' sprintf(format,dc_r) ];
end