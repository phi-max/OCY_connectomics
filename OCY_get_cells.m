function cells = OCY_get_cells(img,DIST_THR,CELL_SIZE,EXP_THR,EXP_FRAC)
% OCY_get_cells - detect large objects (cells) in binary stack
%
% cells = OCY_get_cells(img) - returns cells in stack 'img'
%
% cells = OCY_get_cells(img,A,B,C,D) - use custom parameters:
%
%    A - distance threshold to identify potential cells (default: 7)
%    B - minimum object size in voxels (default: 100)
%    C - distance threshold for dilation (default: 3)
%    D - limit fraction for dilation (default: 0.1)

if(nargin==1)
    DIST_THR = 7;
    CELL_SIZE = 100;
    EXP_THR = 4;
    EXP_FRAC = 0.1;
end;

% distance transform of foreground
Dst = bwdist(~img);

% pad volumes with zeros to avoid edge effects
img=padarray(img,[1 1 1]);
Dst=padarray(Dst,[1 1 1]);

% size
X=size(img,1);
Y=size(img,2);
Z=size(img,3);

% sphere as structuring element
[x,y,z] = ndgrid(-3:3);
sp = strel(sqrt(x.^2 + y.^2 + z.^2) <=3);

% start with detecting large objects (watershed)
cells = false(X,Y,Z);
cells(Dst>DIST_THR)=true;

% remove objects that are too small
cells = bwareaopen(cells,CELL_SIZE);

% grow cells to fill lacunae
if(max(cells(:)))       
    imd3=cells;
    df=sum(cells(:));
    while(df>=EXP_FRAC*sum(cells(:)))
        cells=imd3;
        imd3=imdilate(cells,sp) & (Dst>EXP_THR);%img;
        df=sum(imd3(:)-cells(:));
    end;    
    cells=imd3;    
end;

% remove objects that are too small
cells = bwareaopen(cells,CELL_SIZE);

% get rid of padded zeros
cells = cells(2:end-1,2:end-1,2:end-1);


