clear all;
test = 'testName';
monName = 'mon';
baseline = 20;
latency = 5; % 50 ms latency
stimWin = 25; % 250 stim duration
outFolder = ('outFolder\');
dataDir = ('dataDir\');
files = dir([dataDir, '*.mat']);
cellNum = length(files);

normR = []; strMNa = []; strMUa = []; strMN = []; strMU = [];

for k = 1:cellNum
    load(files(k).name);
    resp = strAll.binMeanTrialFR;
    allResp = strAll.binAllTrialsFR;
    for ii = 1:length(allResp)
        for s = 1:size(allResp{ii}, 1)
            trialResp = allResp{ii}(s, :);
            netRtr{s} = trialResp - (mean(trialResp(11:baseline))); % net response
            netRWRtr{s} = netRtr{s}(1, (baseline+latency+1):(baseline+latency+stimWin)); % net resp win, add one for the zero problem
            mNetRWRtr{s} = mean(netRWRtr{s});
        end
        netR{ii} = netRtr;
        netRWR{ii} = netRWRtr;
        mNetRWR{ii} = mNetRWRtr;
        
    end
    for u = 1:length(mNetRWR)
        trR = cell2mat(mNetRWR{u})';
        normR = [normR, trR];
    end
    
    dnormR = [normR; normR];
    trNum = 4;
    for c = 1:size(normR, 1)
        meanTr = mean(dnormR(c:trNum, :));
        sortedRN = sort(meanTr(:, 21:end), 'descend');
        [~, idx] = sort(meanTr(:, 21:end), 'descend');
        normRN = dnormR(trNum+1, 21:end);
        normRU = dnormR(trNum+1, 1:20);
        sortedRN = normRN(:, idx);
        sortedRU = normRU(:, idx);
        strMNa = [strMNa; sortedRN]; strMUa = [strMUa; sortedRU];
        trNum = trNum+1;
    end
    nRank = mean(strMNa, 1);  unRank = mean(strMUa, 1);
    strMN = [strMN; nRank]; strMU = [strMU; unRank];
    normR = []; dnormR = []; strMNa = []; strMUa = [];
end
    
natRank = mean(strMN, 1);  unRank = mean(strMU, 1);
bootStr = [strMN, strMU];
ci = bootci(1000, {@mean, bootStr}, 'Type', 'per');
natCi = ci(:, 1:20); unCi = ci(:, 21:end);
uNci = natCi(2, :); uUci = unCi(2, :);
uerN = uNci - natRank; uerU = uUci - unRank;
lNci = natCi(1, :); lUci = unCi(1, :);
lerN = natRank - lNci; lerU = unRank - lUci;

fig = figure;
xx = 1:20;
hold all;
plot(natRank, 'b', 'LineWidth', 1.5);
plot(uNci, 'LineStyle', 'none'); plot(lNci, 'LineStyle', 'none');
patch([xx fliplr(xx)], [lNci fliplr(uNci)], 'b', 'LineStyle', 'none');

plot(unRank, 'r', 'LineWidth', 1.5);
plot(uUci, 'LineStyle', 'none'); plot(lUci, 'LineStyle', 'none');
patch([xx fliplr(xx)], [lUci fliplr(uUci)], 'r', 'LineStyle', 'none');

set(gca, 'FontSize', 10, 'fontweight', 'bold', 'xlim', [0.5, 20.5], 'xtick', [1:20], 'YLim', [0, 40]);
xlabel('Stimulus rank'), ylabel('Net response(spikes/second)'), title('M2', 'FontSize', 12);
hold off
alpha(.08);
mn = findobj('LineStyle', '-', 'Color', 'b'); mu = findobj('LineStyle', '-', 'Color', 'r');
pl = [mn(1) mu(1)]; legend(pl, 'MN', 'MU', 'FontSize', 10, 'FontWeight','bold'); 
figName = fullfile(outFolder, strcat(monName, test, 'name', '.pdf'));
saveas(fig, figName);

        