% the str already have 200 ms baseline and 500 ms resp window, 700 in total
% (70 for the FR with 10 ms bins). To adjust that change the times in the net response.
clear all;
test = 'testName';
monName = 'mon';
baseline = 20; % for the 10 ms bins
latency = 5; % 50 ms latency
stimWin = 25; % 250 stim duration
bins = 10;
cond = 20;
outFolder = ('outFolder\');
dataDir = ('dataDir\');
files = dir([dataDir, '*.mat']);
numCells = length(files);
plotBaseline = 200;

strObj = [];
strMon = [];

netM = []; netO = [];% initialize net resp
netMaxM = []; netMaxO = []; % net normalized
netSWM = []; netSWO = []; % net resp in the stim window
mNetSWM = []; mNetSWO = []; % mean net resp in the stim window
netMaxSWM = []; netMaxSWO = []; % net normalized in the stim window
mNetMaxSWM = []; mNetMaxSWO = []; % mean net normalized in the stim window
% for the analyses you need the mean responses only, normalized or not

for k = 1:numCells
    str = load(files(k).name); % take a cell number
    strObj = [strObj; str.strAll.binMeanTrialFR(1:cond)];
    strMon = [strMon; str.strAll.binMeanTrialFR((cond+1):end)];
end

for i = 1:numCells % get the RW values for each object and each cell
    rowObj = strObj(i, :);
    rowMon = strMon(i, :);
    for ii = 1:cond
        netObj{ii} = rowObj{ii} - (mean(rowObj{ii}(11:baseline))); % net response 100 ms before onset
        netSWObj{ii} = netObj{ii}(1, (baseline+latency+1):(baseline+latency+stimWin)); % net resp win, add one for the zero problem
        mNetSWObj{ii} = mean(netSWObj{ii});
        netMon{ii} = rowMon{ii} - (mean(rowMon{ii}(11:baseline))); % net response
        netSWMon{ii} = netMon{ii}(1, (baseline+latency+1):(baseline+latency+stimWin)); % net resp win, add one for the zero problem
        mNetSWMon{ii} = mean(netSWMon{ii});     
    end
    maxValue{i} = (max(vertcat(netObj{:}, netMon{:}), [], 'all')); % get the max value from all net responses for that cell
    for ii = 1:cond
        netMaxObj{ii} = (netObj{ii})/(maxValue{i}); % normalized response
        netMaxSWObj{ii} = netMaxObj{ii}(1, (baseline+latency+1):(baseline+latency+stimWin)); % net normalized resp win
        mNetMaxSWObj{ii} = mean(netMaxSWObj{ii});
        netMaxMon{ii} = (netMon{ii})/(maxValue{i}); % normalized response
        netMaxSWMon{ii} = netMaxMon{ii}(1, (baseline+latency+1):(baseline+latency+stimWin)); % net normalized resp win
        mNetMaxSWMon{ii} = mean(netMaxSWMon{ii});
    end
    netM = [netM; netMon]; netO = [netO; netObj];
    netMaxM = [netMaxM; netMaxMon]; netMaxO = [netMaxO; netMaxObj]; 
    netSWM = [netSWM; netSWMon]; netSWO = [netSWO; netSWObj]; 
    mNetSWM = [mNetSWM; mNetSWMon]; mNetSWO = [mNetSWO; mNetSWObj];
    netMaxSWM = [netMaxSWM; netMaxSWMon]; netMaxSWO = [netMaxSWO; netMaxSWObj];
    mNetMaxSWM = [mNetMaxSWM; mNetMaxSWMon]; mNetMaxSWO = [mNetMaxSWO; mNetMaxSWObj];
end

% [p, h, stats] = signrank(cell2mat(mNetRWM(1, :)), cell2mat(mNetRWO(1, :))); %check cells one by one

meanM = mean(cell2mat(mNetSWM), 2);
meanO = mean(cell2mat(mNetSWO), 2);

selectIndO = (meanM - meanO)./(abs(meanM) + abs(meanO));
% save selectIndO.mat selectIndO;
% writematrix(selectIndO, 'selectIndOdin.xlsx');
% GET AVERAGE OF ALL OBJ AND MON AND CELLS

for i = 1:length(files) % [1:4 6 8:17 19 21:27 29 31:38 40] % only for the good cells; take mean of stimuli first!
    rowObj = strObj(i, (1:cond));
    stimObj = mean(vertcat(rowObj{:}), 1);
    meanObj{i} = stimObj;
    rowMon = strMon(i, (1:cond));
    stimMon = mean(vertcat(rowMon{:}), 1);
    meanMon{i} = stimMon;
end

meanObjRows = vertcat(meanObj{:});
meanMonRows = vertcat(meanMon{:});

ciObj = bootci(10000, @mean, meanObjRows);
uciObj = ciObj(2, :);
% uerObj = uciObj - meanAllObj{:}; !! ONLY FOR ERROR BARS
lciObj = ciObj(1, :);
% lerObj = meanAllObj{:} - lciObj;

ciMon = bootci(10000, @mean, meanMonRows);
uciMon = ciMon(2, :);
% uerMon = uciMon - meanAllMon{:};
lciMon = ciMon(1, :);
% lerMon = meanAllMon{:} - lciMon;

% PLOTTING
meanAllObj = {mean(vertcat(meanObj{:}))};
meanAllMon = {mean(vertcat(meanMon{:}))};


fig = figure(1); % set(gcf, 'Visible', 'on', 'Position', get(0, 'Screensize')); 
xx = 1:70; % set values of x-axis for the shading
x1 = 25; x2 = 50; x3 = 35; x4 = 40; x5 = 20; x6 = 45;% set the response window
hold all;
plot(meanAllMon{:}, 'b', 'LineWidth', 1.5);
plot(uciMon, 'LineStyle', 'none'); plot(lciMon, 'LineStyle', 'none');
patch([xx fliplr(xx)], [lciMon fliplr(uciMon)], 'b', 'LineStyle', 'none');
plot(meanAllObj{:}, 'g', 'LineStyle', '-', 'LineWidth', 1.5);
plot(uciObj, 'LineStyle', 'none'); plot(lciObj, 'LineStyle', 'none');
patch([xx fliplr(xx)], [lciObj fliplr(uciObj)], 'g', 'LineStyle', 'none');
set(gca, 'FontSize', 10, 'FontWeight','bold', 'XTick', 0:bins:length(meanAllMon{:})*bins, 'XTickLabel', ...
    -plotBaseline:bins*10:length(meanAllMon{:})*bins, 'YTick', 0:5:65, 'YLim', [0, 65]);
xlabel('Time', 'FontSize', 10, 'FontWeight','bold'), ylabel('Spikes/Second', 'FontSize', 10, 'FontWeight','bold');
plot([x1 x1], [0 55],':r', 'LineWidth', 0.5);
plot([x2 x2], [0 55],':r', 'LineWidth', 0.5);
plot([x5 x5], [0 10],':k', 'LineWidth', 1);
plot([x6 x6], [0 25],':k', 'LineWidth', 1);
plot([x3 x4], [55 55], 'k', 'LineWidth', 1);
text(35, 57, '***', 'FontSize', 20, 'FontWeight','bold');
hold off
alpha(.08);
mon = findobj('LineStyle', '-', 'Color', 'b'); obj = findobj('LineStyle', '-', 'Color', 'g');
pl = [mon(1) obj(1)]; legend(pl, 'Monkeys', 'Objects', 'FontSize', 10, 'FontWeight','bold');
h = suptitle([monName, ': ', num2str(length(find(~cellfun(@isempty,meanObj)))), ' Neurons']);
set(h, 'FontSize', 16, 'FontWeight', 'bold');

figName = fullfile(outFolder, strcat(test, 'figName', '.pdf'));
saveas(fig, figName);        