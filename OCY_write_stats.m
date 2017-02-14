function OCY_write_stats(d)

tree_prct = 100*cellfun('length',{d.t_nodes})./[d.N];
clus_prct = 100*cellfun('length',{d.c_nodes})./[d.N];
end_prct = 100*(cellfun('length',{d.e_nodes})-cellfun('length',{d.edg}))./[d.N];
S=([d.acc]./[d.acc_ER])./([d.asp_logic]./[d.asp_ER]);

res = cell(16,16);
res(:,1) = {'','M1','M2','S1','S2','M','S','all','M1-M2','M1-S1','M1-S2','M2-S1','M2-S2','S1-S2','p(1-2)','p(M-S)'};

d_ratio3 = reshape([d.d_ratio3],[9,20]);

res(:,2) = OCY_stats([d.lac_por],'void fraction');
res(:,3) = OCY_stats([d.can_len],'Ca.Dn');
res(:,4) = OCY_stats([d.d_can],'dist_{LC}');
res(:,5) = OCY_stats([d.d_net],'dist_net');
res(:,6) = OCY_stats(d_ratio3(7,:),'G');
res(:,7) = OCY_stats([d.N]./1E5,'N/V');
res(:,8) = OCY_stats([d.mean_deg],'<k>');
res(:,9) = OCY_stats([d.exp_len],'len. dist.');
res(:,10) = OCY_stats([d.exp_deg],'deg. dist.');
res(:,11) = OCY_stats(tree_prct,'% tree nodes');
res(:,12) = OCY_stats(clus_prct,'% cluster nodes');
res(:,13) = OCY_stats(end_prct,'% end points');
res(:,14) = OCY_stats([d.asp],'<ASP>');
res(:,15) = OCY_stats([d.acc],'<CC>');
res(:,16) = OCY_stats(S,'S');

xlswrite('stats.xls',res);