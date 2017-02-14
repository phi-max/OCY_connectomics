clear all;
close all;

startpath = pwd;

% murine cs
path{1} = 'mouse_cs/1';
path{2} = 'mouse_cs/2';
path{3} = 'mouse_cs/3';
path{4} = 'mouse_cs/4';
path{5} = 'mouse_cs/5';

% murine ls
path{6} = 'mouse_ls/1';
path{7} = 'mouse_ls/2';
path{8} = 'mouse_ls/3';
path{9} = 'mouse_ls/4';
path{10} = 'mouse_ls/5';

% ovine cs
path{11} = 'ovine_cs/1';
path{12} = 'ovine_cs/2';
path{13} = 'ovine_cs/3';
path{14} = 'ovine_cs/4';
path{15} = 'ovine_cs/5';

% ovine ls
path{16} = 'ovine_ls/1';
path{17} = 'ovine_ls/2';
path{18} = 'ovine_ls/3';
path{19} = 'ovine_ls/4';
path{20} = 'ovine_ls/5';

d = struct('scale',0.2*ones(1,20));

for i=1:length(path)
       
    oldpath = pwd;
    
    cd(path{i});
       
    load n
    load node
    load link
       
    d(i).node = node;
    d(i).link = link;
    d(i).w = n.w;
    d(i).l = n.l;
    d(i).h = n.h;
    d(i).scale = n.scale;
    d(i).N = n.N;
    d(i).N_nocell = n.N_nocell; % number of no-cell nodes
    d(i).N_noedg = n.N_noedg; % number of no-cell no-edge nodes
    d(i).edg = n.edg; % indices of edge endpoints
    d(i).realnodes = n.realnodes; % indices of no-cell no-endpoint nodes
    d(i).noedg_nodes = n.noedg_nodes; % indices of no-cell no-edge nodes
    d(i).cc = n.cc;
    d(i).dd = n.dd;
    d(i).D = n.D;
    d(i).bw = n.bw;
    d(i).lac_por = n.lac_por;
    d(i).can_len = n.can_len;
    d(i).d_net = n.d_net;
    d(i).d_cell = n.d_cell;
    d(i).d_can = n.d_can;
    d(i).d_cell_hist = n.d_cell_hist;
    d(i).d_can_hist = n.d_can_hist;
    d(i).d_ratio = n.d_ratio;
    d(i).d_ratio2 = n.d_ratio2;
    d(i).d_ratio3 = n.d_ratio3;
    d(i).hbz = n.hbz;
    d(i).chbz = n.chbz;
    d(i).chbz2 = n.chbz2;
    d(i).dist_edge = n.dist_edge;
    d(i).edge_den = n.edge_den;
    d(i).edge_den_nocell = n.edge_den_nocell;
    d(i).mean_deg = n.mean_deg;
    d(i).mean_deg_ep = n.mean_deg_ep; % mean degree without endpoints
    d(i).mean_deg_noedg = n.mean_deg_noedg; % mean degree without edges
    d(i).t_nodes = n.t_nodes;
    d(i).c_nodes = n.c_nodes;
    d(i).e_nodes = n.e_nodes;
    d(i).cell_idx = n.cell_idx;
    d(i).asp = n.asp;
    d(i).acc = n.acc;
    d(i).asp_logic = n.asp_logic;
    d(i).asp_ER = n.asp_ER;
    d(i).acc_ER = n.acc_ER;
    d(i).k_ER = n.k_ER;
    
    d(i).id = ceil(i/5);
    
    if(d(i).id==1) % mouse cs
        d(i).idclr = [.7,.1,.1];
        d(i).linespec = 'v';
    end;
    if(d(i).id==2) % mouse ls
        d(i).idclr = [1,.5,.3];
        d(i).linespec = '^';
    end;
    if(d(i).id==3) % ovine cs
        d(i).idclr = [0,0,.4];
        d(i).linespec = 'o';
    end;
    if(d(i).id==4) % ovine ls
        d(i).idclr = [.2,.4,1];
        d(i).linespec = 's';
    end;
    
    cd(oldpath)
end;

cd(startpath)



%%%%%%%% Density and distance %%%%%%%%%%%%%%%%

% Fig 1c: canalicular density over void fraction
figure('Position',[1 1 520 470]);
OCY_plot_xy([d.lac_por],[d.can_len],d);
axis([0 0.3 0 0.25]);
xlabel('void fraction','interpreter','latex');
ylabel('canalicular density ($\mu$m$^{-2}$)','interpreter','latex');
print -dsvg -painters F_01_c

