function [para, fval] = optWrapper(init, target, response, varargin)
%OPTWRAPPER Wrapper function for running the fitting procedure.

p = inputParser;
p.addParameter('Optimizer', 'fminsearch', @(x) isa(x, 'char'));
p.addParameter('Display', 'iter', @(x) isa(x, 'char'))
parse(p, varargin{:});

optFunc = p.Results.Optimizer;
display = p.Results.Display;

lb = [0, 0.1];
ub = [2, 100];

objFunc = @(para) dataLlhd(para(1), para(2), target, response);

if (strcmp(optFunc, 'fminsearch'))
    opts = optimset('fminsearch');
    opts.Display = display;
    opts.TolX = 1e-2;
    opts.TolFun = 1e-2;
    
    [para, fval] = fminsearchbnd(objFunc, init, lb, ub, opts);
    
elseif (strcmp(optFunc, 'bads'))
    opts = bads('defaults');
    opts.Display = display;
    plb = [0.6, 0.1];
    pub = [1.9, 20];
    [para, fval] = bads(objFunc, init, lb, ub, plb, pub, [], opts);
    
elseif (strcmp(optFunc, 'fmincon'))
    opts = optimoptions('fmincon');
    opts.Display = display;
    opts.TolX = 1e-4;
    opts.TolFun = 1e-4;
    
    [para, fval] = fmincon(objFunc, init, [], [], [], [], lb, ub, [], opts);
    
else
    error('Invalid optimization option.');
end

end