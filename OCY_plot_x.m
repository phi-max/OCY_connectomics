function OCY_plot_x(x,d)

set(gcf,'Color','white');hold all;
set(gca,'LineWidth',3);
set(gca,'FontSize',20);
set(gca,'TickLength',[0.05 0.02]);
set(gca,'TickLabelInterpreter','latex');
set(gcf,'PaperPositionMode','auto')

x = reshape(x,[5 4]);

xm=mean(x);
xe=std(x);


for k=0:3
    plot(k-(-0.1:0.05:0.1),x(:,k+1),d(5*k+1).linespec,'Color',d(5*k+1).idclr,'MarkerFaceColor',d(5*k+1).idclr,'MarkerSize',12);
    line([k-0.5 k+0.5],[xm(k+1) xm(k+1)],'Color',d(5*k+1).idclr,'LineWidth',2);
end;

