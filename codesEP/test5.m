clear all;
load('pooledData.mat');

bootStr = [nB.FBN, nB.BONs, nB.OFNs, nB.ONs, nB.MN, nB.BON, nB.OFN, nB.ON, nB.FBU, nB.BOUs, nB.OFUs, nB.OUs, nB.MU, nB.BOU, nB.OFU, nB.OU];
ci = bootci(1000, {@mean, bootStr}, 'Type', 'per');
uci = ci(2, :); lci = ci(1, :);
plotMeans = mean(bootStr, 1);
uer = uci - plotMeans; ler = plotMeans - lci; 
sumN = plotMeans(:, 1:4); mn = plotMeans(:, 5:8); sumU = plotMeans(:, 9:12); mu = plotMeans(:, 13:16);
sumNuer = uer(:, 1:4); mnuer = uer(:, 5:8); sumUuer = uer(:, 9:12); muuer = uer(:, 13:16);
sumNler = ler(:, 1:4); mnler = ler(:, 5:8); sumUler = ler(:, 9:12); muler = ler(:, 13:16);

fig1 = figure(1);
xx = 1:4;
subplot(1,2,1);
hold all;
errorbar(xx, sumN, sumNler, sumNuer, 'LineStyle', ':', 'Color', 'b');
scatter(xx, sumN, 150, 'o', 'b', 'filled', 'MarkerEdgeColor', 'b', 'MarkerFaceColor', 'b', 'MarkerFaceAlpha', 0.6);
errorbar(xx, sumU, sumUler, sumUuer, 'LineStyle', ':', 'Color', 'r');
scatter(xx, sumU, 150, 'o', 'r', 'filled', 'MarkerEdgeColor', 'r', 'MarkerFaceColor', 'r', 'MarkerFaceAlpha', 0.6)
set(gca, 'FontSize', 10, 'fontweight', 'bold', 'xlim', [0.5, 4.5], 'xtick', [1:4], 'YLim', [0, 45], 'ytick', [0:5:45]);
xticklabels({'M', 'B&O', 'O&F', 'O&O'}); xlabel('SUM'), ylabel('spikes/second');
hold off

subplot(1,2,2);
hold all;
errorbar(xx, mn, mnler, mnuer, 'LineStyle', ':', 'Color', 'b');
scatter(xx, mn, 150, 'o', 'b', 'filled', 'MarkerEdgeColor', 'b', 'MarkerFaceColor', 'b', 'MarkerFaceAlpha', 0.6);
errorbar(xx, mu, muler, mnuer, 'LineStyle', ':', 'Color', 'r');
scatter(xx, mu, 150, 'o', 'r', 'filled', 'MarkerEdgeColor', 'r', 'MarkerFaceColor', 'r', 'MarkerFaceAlpha', 0.6)
set(gca, 'FontSize', 10, 'fontweight', 'bold', 'xlim', [0.5, 4.5], 'xtick', [1:4], 'YLim', [0, 45], 'ytick', [0:5:45]);
xticklabels({'M', 'B&O', 'O&F', 'O&O'}); xlabel('COMPOSITE');
hold off
mnl = findobj('MarkerFaceColor', 'b'); mul = findobj('MarkerFaceColor', 'r');
pl = [mnl(1) mul(1)]; legend(pl, 'N', 'U', 'FontSize', 10, 'FontWeight','bold');

% saveas(fig1, 'test5.pdf');

