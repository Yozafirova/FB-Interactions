clear all;
addpath ('\dataPath\'); 
% load('pooledMCci.mat');
load('pooledFCci.mat');

% indC = [nB.PlusN_FC, nB.PlusU_FC]; indI = [nB.PlusN_FI, nB.PlusU_FI];
indC = [nB.PlusN_BC, nB.PlusU_BC]; indI = [nB.PlusN_BI, nB.PlusU_BI];

ch = char(nB.vp);
d = find(ch == 'd'); s = find(ch == 's');
indDc = indC(d, :); indDi = indI(d, :); 
indSc = indC(s, :); indSi = indI(s, :);

% contra
ciCd = bootci(1000, {@mean, indDc}, 'Type', 'per');
ciCs = bootci(1000, {@mean, indSc}, 'Type', 'per');
ciC = [ciCd(:, 1), ciCs(:, 1), ciCd(:, 2), ciCs(:, 2)];
nCci = ciC(:, 1:2); 
uCci = ciC(:, 3:4);
uNcic = nCci(2, :); uUcic = uCci(2, :); 
lNcic = nCci(1, :); lUcic = uCci(1, :); 
% ipsilat
ciId = bootci(1000, {@mean, indDi}, 'Type', 'per');
ciIs = bootci(1000, {@mean, indSi}, 'Type', 'per');
ciI = [ciId(:, 1), ciIs(:, 1), ciId(:, 2), ciIs(:, 2)];
nIci = ciI(:, 1:2); 
uIci = ciI(:, 3:4);
uNcii = nIci(2, :); uUcii = uIci(2, :); 
lNcii = nIci(1, :); lUcii = uIci(1, :); 

% nLR = [mean(nB.PlusN_FC), mean(nB.PlusN_FI), mean(nB.PlusU_FC), mean(nB.PlusU_FI)];
nLRc = [mean(indDc(:, 1),1), mean(indSc(:, 1),1)]; uLRc = [mean(indDc(:, 2),1), mean(indSc(:, 2),1)];
nLRi = [mean(indDi(:, 1),1), mean(indSi(:, 1),1)]; uLRi = [mean(indDi(:, 2),1), mean(indSi(:, 2),1)];

uerNc = uNcic - nLRc; lerNc = nLRc - lNcic;
uerUc = uUcic - uLRc; lerUc = uLRc - lUcic;

uerNi = uNcii - nLRi; lerNi = nLRi - lNcii;
uerUi = uUcii - uLRi; lerUi = uLRi - lUcii;

%contra
fig1 = figure; fig1.Position = [300 300 300 550];
xx = 1:2;
hold all;
errorbar(xx, nLRc, lerNc, uerNc, 'LineStyle', ':', 'Color', 'b');
scatter(xx, nLRc, 150, 'o', 'b', 'filled', 'MarkerEdgeColor', 'b', 'MarkerFaceColor', 'b', 'MarkerFaceAlpha', 0.6);
errorbar(xx, uLRc, lerUc, uerUc, 'LineStyle', ':', 'Color', 'r');
scatter(xx, uLRc, 150, 'o', 'r', 'filled', 'MarkerEdgeColor', 'r', 'MarkerFaceColor', 'r', 'MarkerFaceAlpha', 0.6)

set(gca, 'FontSize', 10, 'fontweight', 'bold', 'xlim', [0.5, 2.5], 'xtick', [1:2], 'YLim', [-0.5, 0.5], 'ytick', [-0.5:0.1:0.5]);
xticklabels({'D', 'S'}); xlabel('CONTRA'), ylabel('Integration Index'), title('FC', 'FontSize', 12);
yline(0, '--')
hold off
mn = findobj('MarkerFaceColor', 'b'); mu = findobj('MarkerFaceColor', 'r');
pl = [mn(1) mu(1)]; legend(pl, 'N', 'U', 'FontSize', 10, 'FontWeight','bold');

% saveas(gcf, 'FC_IpsiResp.pdf');

fig2 = figure; fig2.Position = [300 300 300 550];
xx = 1:2;
hold all;
errorbar(xx, nLRi, lerNi, uerNi, 'LineStyle', ':', 'Color', 'b');
scatter(xx, nLRi, 150, 'o', 'b', 'filled', 'MarkerEdgeColor', 'b', 'MarkerFaceColor', 'b', 'MarkerFaceAlpha', 0.6);
errorbar(xx, uLRi, lerUi, uerUi, 'LineStyle', ':', 'Color', 'r');
scatter(xx, uLRi, 150, 'o', 'r', 'filled', 'MarkerEdgeColor', 'r', 'MarkerFaceColor', 'r', 'MarkerFaceAlpha', 0.6)

set(gca, 'FontSize', 10, 'fontweight', 'bold', 'xlim', [0.5, 2.5], 'xtick', [1:2], 'YLim', [-0.5, 0.5], 'ytick', [-0.5:0.1:0.5]);
xticklabels({'D', 'S'}); xlabel('IPSI'), ylabel('Integration Index'), title('FC', 'FontSize', 12);
yline(0, '--')
hold off
mn = findobj('MarkerFaceColor', 'b'); mu = findobj('MarkerFaceColor', 'r');
pl = [mn(1) mu(1)]; legend(pl, 'N', 'U', 'FontSize', 10, 'FontWeight','bold');

% saveas(gcf, 'FC_IpsiResp.pdf');

% pool C and I
ind = [mean([nB.PlusN_BC nB.PlusN_BI], 2) mean([nB.PlusU_BC nB.PlusU_BI], 2)];
indD = ind(d, :); indS = ind(s, :); 

ciD = bootci(1000, {@mean, indD}, 'Type', 'per');
ciS = bootci(1000, {@mean, indS}, 'Type', 'per');

ci = [ciD(:, 1), ciS(:, 1), ciD(:, 2), ciS(:, 2)];
nCi = ci(:, 1:2); 
uCi = ci(:, 3:4);
uNci = nCi(2, :); uUci = uCi(2, :); 
lNci = nCi(1, :); lUci = uCi(1, :); 

nLR = [mean(indD(:, 1),1), mean(indS(:, 1),1)]; uLR = [mean(indD(:, 2),1), mean(indS(:, 2),1)];
uerN = uNci - nLR; lerN = nLR - lNci;
uerU = uUci - uLR; lerU = uLR - lUci;

fig3 = figure;
xx = 1:2;
hold all;
errorbar(xx, nLR, lerN, uerN, 'LineStyle', ':', 'Color', 'b');
scatter(xx, nLR, 150, 'o', 'b', 'filled', 'MarkerEdgeColor', 'b', 'MarkerFaceColor', 'b', 'MarkerFaceAlpha', 0.6);
errorbar(xx, uLR, lerU, uerU, 'LineStyle', ':', 'Color', 'r');
scatter(xx, uLR, 150, 'o', 'r', 'filled', 'MarkerEdgeColor', 'r', 'MarkerFaceColor', 'r', 'MarkerFaceAlpha', 0.6)

set(gca, 'FontSize', 10, 'fontweight', 'bold', 'xlim', [0.5, 2.5], 'xtick', [1:2], 'YLim', [-0.4, 0.2], 'ytick', [-0.4:0.1:0.2]);
xticklabels({'D', 'S'}); ylabel('Integration Index'), title('FC', 'FontSize', 12);
yline(0, '--')
hold off
mn = findobj('MarkerFaceColor', 'b'); mu = findobj('MarkerFaceColor', 'r');
pl = [mn(1) mu(1)]; legend(pl, 'N', 'U', 'FontSize', 10, 'FontWeight','bold');

% saveas(gcf, 'FC_PooledResp.pdf');




