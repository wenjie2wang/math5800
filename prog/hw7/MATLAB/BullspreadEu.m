function [C0,D0] = BullspreadEu(S0,X1,X2,r,T,sigma,M,type)
% compute constants
f7 = 1;  dt = T / M;  v = exp(-r * dt);
u = exp(sigma*sqrt(dt));   d = 1 /u;
p = (exp(r * dt) - d) / (u - d);

% initialize asset prices at maturity (period M)
S = zeros(M + 1,1);
S(f7+0) = S0 * d^M;
for j = 1:M
    S(f7+j) = S(f7+j - 1) * u / d;
end
if type == 1  % using calls
    % initialize option values at maturity (period M)
    C = max(S - X1, 0);

    % step back through the tree
    for i = M-1:-1:0
        for j = 0:i
            C(f7+j) = v * (p * C(f7+j + 1) + (1-p) * C(f7+j));
        end
    end
    C0 = C(f7+0);  % price of long call strike X1

    D = max(S-X2, 0);
    % step back through the tree
    for i = M-1:-1:0
        for j = 0:i
            D(f7+j) = v * (p * D(f7+j + 1) + (1-p) * D(f7+j));
        end
    end
    D0 = D(f7+0);  % price of short call strike X2 (>X1)


elseif type == 0 %using puts
    % initialize option values at maturity (period M)
    C = max(X1 - S, 0);

    % step back through the tree
    for i = M-1:-1:0
        for j = 0:i
            C(f7+j) = v * (p * C(f7+j + 1) + (1-p) * C(f7+j));
        end
    end
    C0 = C(f7+0);  % price of long call strike X1

    D = max(X2 - S, 0);
    % step back through the tree
    for i = M-1:-1:0
        for j = 0:i
            D(f7+j) = v * (p * D(f7+j + 1) + (1-p) * D(f7+j));
        end
    end
    D0 = D(f7+0);  % price of short call strike X2 (>X1)
end