% Fig. 2c: distance to canaliculi over distance through network
figure('Position',[1 1 520 470]);
OCY_plot_xy([d.d_net],[d.d_can],d);
axis([0 20 0 2.5]);
xlabel('d$_{net}$ ($\mu$m)','interpreter','latex');
ylabel('d$_{LC}$ ($\mu$m)','interpreter','latex');
print -dsvg F_02_c

% Fig. 2a: cumulative histogram of cell and canalicular distances
figure('Color',[1 1 1],'Position',[1 1 780 705]);
b=d(1).scale.*(1:25);
OCY_plot_cumhist([d.d_can_hist],b,d,'-');
OCY_plot_cumhist([d.d_cell_hist],b,d,':');
axis([0 5 0 1]);
xlabel('distance ($\mu$m)','interpreter','latex');
ylabel('cumulative probability','interpreter','latex');
set(gca,'XTick',(0:5));
annotation(gcf,'textbox',...
    [0.72 0.22 0.15 0.065],...
    'String',{'lacunae'},...
    'FontSize',24,...
    'FontName','Times',...
    'EdgeColor','none',...
    'Interpreter','latex');
annotation(gcf,'textbox',...
    [0.58 0.69 0.34 0.065],...
    'String',{'lacunae + canaliculi'},...
    'FontSize',24,...
    'FontName','Times',...
    'EdgeColor','none',...
    'Interpreter','latex');
print -dsvg F_02_a

% advantage via network
figure('Color',[1 1 1],'Position',[1 1 520 430]);
ratios=[1,2,5,10,20,50,100,500,1000];
OCY_plot_cumhist([d.d_ratio3],ratios,d,'-');
legend1=legend('Mouse 1','Mouse 2','Sheep 1','Sheep 2');
set(legend1,...
    'Position',[0.23 0.65 0.18 0.24],'FontSize',16,'EdgeColor',[.8 .8 .8],'FontName','Times','interpreter','latex');
set(gca,'XScale','log');
axis([1 1000 1 14]);
set(gca,'XTick',[1 10 100 1000]);
set(gca,'XTickLabel',[1 10 100 1000]);
xlabel('$v_{\mathrm{network}}$ / $v_{\mathrm{matrix}}$','interpreter','latex');
ylabel('speed gain','interpreter','latex');
print -dsvg F_02_d


%%%%%%%%5 Topology %%%%%%%%%%%%%%%%%

% edge density over number of nodes (including cells)
figure('Position',[100 200 560 530]);
OCY_plot_xy(cellfun('length',{d.node}),[d.edge_den],d);
axis([0 10000 0 1.5E-3]);
xlabel('\# Nodes','interpreter','latex');
ylabel('Edge density','interpreter','latex');
plot((2000:10000),2.8./(2000:10000),'-','Color',[.5 .5 .5],'LineWidth',2);
print -dsvg F_03_a

% number of edges over number of nodes
figure('Position',[700,400,380 310]);
OCY_plot_xy(cellfun('length',{d.node}),cellfun('length',{d.link}),d);
legend off;
axis([0 10000 0 15000]);
xlabel('\# Nodes','interpreter','latex');
ylabel('\# Edges','interpreter','latex');
print -dsvg F_03_ain

% mean degree without endpoints and cells
figure('Position',[700,400,380 310]);
OCY_plot_x([d.mean_deg],d);
axis([-0.6 3.55 0 5]);
set(gca,'XTick',[0 1 2 3]);
set(gca,'XTickLabel',{'M1','M2','S1','S2'});
ylabel('<k>');
set(gcf,'PaperPositionMode','auto')
print -dsvg F_03_b

% cumulative edge length distribution
figure('Color',[1 1 1],'position',[100 100 640 550]);
heb = (0.5:0.5:20);
OCY_plot_cumhist([d.dist_edge],heb,d,'-');
set(gca,'YScale','log');
x=(4:9);
set(gca,'LineWidth',2);
set(gca,'FontSize',20);
xlabel('Edge Length ($\mu$m)','interpreter','latex');
ylabel('P (K$\geq$k)','interpreter','latex');
legend1=legend('Mouse 1','Mouse 2','Sheep 1','Sheep 2');
set(legend1,...
    'location','northeast','FontSize',16,'EdgeColor',[.8 .8 .8],'FontName','Times','interpreter','latex');
