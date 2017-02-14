function bin = OCY_fill_voids(bin,S)
% OCY_fill_voids - morphologically filter binary volume

% remove all objects smaller than S voxels
bin = bwareaopen(bin,S);

% close image to remove holes
A6=zeros(3,3,3);
A6([5,11,13,14,15,17,23])=1;
bin = imclose(bin,A6);

% put a box of 1's around the image to close cells
bin = padarray(bin,[1 1 1],1);

% remove isolated background components (e.g. holes in border cells)
bin = ~bwareaopen(~bin,round(0.1*sum(~bin(:))),6);

% remove box around volume
bin = bin(2:end-1,2:end-1,2:end-1);
