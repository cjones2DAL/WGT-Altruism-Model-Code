% Metapopulation Simulations
% All Scenarios
% by C T Jones, cjones2@dal.ca
% last updated on 21 June 2022

clc
clear
close all

%% model parameters

% specify the number of nodes in the metapopulation
dim = 7;
NN = dim^2; 

% create graph object with Edges and Nodes
[G,centerNode] = LatticeNetwork(dim,8); 

% set parameters for the stochastic population model
param.T = 0.01; 
param.delta = 0.98;
param.Dmin = 0.05;
param.Dmax = 0.30;
param.pMut = 1e-6;
  
%% sceanrio parameters

% sceanrio 1 = start with an S-type metapopulation 
% sceanrio 2 = start with an S-type with one A-type group
% sceanrio 3 = start with an A-type metapopulation

scenario = 1; 
param.Rin = 0.50;  % 0.50 or 0.05
param.Mod = 2;     % 1 = constant Rin, 2 = cosine Rin
viscous = 1;       % 0 = non-viscous, 1 = viscous

dispersalType = 'none'; % RM,SM,TG, or none

reps = 2e6;   % the number of model iterations
gens = 1;     % the number of generations between iterations

%% initialize the metapopulation

switch scenario
    
    case 1 % start with an S-type metapopulation
        
        nA = zeros(NN,1);
        nS = round(param.Rin/(param.T*param.Dmax))*ones(NN,1);
        
    case 2 % start with one A-type group
        
        nA = zeros(NN,1);
        nS = round(param.Rin/(param.T*param.Dmax))*ones(NN,1);
        
        nA(centerNode) = round(param.Rin/(param.T*param.Dmin));
        nS(centerNode) = 0;
        
    case 3 % start with an A-type metapopulation
        
        nA = round(param.Rin/(param.T*param.Dmin))*ones(NN,1);
        nS = zeros(NN,1);
        
end

%% run the simulation

showBubbles = 1; % 0 = don't show, 1 = show

figureCounter = 1;
path2fig = 'C:\Users\qLv44\OneDrive\Desktop\TempFigures\';

bubblePlot(0,nA,nS,G,NN)

exportgraphics(gca,[path2fig 'F' num2str(figureCounter) '.png'],'Resolution',300)
pause(1)

% track the number of A-type cells in the metapopulation
Atot = zeros(reps,1);

% track nutrient influx
Rin = zeros(reps,1);

% track group extinctions (very rare)
OldExID = []; ExtinctionEvents = zeros(reps,1);

% start the model
for rep = 1:reps
    
    NewExID = find(nA+nS == 0); % identify groups of size zero
    
    ExtinctionEvents(rep) = length(setdiff(NewExID,OldExID));
    OldExID = NewExID;
    
    switch dispersalType
        
        case 'RM' % random migration (random assortment)
            
            [nA,nS] = RandomMigration(nA,nS,G,NN,viscous);
            
        case 'TG' % trait-group selection (random assortment)
            
            [nA,nS] = TraitGroup(nA,nS);
            
        case 'SM' % selective migration (positive assortment)
            
            [nA,nS] = SelectiveMigration(nA,nS,G,NN,viscous);
               
    end
    
    % run all populations forward "gens" generations

    for pop = 1:NN
        Ntot = sum(sum([nA,nS]));
        [nA(pop),nS(pop)] = PopModel(param,nA(pop),nS(pop),gens,rep,reps);
    end
    
    % count the A-type cells
    Atot(rep) = sum(nA);
   
    % make a bubble plot
    if showBubbles
        
        if mod(rep,reps/10) == 0
            
            figureCounter = figureCounter + 1;
            
            disp([num2str(rep) '/' num2str(reps)])
            bubblePlot(rep,nA,nS,G,NN)
            
            exportgraphics(gca,[path2fig 'F' num2str(figureCounter) '.png'],'Resolution',300)
            pause(1)
              
        end
        
    end
    
end

%% figure

figure
plot(Atot,'k','LineWidth',2)
set(gca,'TickLabelInterpreter','Latex','FontSize',25,'LineWidth',2)

switch gens
    
    case 1
        xlabel('Generations','Interpreter','Latex')
        
    otherwise
        xlabel('Iterations','Interpreter','Latex')
end

ylabel('A-Type Cell Count','Interpreter','Latex','FontSize',25)
grid on, box on

figureCounter = figureCounter + 1;
exportgraphics(gca,[path2fig 'F' num2str(figureCounter) '.png'],'Resolution',300)
pause(1)

%% END