function [nA,nS] = SelectiveMigration(nA,nS,G,NN,viscous)

% Selective Migration between Groups
% by C T Jones, cjones2@dal.ca
% last updated on 21 June 2022


numEvents = 10; % maximum number of migrations

alpha = 5;
beta = 15;

nodeList = 1:NN;

Ntot = nA + nS;
[~,I] = sort(Ntot,'descend');
candidateDonors = I(1:numEvents);
nodeList = setdiff(nodeList,candidateDonors);

for rep = 1:numEvents
    
    donor = candidateDonors(rep);
    
    % **************************************************
    switch viscous
        
        case 0 % no spatial constraints
            
            recip = randsample(nodeList,1);
            
        case 1 % spatial constraints
            
            candidates = intersect(neighbors(G,donor),nodeList);
            
            if ~isempty(candidates)
                recip = randsample(candidates,1);
            else
                continue
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