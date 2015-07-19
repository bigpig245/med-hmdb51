function gmp_demo()

close all;
phi1 = [-0.5  sqrt(0.75)];
phi2 = [-0.5 -sqrt(0.75)];
phi3 = [1 0];

rep1 = 1;
rep2 = 1;
rep3 = 8;

% features:
x  = [repmat(phi1,rep1,1); repmat(phi3,rep3,1)];
x  = x + 0.2 * (rand(size(x)) - 0.5);
x2 = [repmat(phi2,rep2,1); repmat(phi3,rep3,1)];
x2 = x2 + 0.2 * (rand(size(x2)) - 0.5);


% make features unit vectors:
x  = x./repmat(sqrt(sum(x.^2,2)),1,2);
x2 = x2./repmat(sqrt(sum(x2.^2,2)),1,2);

% more params
kernel = {'gaussian','linear','absLinear','sgnAbsLinear'};

for kernel = {'linear'};
    for sigma = 1
        for alpha = [0.0]
            for lambda = [1e-4 1e3]
                plot_gmp(lambda, x, x2, alpha, sigma, rep1, rep2, rep3, kernel{1});
            end
        end
    end
end

end

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
w = w'/sum(w);
end

function k = solve_k(lambda, x, calpha, sigma, kernel)

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

end

function Gnorm = gauss_norm(sigma,k,alpha)
% denominator of normalizing constant:
Gnorm = (1/((sqrt((sigma^2)^k))*((2*pi/alpha)^(k/2))));
end

function w = plot_gmp(lambda, x, x2, calpha, sigma, rep1, rep2, rep3, kernel)
x = [1 1 0 0 0 0 0; 0 0 0 0 2 2 2; 3 3 0 0 0 0 0; 4 4 0 0 0 0 0; 0 0 5 5 0 0 0; 0 0 0 0 6 6 6; 7 7 0 0 0 0 0; 0 0 8 8 0 0 0; 0 0 0 0 9 9 9];

x2_1 = [x(1, :); x(3, :); x(4,:); x(7,:)];
x2_2 = [x(2, :); x(6, :); x(9, :)];
x2_3 = [x(5, :); x(8, :)];

lambda = 1;
N = size(x, 1);
nse = lambda*eye(N);
b   = ones(N,1);
x2 = [x2_1;x2_2;x2_3];

% solve gmp:
k = solve_k(lambda, x, calpha, sigma, kernel);
w = (k + nse)\b;
w = w'/sum(w);


% weight vectors:
wx = x'*w';
%wx = wx/sqrt(wx'*wx);

% solve gmp:
k2_1 = solve_k(lambda, x2_1, calpha, sigma, kernel);
k2_2 = solve_k(lambda, x2_2, calpha, sigma, kernel);
k2_3 = solve_k(lambda, x2_3, calpha, sigma, kernel);
k2 = blkdiag(k2_1, k2_2, k2_3);

w2 = (k2 + nse)\b;
w2 = w2'/sum(w2);

% weight vectors:
w2x = x2'*w2';
%w2x = w2x/sqrt(w2x'*w2x);

% plot:
figure;
fontsz = 12;
pts    = [x(1:rep1,:); x2(1:rep2,:)];
h      = compass(pts(:,1),pts(:,2)); hold all;
% arrow colours:
clr = [repmat([1.0 0.0 0.0],rep1,1);...
       repmat([0.0 0.0 1.0],rep2,1)];
set(h, {'Color'},num2cell(clr,2), 'LineWidth',3);

pts = x2((rep1+1):end,:);
h   = compass(pts(:,1),pts(:,2));
% arrow colours:
clr = repmat([0.0 0.7 0.0],rep3,1);
set(h, {'Color'},num2cell(clr,2), 'LineWidth',3);

h = compass(wx(1,:),wx(2,:),'--');
% arrow colours:
clr = [1.0 0.0 0.0];
set(h, {'Color'},num2cell(clr,2), 'LineWidth',3);

h = compass(w2x(1,:),w2x(2,:),'--');
% arrow colours:
clr = [0.0 0.0 1.0];
set(h, {'Color'},num2cell(clr,2), 'LineWidth',3);

hold off;
set(gca,'FontSize',fontsz);

% Removing the radial labels:
set(findall(gca, 'String', '  0.2', '-or','String','  0.4', '-or','String','  0.6', '-or','String','  0.8', '-or','String','  1') ,'String', ' ');
title(sprintf('lambda = %4.2e',lambda));
end
