function bubblePlot(rep,nA,nS,G,NN)

% Make a Bubble Plot by C T Jones
% last updated on 21 June 2022

figure()
subplot(211)
p = plot(G);

p.EdgeColor = 'k';
p.NodeColor = 'k';
p.MarkerSize = 1;
p.LineWidth = 0.1;
p.NodeLabel = [];
axis tight
axis off

hold on
for n = 1:NN
    
    if nS(n)+nA(n) > 0
        
        pA = nA(n)/(nS(n)+nA(n));
        CLR = (1-pA)*ones(1,3);
        plot(p.XData(n),p.YData(n),'ko','markersize',max([1,5*log10(nS(n)+nA(n))]),'markerfacecolor',CLR,'linewidth',1)
        
    end
end
hold off

if rep == 0
    
    title('Initial','Interpreter','Latex','FontSize',20)
    
else
    
    title(['Iteration ' num2str(rep)],'Interpreter','Latex','FontSize',20)
    
end

%% END
