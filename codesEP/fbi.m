clear all;
load('fbi.mat');
load('PooledAll.mat');
outFolder = ('\outFolder\');
mn = nB.MN; mu = nB.MU; fbn = nB.FBN; fbu = nB.FBU; ind = nB.Plus; % take m, sum and index values 
indO = ind(105:end, :); indN = ind(1:104, :); % index M1 and M2
fbsO = fbs(105:end, :); fbsN = fbs(1:104, :); % fbs M1 and M2

% find f, b and f-b rows
fbsf=find(fbs>0.33); fbsb=find(fbs<-0.33); 
fbsm1 = find(fbs<0.33); fbsm2 = find(fbs>-0.33); fbsm = intersect(fbsm1, fbsm2); % rows of the f, b, and f-b cells
ifn = fbsf(fbsf<105); ibn = fbsb(fbsb<105); imn = fbsm(fbsm<105); % f, b, m rows M2
ifo = fbsf(fbsf>104); ibo = fbsb(fbsb>104); imo = fbsm(fbsm>104); % f, b, m rows M1

fbsF = fbs(fbsf, :); fbsB = fbs(fbsb, :); fbsM = fbs(fbsm, :); % all f, b, m fbs index
fbsFN = fbs(ifn, :); fbsBN = fbs(ibn, :); fbsMN = fbs(imn, :); % f, b, m fbs index M2
fbsFO = fbs(ifo, :); fbsBO = fbs(ibo, :); fbsMO = fbs(imo, :); % f, b, m fbs index M1
indF = ind(fbsf, :); indB = ind(fbsb, :); indM = ind(fbsm, :); % all f, b, m index
indFN = ind(ifn, :); indBN = ind(ibn, :); indMN = ind(imn, :); % f, b, m index M2
indFO = ind(ifo, :); indBO = ind(ibo, :); indMO = ind(imo, :); % f, b, m index M1

% for the scatter!
indMed = [median(indB), median(indM), median(indF)]; % take the medians
fbsMed = [median(fbsB), median(fbsM), median(fbsF)];
colN = [0.8, 0.6, 1; 0.6, 0.1, 0.9; 0.4, 0, 0.6]; % choose colors
colO = [0.5, 0.8, 0.9; 0.3, 0.6, 0.8; 0, 0.3, 0.7];

% bootstrap
medFbsF = []; medFbsB = []; medFbsM = [];
medIndF = []; medIndB = []; medIndM = [];
bootF = [fbsF, indF]; bootB = [fbsB, indB]; bootM = [fbsM, indM];
for n = 1:1000 % resample by column with replacement 1000 times
    dataF = datasample(bootF, length(bootF));
    medFbsf = median(dataF(:, 1)); medIndf = median(dataF(:, 2));
    medFbsF = [medFbsF; medFbsf]; medIndF = [medIndF; medIndf];
    dataB = datasample(bootB, length(bootB));
    medFbsb = median(dataB(:, 1)); medIndb = median(dataB(:, 2));
    medFbsB = [medFbsB; medFbsb]; medIndB = [medIndB; medIndb];
    dataM = datasample(bootM, length(bootM));
    medFbsm = median(dataM(:, 1)); medIndm = median(dataM(:, 2));
    medFbsM = [medFbsM; medFbsm]; medIndM = [medIndM; medIndm];
end

uCiFbs = [ciB(2, 1), ciM(2, 1), ciF(2, 1)]; lCiFbs = [ciB(1, 1), ciM(1, 1), ciF(1, 1)];
uCiInd = [ciB(2, 2), ciM(2, 2), ciF(2, 2)]; lCiInd = [ciB(1, 2), ciM(1, 2), ciF(1, 2)];
uErFbs = uCiFbs - fbsMed; uErInd = uCiInd - indMed; % take confidence intervals
lErFbs = fbsMed - lCiFbs; lErInd = indMed - lCiInd;

% plot scatter
fig1 = figure(1);
xx = 1:3;
x = [-0.33 0.33];
pointsize = 50; 
hold all;
scatter(fbsBN, indBN, pointsize, colN(1, :), 'filled');
scatter(fbsMN, indMN, pointsize, colN(2, :), 'filled');
scatter(fbsFN, indFN, pointsize, colN(3, :), 'filled', 'MarkerFaceColor', colN(3, :));
scatter(fbsBO, indBO, pointsize, colO(1, :), 'filled');
scatter(fbsMO, indMO, pointsize, colO(2, :), 'filled');
scatter(fbsFO, indFO, pointsize, colO(3, :), 'filled','MarkerFaceColor', colO(3, :));

errorbar(fbsMed, indMed, lErFbs, uErFbs, 'horizontal', 'k', 'LineStyle', 'none', 'LineWidth', 1);
errorbar(fbsMed, indMed, lErInd, uErInd, 'vertical', 'k', 'LineStyle', 'none', 'LineWidth', 1);

xline(x(1), '--'); xline(x(2), '--');
set(gca, 'ylim', [-1, 2.5])
yline(0, ':');
hold off
alpha(.5);
mN = findobj('MarkerFaceColor', colN(3, :)); 
mO = findobj('MarkerFaceColor', colO(3, :)); 
pl = [mO(1) mN(1)]; legend(pl, 'M1', 'M2', 'FontSize', 10, 'FontWeight','bold', 'location', 'northwest');
xlabel('FBI', 'FontWeight','bold'), ylabel('Integration Index N-U', 'FontWeight','bold');
figName1 = fullfile(outFolder, strcat('Scatter.pdf'));
saveas(fig1, figName1);

%for the sums
mnf = mn(fbsf, :); mnb = mn(fbsb, :); mnm = mn(fbsm, :);
muf = mu(fbsf, :); mub = mu(fbsb, :); mum = mu(fbsm, :);
fbnf = fbn(fbsf, :); fbnb = fbn(fbsb, :); fbnm = fbn(fbsm, :);
fbuf = fbu(fbsf, :); fbub = fbu(fbsb, :); fbum = fbu(fbsm, :);
bootFs = [fbnf, fbuf, mnf, muf]; bootBs = [fbnb, fbub, mnb, mub]; bootMs = [fbnm, fbum, mnm, mum];


ciFs = bootci(1000, {@mean, bootFs}, 'Type', 'per');
ciBs = bootci(1000, {@mean, bootBs}, 'Type', 'per');
ciMs = bootci(1000, {@mean, bootMs}, 'Type', 'per');

uCis = [ciBs(2, :), ciMs(2, :), ciFs(2, :)];
lCis = [ciBs(1, :), ciMs(1, :), ciFs(1, :)];
barMeans = [mean(bootBs, 1), mean(bootMs, 1), mean(bootFs, 1)];
uer = uCis - barMeans; ler = barMeans - lCis;
% add zero :)
barMeans = [barMeans(1), barMeans(2), 0, barMeans(3), barMeans(4), barMeans(5), barMeans(6), ...
    0, barMeans(7), barMeans(8), barMeans(9), barMeans(10), 0,  barMeans(11), barMeans(12)];
