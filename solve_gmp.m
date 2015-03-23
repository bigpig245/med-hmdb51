function w = solve_gmp(lambda, x, calpha, sigma, kernel)

if (strcmp(kernel,'gaussian'))
    x      = x';
    [D,~]  = size(x);
    diffsq = sum((repmat(x,[1,1,N]) - repmat(permute(x,[1,3,2]),[1,N,1])).^2,1);
    diffsq = permute(diffsq,[2,3,1]);
    k      = gauss_norm(sigma,D,1)*exp(-0.5*(diffsq)/(sigma^2));
    
    nse = lambda*eye(N);
    e   = ones(N,1);
    b   = (k*e).^calpha;
elseif (strcmp(kernel,'linear'))
    [N,~] = size(x);
    k     = x*x';
    
    nse = lambda*eye(N);
    e   = ones(N,1);
    b   = (k*e).^calpha;
elseif (strcmp(kernel,'absLinear'))
    [N,~] = size(x);
    k     = x*x';
    
    nse = lambda*eye(N);
    e   = ones(N,1);
    b   = abs((k*e)).^calpha;
elseif (strcmp(kernel,'sgnAbsLinear'))
    [N,~] = size(x);
    k     = x*x';
    
    nse = lambda*eye(N);
    e   = ones(N,1);
    b   = sign(k*e).*abs((k*e)).^calpha;
end

% solve gmp:
w = (k + nse)\b;
w = w';%/sum(w);
end

