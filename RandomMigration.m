function [nA,nS] = RandomMigration(nA,nS,G,NN,viscous)

% Random Migration between Groups by C T Jones
% last updated on 21 June 2022

numEvents = 10; % maximum number of migration events

alpha = 5;
beta = 15;

nodeList = 1:NN;

for rep = 1:numEvents
    
    if ~isempty(nodeList)
        donor = randsample(nodeList,1);
        nodeList = setdiff(nodeList,donor);
    end
    
    % **************************************************
    switch viscous
        
        case 0 % no spatial constraints
            
            if ~isempty(nodeList)
                recip = randsample(nodeList,1);
            else
                recip = [];
            end
            
        case 1 % spatial constraints
            
            candidates = intersect(neighbors(G,donor),nodeList);
            
            if ~isempty(candidates)
                recip = randsample(candidates,1);
            end
            
    end
    % **************************************************
    
    if ~isempty(recip)
        
        nodeList = setdiff(nodeList,recip);
        
        pV = betarnd(alpha,beta,1);
        donor_dnA = round(pV*nA(donor));
        donor_dnS = round(pV*nS(donor));

        nA(donor) = nA(donor) - donor_dnA;
        nS(donor) = nS(donor) - donor_dnS;
        
        nA(recip) = nA(recip) + donor_dnA;
        nS(recip) = nS(recip) + donor_dnS;
        
    end
    
end

%% END