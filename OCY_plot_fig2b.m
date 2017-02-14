function OCY_plot_fig2b(d)

md=load('mouse_cs/1/dist.mat');
mc=load('mouse_cs/1/celldist.mat');
od=load('ovine_cs/1/dist.mat');
oc=load('ovine_cs/1/celldist.mat');

mdvol=d(1).scale.*md.dist(300:400,400:500,:);
mcvol=d(1).scale.*mc.celldist(300:400,400:500,:);
odvol=d(1).scale.*od.dist(350:450,100:200,:);
ocvol=d(1).scale.*oc.celldist(350:450,100:200,:);

mdvol(1,1,1)=10;
mcvol(1,1,1)=10;
mdvol(end,end,end)=0;
mcvol(end,end,end)=0;
mdvol(mdvol>10)=10;
mcvol(mcvol>10)=10;

odvol(1,1,1)=10;
ocvol(1,1,1)=10;
odvol(end,end,end)=0;
ocvol(end,end,end)=0;
odvol(odvol>10)=10;
ocvol(ocvol>10)=10;

load cm

OCY_sliceplot(mdvol,cm);
set(gcf,'PaperPositionMode','auto');
print -dpng F_02_b1;

OCY_sliceplot(mcvol,cm);
set(gcf,'PaperPositionMode','auto');
print -dpng F_02_b2;

OCY_sliceplot(odvol,cm);
set(gcf,'PaperPositionMode','auto');
print -dpng F_02_b3;

OCY_sliceplot(ocvol,cm);
colorbar('FontSize',18);
set(gcf,'PaperPositionMode','auto');
print -dpng F_02_b4;