plot(x,.2*exp(x.*-.66),'-','Color',[.5 .5 .5],'LineWidth',5);
set(gca,'YTick',[1E-5 1E-4 1E-3 1E-2 1E-1 1E-0]);
annotation(gcf,'textbox',...
    [0.25 0.35 0.15 0.065],...
    'String',{'$\sim e^{-(2/3)x}$'},...
    'FontSize',24,...
    'FontName','Times',...
    'EdgeColor','none',...
    'Interpreter','latex');
print -dsvg F_03_b

for i=1:20
    P = polyfit(heb(5:20),log(d(i).dist_edge(5:20)),1);
    d(i).exp_len = P(1);
end;


% cumulative degree distribution
figure('Color',[1 1 1],'position',[100 100 640 550]);
hb = (1:30);
OCY_plot_cumhist([d.hbz],hb,d,'-');
legend off;
set(gca,'YScale','log');
x=(4:7);
plot(x,8*exp(x.*-4/3),'-','Color',[.5 .5 .5],'LineWidth',5);
hold on;
set(gca,'LineWidth',2);
set(gca,'FontSize',20);
xlabel('k','interpreter','latex');
ylabel('P (K$\geq$k)','interpreter','latex');
legend1=legend('Mouse 1','Mouse 2','Sheep 1','Sheep 2');
set(legend1,...
    'location','northeast','FontSize',16,'EdgeColor',[.8 .8 .8],'FontName','Times','interpreter','latex');
axis([2 12 1E-5 1]);
set(gca,'XTick',[3 4 5 6 7 8 9 10 11 12 13]);
set(gca,'YTick',[1E-5 1E-4 1E-3 1E-2 1E-1 1E-0]);
axis([3 12 1E-5 1]);
annotation(gcf,'textbox',...
    [0.25 0.35 0.15 0.065],...
    'String',{'$\sim e^{-(4/3)x}$'},...
    'FontSize',24,...
    'FontName','Times',...
    'EdgeColor','none',...
    'Interpreter','latex');
print -dsvg F_03_c

for i=1:20
    P = polyfit(hb(3:8),log(d(i).hbz(3:8)),1);
    d(i).exp_deg = P(1);
end;

% cumulative weighted degree distribution
figure('Color',[1 1 1],'position',[100 100 640 550]);
hb = (1:3000);
OCY_plot_cumhist([d.chbz],hb,d,'-');
legend1=legend('Mouse 1','Mouse 2','Sheep 1','Sheep 2');
set(legend1,...
    'location','northeast','FontSize',16,'EdgeColor',[.8 .8 .8],'FontName','Times','interpreter','latex');
set(gca,'XScale','log');
set(gca,'YScale','log');
x=(5:13);
plot(x,2*exp(x.*-.5),'-','Color',[.5 .5 .5],'LineWidth',3);
xx=(50:500);
plot(xx,3./(xx.^1.5),'-','Color',[.5 .5 .5],'LineWidth',3);
annotation(gcf,'textbox',...
    [0.2 0.58 0.15 0.065],...
    'String',{'$\sim e^{-x/2}$'},...
    'FontSize',24,...
    'FontName','Times',...
    'EdgeColor','none',...
    'Interpreter','latex');
annotation(gcf,'textbox',...
    [0.65 0.55 0.15 0.065],...
    'String',{'$\sim x^{-3/2}$'},...
    'FontSize',24,...
    'FontName','Times',...
    'EdgeColor','none',...
    'Interpreter','latex');set(gca,'LineWidth',2);
set(gca,'FontSize',20);
xlabel('Weighted Degree ($\mu$m)','interpreter','latex');
ylabel('P (K$\geq$k)','interpreter','latex');
axis([1 1E3 1E-5 1]);
set(gca,'XTick',[1E0 1E1 1E2 1E3]);
set(gca,'YTick',[1E-5 1E-4 1E-3 1E-2 1E-1 1E-0]);
print -dsvg F_03_d


%%%%%%%%%%%%%%%%%%%%%%%%% FIG 4 %%%%%%%%%%%%%%%%%%%%%%%%%%%%

% percentage of treenodes
figure('position',[200 200 300 400]);
tree_prct = 100*cellfun('length',{d.t_nodes})./[d.N];
clus_prct = 100*cellfun('length',{d.c_nodes})./[d.N];
end_prct = 100*(cellfun('length',{d.e_nodes})-cellfun('length',{d.edg}))./[d.N];
OCY_plot_x(tree_prct,d);
legend off;
axis([-0.6 3.55 0 100]);
set(gca,'XTick',[0 1 2 3]);
set(gca,'XTickLabel',{'M1','M2','S1','S2'});
ylabel('\% tree nodes','interpreter','latex');
set(gcf,'PaperPositionMode','auto')
print -dsvg F_04_a

