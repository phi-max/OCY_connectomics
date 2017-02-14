function n = OCY_get_network_params(node,link,cells,skel,dist,celldist,didx,A,scale)

oldskel = skel;
skel = skel(2:end-1,2:end-1,2:end-1);
cells = cells(2:end-1,2:end-1,2:end-1);
dist = dist(2:end-1,2:end-1,2:end-1);
celldist = celldist(2:end-1,2:end-1,2:end-1);

n.w = size(skel,1);
n.l = size(skel,2);
n.h = size(skel,3);
n.scale = scale;

% number of nodes
n.N = size(A,1);

% node indices of non-cells
isnocell = @(i) i==0;
n.cell_idx=find(cellfun(isnocell,({node.cellnode})));

% end points
n.e_nodes = find(cellfun(isnocell,{node.ep})==0);

% node indices of all no-endpoint no-cells
n.realnodes=intersect((1:n.e_nodes(1)-1),n.cell_idx);

% number of nodes without cells
n.N_nocell = length(n.cell_idx);

% potential cut-off canaliculi are endpoints near edge of volume
n.edg = find((([node.comx]>1).*([node.comy]>1).*([node.comz]>1))==0);
n.edg = intersect(n.edg,find([node.ep]>0));

% node indices of all no-edge no-cells
n.noedg_nodes=setdiff(n.cell_idx,n.edg);

% number of no-edge no-cells
n.N_noedg = n.N_nocell - length(n.edg);

% clustering coeff
n.cc = clustering_coefficients(logical(A));

% number of components
ccomp=bwconncomp(skel);
n.dd=ccomp.NumObjects;

% shortest path matrix (in micrometer)
n.D = scale.*johnson_all_sp(A);

% betweenness centrality
n.bw = 2*betweenness_centrality(A)/(n.N*(n.N-1));

% void fraction: fraction of foreground voxels over all voxels
n.lac_por = length(find(logical(skel))) ./ length(cells(:));

% canalicular density: total can length div by matrix volume without cells
n.can_len = (1/scale.^2) .* length(find(logical(skel-cells))) ./ (length(skel(:)) - length(find(cells(:))));

% mean of all cell distances through network
vdists=[link.dist];
vdists(vdists==0)=[];
vdists(vdists==9999)=[];
n.d_net=mean(scale.*vdists);

% mean of distance to cells through matrix
vdists=celldist(:)';
vdists(vdists==0)=[];
n.d_cell = mean(vdists).*scale;

% mean of distance to network through matrix
vdists2=dist(:)';
vdists2(vdists2==0)=[];
n.d_can = mean(vdists2).*scale;

% cumulative histogram of both matrix distances
cs1=zeros(1,25);
cs2=zeros(1,25);
for j=1:25
    cs1(j)=length(find(vdists<=j))/length((vdists));
    cs2(j)=length(find(vdists2<=j))/length((vdists2));
end;
n.d_cell_hist = cs1;
n.d_can_hist = cs2;

% write network distances into link voxels
aa=[link.dist];
aa(aa==9999)=0;
dsk = oldskel.*0;
dsk([link.point])=aa;

% write network distance of nearest network voxel into matrix voxels
dsm = dsk(didx);

% remove outer layer to match with other truncated volumes
dsm = dsm(2:end-1,2:end-1,2:end-1);

% velocity gain via network compared to matrix diffusion
ratios=[1,2,5,10,20,50,100,500,1000];
idx=find(celldist(:)>0);
n.d_ratio=n.d_cell ./ (scale .* (mean(dist(idx)) + 1./ratios.*mean(dsm(idx))));
n.d_ratio2=n.d_cell ./ (scale .* ( n.d_cell./ratios + (mean(dist(idx)).*(1-1./ratios)) + mean(dsm(idx)).*(1./(ratios-1))));
n.d_ratio3= (mean(dist(idx)) + mean(dsm(idx))) ./ (mean(dist(idx)) + 1./ratios.*mean(dsm(idx)));

% cumulative node degree excluding cells

deg = cellfun('length',{node(n.realnodes).links});
n.mean_deg = mean(deg); % no cells, no endpoints
n.median_deg = median(deg);
for z=1:30
    n.hbz(z)=length(find(deg>=z))./length(deg);
end;

% degrees of non-cell non-endpoints
deg_ep = cellfun('length',{node(n.realnodes).links});
n.mean_deg_ep = mean(deg_ep);

% degrees of non-cell non-endpoints
deg_noedg = cellfun('length',{node(n.noedg_nodes).links});
n.mean_deg_noedg = mean(deg_noedg);

% cumulative weighted degree including cells
wd=scale.*full(sum(A,2));
for z=1:3000
    n.chbz(z)=length(find(wd>=z))./length(wd);
    n.chbz2(z)=length(find(wd(n.cell_idx)>=z))./length(wd(n.cell_idx));
end;

% cumulative edge length distribution
hbins = (0.5:0.5:20);
len = scale*cellfun('length',{link.point});
for z=1:length(hbins)
    n.dist_edge(z)=length(find(len>=hbins(z)))./length(len);
end;

% edge density
n.edge_den = 2*length(link)./(n.N*(n.N-1));

% edge density without cells
n.edge_den_nocell = 2*length(link)./(n.N_nocell*(n.N_nocell-1));

% tree likes nodes (deg = 3, cc = 0)
dn = cellfun('length',{node.links});
cct1=find(dn==3);
cct2=find(n.cc==0);
n.t_nodes=intersect(cct1,cct2);

% cluster nodes with cc>0.5
n.c_nodes=find(n.cc>0.5);

% average shortest path and average CC
n.asp = mean(full(n.D(isfinite(n.D(:)))));
n.acc = mean(n.cc);

% non-weighted average shortest path (for comparison with ER network)
D_log = johnson_all_sp(double(logical(A)));
n.asp_logic = mean(D_log(isfinite(D_log)));

% Erdös-Renyi-Network with same N and link probability p
for i=1:50
    AER = erdos_reyni(n.N,n.edge_den);
    DER = johnson_all_sp(AER);
    asp_ER(i) = mean(DER(isfinite(DER)));
    cc_ER(i,:) = clustering_coefficients(double(logical(AER)));
    k(i,:) = sum(logical(AER),1);
end;    
n.asp_ER = mean(asp_ER);
n.acc_ER = cc_ER;
n.k_ER = k;

