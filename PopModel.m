function [newA,newS,Rin] = PopModel(param,oldA,oldS,gens,rep,reps)

% Stochastic Population Dynamic Model by C T Jones
% last updated on 21 June 2022

T = param.T; 
delta = param.delta;
Dmin = param.Dmin;
Dmax = param.Dmax;
pMut = param.pMut;

newA = zeros(gens + 1,1); newA(1) = oldA;
newS = zeros(gens + 1,1); newS(1) = oldS;

if param.Mod == 1 % constant influx
    
    Rin = param.Rin;
    
elseif param.Mod == 2 % variable influx
    
    Rin = (param.Rin - param.Rin/10)*(cos(6.2832*rep/reps) + 1)/2 + param.Rin/10;
    
end

for t = 2:length(newA)
    
    N = newA(t-1) + newS(t-1); pi = newA(t-1)/N;
    D = Dmax + (Dmin - Dmax)*pi;
    cR = delta*newA(t-1)/(delta*newA(t-1) + newS(t-1));
    
    % births
    
    wA = round(sum(poissrnd(Rin*cR/(T*newA(t-1)),newA(t-1),1)));
    wS = round(sum(poissrnd(Rin*(1-cR)/(T*newS(t-1)),newS(t-1),1)));

    % deaths
    
    if newA(t-1) > 0
        dA = binornd(newA(t-1),D);
        newA(t) = newA(t-1) + wA - dA;
    end
    
    if newS(t-1) > 0
        dS = binornd(newS(t-1),D);
        newS(t) = newS(t-1) + wS - dS;
    end
    
    % S-to-A mutations
    m = binornd(newS(t),pMut);
    newA(t) = newA(t) + m;
    newS(t) = newS(t) - m;
    
    % A-to-S mutations
    m = binornd(newA(t),pMut);
    newS(t) = newS(t) + m;
    newA(t) = newA(t) - m;
 
end

newA = newA(end);
newS = newS(end);

%% END