uer = [uer(1), uer(2), 0, uer(3), uer(4), uer(5), uer(6), 0, uer(7), uer(8), uer(9), uer(10), 0, uer(11), uer(12)];
ler = [ler(1), ler(2), 0, ler(3), ler(4), ler(5), ler(6), 0, ler(7), ler(8), ler(9), ler(10), 0, ler(11), ler(12)];

% bar plot
fig2 = figure(2);
xx = 1:5;
subplot(1, 3, 1);
hold all
b1 = bar(xx(1), barMeans(1)); set(b1, 'FaceColor', 'b', 'FaceAlpha',0.6);
hold on;
b2 = bar(xx(2), barMeans(2)); set(b2, 'FaceColor', 'r', 'FaceAlpha',0.6);
b3 = bar(xx(3), 0);
b4 = bar(xx(4), barMeans(4)); set(b4, 'FaceColor', 'b', 'FaceAlpha',0.6);
b5 = bar(xx(5), barMeans(5)); set(b5, 'FaceColor', 'r', 'FaceAlpha',0.6);
errorbar(xx, barMeans(1:5), ler(1:5), uer(1:5), 'o', 'LineStyle', 'none', 'Color', 'k', 'LineWidth', 1);
set(gca, 'xtick', [1:5], 'yLim', [0, 45], 'yTick', [0:5:45], 'xLim', [0, 6], 'xticklabel', {'F+B', '', '', 'M', ''}, 'FontSize', 14, 'fontweight', 'bold'); 
ylabel('Spikes/Second', 'FontSize', 14, 'fontweight', 'bold'); 
hold off;
title('B');
mNat = findobj('FaceColor', 'b'); mUn = findobj('FaceColor', 'r');
pl = [mNat(1) mUn(1)]; legend(pl, 'N', 'U', 'FontSize', 10, 'FontWeight','bold');

