function OCY_main(path,str,N)
% OCY_main - analyze image stack of the osteocyte network in a directory
%
% This MATLAB function is the main script for thresholding, segmentation,
% skeletonization and graph analysis of osteocyte lacuno-canalicular
% networks based on confocal image stacks.
%
%   OCY_main() - analyze images in current directory.
%   OCY_main(dir) - analyze images in directory 'dir'.
%   OCY_main(dir,str) - load images matching 'str' (e.g. '*ch00*.tif').
%   OCY_main(dir,str,N) - use only first N slices of stack (default: 51).
%   OCY_main(dir,str,N,scale) - set scale in um/voxel (default: 0.2).

oldpath = pwd;

if nargin==0
    path = pwd;
end;
 
if nargin<2
    str = '*.tif';
end;

if nargin<3
    N = 51;
end;

if nargin<4
    scale = 0.2;
end;

cd(path);

dirlist = dir();

if(~isempty(dirlist))
    
    % load image stack
    img = OCY_read_stack(str);

    % use only first N images
    if(size(img,3)>N)
        img=img(:,:,1:N);
    end;

    % apply 3D Gaussian filter
    img = smooth3(img,'gaussian',5);    
    
    % apply threshold and save initial binary volume
    bin_thr = OCY_thr_stack(img,0.13);
    save bin_thr bin_thr    
    clear img;
    
    % morphological filtering, then save processed binary 
    bin = OCY_fill_voids(bin_thr,10);    
    save bin bin
    clear bin_thr
    
    % detect cells
    cells = OCY_get_cells(bin);        

    % calculate and save initial skeleton excluding cells
    skel_ini = Skeleton3D(bin,cells);
    save skel_ini skel_ini
    save cells cells
    clear bin
    
    % convert voxel skeleton to network graph and back to cleaned skeleton
    [A,node,link,skel] = OCY_run_Skel2Graph3D(skel_ini,cells,5);
    clear skel_ini
    
    % create cell structure and assign distances to skeleton voxels
    [node,link,cell] = OCY_assign_dist(node,link,cells,A);

    % save skeleton and graph
    save skel skel
    save node node
    save link link
    save cell cell
    save A A

    % calculate and save distance transforms of skeleton and cells
    [dist,didx] = bwdist(logical(skel));
    celldist = bwdist(logical(cells));
    save dist dist
    save celldist celldist
    save didx didx
    
    % calculate and save network properties using MatlabBGL
    n = OCY_get_network_params(node,link,cells,skel,dist,celldist,didx,A,scale);
    save n n   

end;

cd(oldpath)



