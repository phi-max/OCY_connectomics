function res = OCY_stats(d,label)

m = mean(reshape(d,[5,4]));
se = std(reshape(d,[5,4]))./sqrt(5);

m2 = mean(reshape(d,[10,2]));
se2 = std(reshape(d,[10,2]))./sqrt(10);

m3 = mean(d);
se3 = std(d)./sqrt(20);

m = [m m2 m3];
se = [se se2 se3];
ci = 1.96*se;

res = cell(1,16);
res{1} = label;


[~,~,stats] = anova1(reshape(d,[5 4]),[],'off');
[results,means] = multcompare(stats,'CType','bonferroni');
pvals = results(:,end);

[p,tbl,stats] = anova2(reshape(d,[10 2]),2,'off');

pvals = [pvals' p(2) p(1)];

for i=1:7
    res{i+1} = sprintf('%4.2f ± %4.2f',m(i),ci(i));
end;

for i=1:8
    res{i+8} = sprintf('%4.2g',pvals(i));
end;

