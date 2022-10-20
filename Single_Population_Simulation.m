% Single Population Simulation by C T Jones
% last updated on 21 June 2022

clc
clear
close all

%% set parameters

% ************************
% fixed parameters
% ************************
T = 1;
delta = 0.98;
Dmin = 0.05;
Dmax = 0.30;
pMut = 1e-6;
% ************************

% ************************
% variable parameters
% ************************
Rin = 5;
tMax = 1e7;
% ************************

nA = zeros(tMax,1);  % number of A-type cells 
nS = zeros(tMax,1);  % number of S-type cells 
tMut = zeros(tMax,1);% time of mutation

%% run simulations

% start with an S-type population
nS(1) = round(Rin/(T*Dmax));
pi = nA(1)/(nA(1) + nS(1));

tic
for t = 2:tMax
    
    % population size
    N = nA(t-1) + nS(t-1); 
    
    % proportion of A-types
    pi = nA(t-1)/N;
    
    % death rate
    D = Dmax + (Dmin - Dmax)*pi;
    
    % consumption ration
    cR = delta*nA(t-1)/(delta*nA(t-1) + nS(t-1));
    
    % stochastic births
    wA = round(sum(poissrnd(Rin*cR/(T*nA(t-1)),nA(t-1),1)));
    wS = round(sum(poissrnd(Rin*(1-cR)/(T*nS(t-1)),nS(t-1),1)));

    % stochastic deaths
    
    if nA(t-1) > 0
        dA = binornd(nA(t-1),D);
        nA(t) = nA(t-1) + wA - dA;
    end
    
    if nS(t-1) > 0
        dS = binornd(nS(t-1),D);
        nS(t) = nS(t-1) + wS - dS;
    end
    
    % S-to-A mutations
    m = binornd(nS(t),pMut);
    nA(t) = nA(t) + m;
    nS(t) = nS(t) - m;
    tMut(t) = tMut(t) + m;
    
    % A-to-S mutations
    m =  binornd(nA(t),pMut);
    nS(t) = nS(t) + m;
    nA(t) = nA(t) - m;
    tMut(t) = tMut(t) + m;
    
end
toc

%% display results

figure(1), hold all

pA = plot(nA,'Color',0.0*ones(1,3),'LineWidth',1);
pS = plot(nS,'Color',0.6*ones(1,3),'LineWidth',1);

idx = find(tMut > 0);
for n = 1:length(idx)
    if idx(n) <= tMax
        plot(idx(n)*ones(1,2),[0,0.15*max([nA(:);nS(:)])],'k','LineWidth',0.5)
    end
end

set(gca,'TickLabelInterpreter','Latex','FontSize',20,'LineWidth',2)
xlabel('Generations','Interpreter','Latex')
ylabel('Cell Counts','Interpreter','Latex')
box on

LG = legend([pA,pS],{'A-type','S-type'});
LG.Interpreter = 'Latex';
LG.FontSize = 20;

%% END