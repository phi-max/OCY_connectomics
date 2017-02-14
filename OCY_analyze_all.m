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

parfor i=1:length(path)       
    OCY_main(path{i},'*ch00*.tif');
    fprintf('worker %d done.\n',i);
end;

cd(startpath);