subplot(1, 3, 2);
hold all
b1 = bar(xx(1), barMeans(6)); set(b1, 'FaceColor', 'b', 'FaceAlpha',0.6);
hold on;
b2 = bar(xx(2), barMeans(7)); set(b2, 'FaceColor', 'r', 'FaceAlpha',0.6);
b3 = bar(xx(3), 0);
b4 = bar(xx(4), barMeans(9)); set(b4, 'FaceColor', 'b', 'FaceAlpha',0.6);
b5 = bar(xx(5), barMeans(10)); set(b5, 'FaceColor', 'r', 'FaceAlpha',0.6);
errorbar(xx, barMeans(6:10), ler(6:10), uer(6:10), 'o', 'LineStyle', 'none', 'Color', 'k', 'LineWidth', 1);
set(gca, 'xtick', [1:5], 'yLim', [0, 65], 'yTick', [0:5:65], 'xLim', [0, 6], 'xticklabel', {'F+B', '', '', 'M', ''}, 'FontSize', 14, 'fontweight', 'bold'); 
ylabel('Spikes/Second', 'FontSize', 14, 'fontweight', 'bold'); 
hold off;
title('B-F');
mNat = findobj('FaceColor', 'b'); mUn = findobj('FaceColor', 'r');
pl = [mNat(1) mUn(1)]; legend(pl, 'N', 'U', 'FontSize', 10, 'FontWeight','bold');

subplot(1, 3, 3);
hold all
b1 = bar(xx(1), barMeans(11)); set(b1, 'FaceColor', 'b', 'FaceAlpha',0.6);
hold on;
b2 = bar(xx(2), barMeans(12)); set(b2, 'FaceColor', 'r', 'FaceAlpha',0.6);
b3 = bar(xx(3), 0);
b4 = bar(xx(4), barMeans(14)); set(b4, 'FaceColor', 'b', 'FaceAlpha',0.6);
b5 = bar(xx(5), barMeans(15)); set(b5, 'FaceColor', 'r', 'FaceAlpha',0.6);
errorbar(xx, barMeans(11:15), ler(11:15), uer(11:15), 'o', 'LineStyle', 'none', 'Color', 'k', 'LineWidth', 1);
set(gca, 'xtick', [1:5], 'yLim', [0, 45], 'yTick', [0:5:45], 'xLim', [0, 6], 'xticklabel', {'F+B', '', '', 'M', ''}, 'FontSize', 14, 'fontweight', 'bold'); 
ylabel('Spikes/Second', 'FontSize', 14, 'fontweight', 'bold'); 
hold off;
title('F');
mNat = findobj('FaceColor', 'b'); mUn = findobj('FaceColor', 'r');
pl = [mNat(1) mUn(1)]; legend(pl, 'N', 'U', 'FontSize', 10, 'FontWeight','bold');
orient(fig2, 'landscape');

figName2 = fullfile(outFolder, strcat('Bars.pdf'));
saveas(fig2, figName2);
