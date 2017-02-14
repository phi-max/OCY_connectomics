function [node,link,cell] = OCY_assign_dist(node,link,cells,A)
% OCY_cell_nodes - generate cell structure and assign cell number to nodes
%
% [node,link,cell] = OCY_cell_nodes(node,link,cells) - returns the updated
% nodes structure and an additional cell structure based on volume "cells"
%
% OCY_ana_cell_links - assign length to next cell to all voxels and nodes
%
% [node,link,cell] = OCY_ana_cell_links(node,link,cell,cells,skel,A)

w=size(cells,1);
l=size(cells,2);
h=size(cells,3);

% convert to integer to allow labelling
cells=uint16(cells);

% get list of cell coordinates
cc=bwconncomp(cells);
n_cells = cc.NumObjects;

% generate cell structure
cell = [];
if(n_cells>0)
    for i=1:n_cells
        cells(cc.PixelIdxList{i})=i;
        cell(i).idx = cc.PixelIdxList{i};
        cell(i).node = [];
        [x, y, z]=ind2sub([w l h],cell(i).idx);
        cell(i).comx = mean(x);
        cell(i).comy = mean(y);
        cell(i).comz = mean(z);
    end;
end;

% assign cell number to node if node is a cell
for i=1:length(node)
    cn = max(cells(node(i).idx));
    if(cn)
        node(i).cellnode = cn;
        cell(cn).node = i;
    else
        node(i).cellnode = 0;
    end;
end;

% initialize distance for all nodes and canal voxels with 9999
for i=1:length(node)
    node(i).dist=9999;
    for j=1:length(node(i).links)
        if(node(i).links(j)>0)
            if(~isempty(link(node(i).links(j)).point))
                link(node(i).links(j)).dist(1:length(link(node(i).links(j)).point))=9999;
            end;
        end;
    end;
end;

% number of cells
n_cells=length(cell);

% assign connections to cells, and distances to cells and nodes
for i=1:n_cells
    c=0;
    cell(i).cell=[];
    cell(i).dist=[];
    if(~isempty(cell(i).node))
        [d,~]=dijkstra_sp(A,cell(i).node);
        for k=1:n_cells
            if(k~=i)
                if(isfinite(d(cell(k).node)))
                    c=c+1;
                    cell(i).cell(c)=k;
                    cell(i).dist(c)=max(d(cell(k).node)-1,0);
                end;
            end;
        end;
        for k=1:length(node)
            if(node(k).dist>d(k))
                node(k).dist=max(d(k)-1,0);
                node(k).cell=i;
            end;
        end;
    end;
end;

% assign to all canalicular voxels their distance to the next cell
for i=1:length(node)
    for j=1:length(node(i).links)
        
        if(i==link(node(i).links(j)).n1)
            di = cumsum(ones(1,length(link(node(i).links(j)).point)));
        else
            di = flipdim(cumsum(ones(1,length(link(node(i).links(j)).point))),2);
        end;
        
        link(node(i).links(j)).dist = min(node(i).dist+di-1,link(node(i).links(j)).dist);
        
    end;
end;

