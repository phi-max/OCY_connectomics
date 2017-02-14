function OCY_plot_cumhist(x,b,d,lstyle)

x = reshape(x,[length(b) 5 4]);

for k=0:3
    plot([0 b],[0 mean(x(:,:,k+1),2)'],lstyle,'LineWidth',5,'Color',d(5*k+1).idclr);%,'MarkerFaceColor',d(5*k+1).idclr,'MarkerSize',0);

    hold on;
end;

legend1=legend('Mouse 1','Mouse 2','Sheep 1','Sheep 2');

set(legend1,...
    'Position',[0.145 0.745 0.17 0.17],'FontSize',16,'EdgeColor',[.8 .8 .8],'FontName','Times','interpreter','latex');

set(gca,'FontSize',24);
set(gca,'LineWidth',2);
set(gca,'TickLength',[0.03 0.01]);
set(gca,'TickLabelInterpreter','latex');
set(gcf,'PaperPositionMode','auto');
