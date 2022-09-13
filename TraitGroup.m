function [nA,nS] = TraitGroup(nA,nS)

% Trait-Group Selection
% by C T Jones, cjones2@dal.ca
% last updated on 21 June 2022

% pool all cells from all groups
Atot = sum(nA);
Stot = sum(nS);
NN = length(nA);

pVec = ones(1,NN)/NN;

% random redistribution of cells
nA = mnrnd(Atot,pVec); nA = nA(:);
nS = mnrnd(Stot,pVec); nS = nS(:);

%% END