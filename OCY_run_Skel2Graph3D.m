function [A,node,link,skel] = OCY_run_Skel2Graph3D(skel,cells,THR_BRANCH)
% OCY_filter_nodes - clean up graph structure to match voxel skeleton
%
% [node,link,cell] = OCY_filter_nodes(node,link,cell,cells)
%
% [node,link,cell] = OCY_filter_nodes(node,link,cell,cells,THR)
%
% All branches shorter than THR are removed.

if (nargin==1)
    THR_BRANCH = 0;
end;

% dimensions of stack
w = size(skel,1);
l = size(skel,2);
h = size(skel,3);

[~,node,link] = Skel2Graph3D(skel,THR_BRANCH);

% total length of network
wl = sum(cellfun('length',{node.links}));

% initial step: condense, convert to voxels and back
skel = Graph2Skel3D(node,link,w,l,h);
skel = Skeleton3D(skel,cells);
[A,node,link] = Skel2Graph3D(skel,THR_BRANCH);

% calculate new total length of network
wl_new = sum(cellfun('length',{node.links}));

% iterate the same steps until network length changed by less than 0.5%
while(wl_new~=wl)

    wl = wl_new;   
    
     skel = Graph2Skel3D(node,link,w,l,h);
     skel = Skeleton3D(skel,cells);
     [A,node,link] = Skel2Graph3D(skel,THR_BRANCH);

     wl_new = sum(cellfun('length',{node.links}));

end;
