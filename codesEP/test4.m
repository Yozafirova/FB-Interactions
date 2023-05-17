clear all;
load('pooledData.mat')

bootStr = [nB.FBN, nB.FBN8, nB.FBN16, nB.MN, nB.MN8, nB.MN16, nB.FBU, nB.FBU8, nB.FBU16, nB.MU, nB.MU8, nB.MU16];
ci = bootci(1000, {@mean, bootStr}, 'Type', 'per');
uci = ci(2, :); lci = ci(1, :);
plotMeans = mean(bootStr, 1);
uer = uci - plotMeans; ler = plotMeans - lci; 
sumN = plotMeans(:, 1:3); mn = plotMeans(:, 4:6); sumU = plotMeans(:, 7:9); mu = plotMeans(:, 10:12);
sumNuer = uer(:, 1:3); mnuer = uer(:, 4:6); sumUuer = uer(:, 7:9); muuer = uer(:, 10:12);
sumNler = ler(:, 1:3); mnler = ler(:, 4:6); sumUler = ler(:, 7:9); muler = ler(:, 10:12);

fig1 = figure(1);
xx = 1:3;
subplot(1,2,1);
hold all;
errorbar(xx, sumN, sumNler, sumNuer, 'LineStyle', ':', 'Color', 'b');
scatter(xx, sumN, 150, 'o', 'b', 'filled', 'MarkerEdgeColor', 'b', 'MarkerFaceColor', 'b', 'MarkerFaceAlpha', 0.6);
% plot(xx, nLR,'-o', 'LineWidth', 1.5, 'Color', 'b', 'MarkerEdgeColor', 'b', 'MarkerFaceColor', 'b'); 
% plot(uNci, 'LineStyle', 'none'); plot(lNci, 'LineStyle', 'none');
% patch([xx fliplr(xx)], [lNci fliplr(uNci)], 'b', 'LineStyle', 'none');
errorbar(xx, sumU, sumUler, sumUuer, 'LineStyle', ':', 'Color', 'r');
scatter(xx, sumU, 150, 'o', 'r', 'filled', 'MarkerEdgeColor', 'r', 'MarkerFaceColor', 'r', 'MarkerFaceAlpha', 0.6)
set(gca, 'FontSize', 10, 'fontweight', 'bold', 'xlim', [0.5, 3.5], 'xtick', [1:3], 'YLim', [10, 55], 'ytick', [10:5:50]);
xticklabels({'0o', '0.2o', '0.4o'}); xlabel('F+B'), ylabel('spikes/second');
hold off

subplot(1,2,2);
hold all;
errorbar(xx, mn, mnler, mnuer, 'LineStyle', ':', 'Color', 'b');
scatter(xx, mn, 150, 'o', 'b', 'filled', 'MarkerEdgeColor', 'b', 'MarkerFaceColor', 'b', 'MarkerFaceAlpha', 0.6);
% plot(xx, nLR,'-o', 'LineWidth', 1.5, 'Color', 'b', 'MarkerEdgeColor', 'b', 'MarkerFaceColor', 'b'); 
% plot(uNci, 'LineStyle', 'none'); plot(lNci, 'LineStyle', 'none');
% patch([xx fliplr(xx)], [lNci fliplr(uNci)], 'b', 'LineStyle', 'none');
errorbar(xx, mu, muler, mnuer, 'LineStyle', ':', 'Color', 'r');
scatter(xx, mu, 150, 'o', 'r', 'filled', 'MarkerEdgeColor', 'r', 'MarkerFaceColor', 'r', 'MarkerFaceAlpha', 0.6)
set(gca, 'FontSize', 10, 'fontweight', 'bold', 'xlim', [0.5, 3.5], 'xtick', [1:3], 'YLim', [10, 55], 'ytick', [10:5:50]);
xticklabels({'0o', '0.2o', '0.4o'}); xlabel('M');
hold off
mnl = findobj('MarkerFaceColor', 'b'); mul = findobj('MarkerFaceColor', 'r');
pl = [mnl(1) mul(1)]; legend(pl, 'N', 'U', 'FontSize', 10, 'FontWeight','bold');

% saveas(fig1, 'test4.pdf');