% percentage of cluster nodes
figure('position',[200 200 300 400]);
OCY_plot_x(clus_prct,d);
legend off;
axis([-0.6 3.55 0 5]);
set(gca,'XTick',[0 1 2 3]);
set(gca,'XTickLabel',{'M1','M2','S1','S2'});
ylabel('\% cluster nodes','interpreter','latex');
set(gcf,'PaperPositionMode','auto')
print -dsvg F_04_b

% Simulate equivalent ER networks
for i=1:20
    n=d(i).node;
    deg = cellfun('length',{n.links});
    d(i).acc2 = 1./(deg.*(deg-1)).*d(i).cc';
    d(i).acc2 = mean(d(i).acc2(~isnan(d(i).acc2)));
    
    for j=1:50
        deg = d(i).k_ER(j,:);
        acc2_ER = 1./(deg.*(deg-1)).*d(i).acc_ER(j,:);
        acc2(j) = mean(acc2_ER(~isnan(acc2_ER)));  
    end;
    d(i).acc2_ER = mean(acc2);
    d(i).acc_ER = mean(d(i).acc_ER(:));
    d(i).asp_ER = mean(d(i).asp_ER);

end;

% S versus network size
figure('position',[100 200 450 450]);
S=([d.acc]./[d.acc_ER])./([d.asp_logic]./[d.asp_ER]);
L=cellfun('length',{d.node});
OCY_plot_xy(L,S,d);
legend1=legend('Mouse 1','Mouse 2','Sheep 1','Sheep 2');
set(legend1,...
    'location','northwest','FontSize',16,'EdgeColor',[.8 .8 .8],'FontName','Times','interpreter','latex');
axis([0 10000 0 80]);
xlabel('N','interpreter','latex');
ylabel('Small-Worldness S','interpreter','latex');
set(gca,'XTick',[0 2000 4000 6000 8000 10000]);
set(gca,'FontSize',16);
set(gcf,'PaperPositionMode','auto')
print -dsvg F_04_d

% Small-Worldness compared to other networks
h=xlsread('humphries.xls');
figure('Position',[100 100 420 380],'Color',[1 1 1]);
loglog(h(:,1),h(:,2),'o','MarkerSize',10,'Color',[.75 .75 .75],'MarkerFaceColor',[.75 .75 .75]);
hold on;
plot(mean(L(1:5)),mean(S(1:5)),d(1).linespec,'MarkerSize',14,'Color',d(1).idclr,'MarkerFaceColor',d(1).idclr);
plot(mean(L(6:10)),mean(S(6:10)),d(6).linespec,'MarkerSize',14,'Color',d(6).idclr,'MarkerFaceColor',d(6).idclr);
plot(mean(L(11:15)),mean(S(11:15)),d(11).linespec,'MarkerSize',14,'Color',d(11).idclr,'MarkerFaceColor',d(11).idclr);
plot(mean(L(16:20)),mean(S(16:20)),d(16).linespec,'MarkerSize',14,'Color',d(16).idclr,'MarkerFaceColor',d(16).idclr);
plot((20:1000000),0.012.*(20:1000000).^1.11,'k-','LineWidth',2);
loglog(h(29,1),h(29,2),'o','MarkerSize',10,'Color',[0 0 0],'MarkerFaceColor',[0 0 0]);
loglog(h(14,1),h(14,2),'o','MarkerSize',10,'Color',[0 0 0],'MarkerFaceColor',[0 0 0]);
xlabel('N','interpreter','latex');
ylabel('S','interpreter','latex');
annotation(gcf,'textarrow',...
    [0.575 0.445],[0.355 0.405],'String',{'\textit{C. Elegans}','connectome'},...
    'FontSize',14,'interpreter','latex');
annotation(gcf,'textarrow',[0.46 0.64],...
    [0.8 0.73],'String',{'WWW'},'FontSize',14,'interpreter','latex');
set(gca,'FontSize',16);
set(gca,'LineWidth',2);
set(gca,'TickLength',[0.04 0.02]);
set(gca,'XTick',[1 100 1E4 1E6 1E8]);
set(gca,'YTick',[1E-2 1 100 1E4 1E6]);
set(gca,'TickLabelInterpreter','latex');
axis([1 1E8 1E-2 1E6]);
set(gcf,'PaperPositionMode','auto')
print -dsvg F_04_e


