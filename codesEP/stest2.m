clear all;
test = 'testName';
monName = 'mon';
baseline = 20;
plotBaseline = 200; % you need that for the plotting
latency = 5; % 50 ms latency
stimWin = 25; % 250 stim duration
bins = 10;
cond = 20; 
outFolder = ('outFolder\');
dataDir = ('dataDir\');
files = dir([dataDir, '*.mat']);
cellNum = length(files);

strMU = [];
strMN = [];

netMN = []; netMU = [];% initialize
netMaxMN = []; netMaxMU = []; 
netRWMN = []; netRWMU = []; 
mNetRWMN = []; mNetRWMU = [];
netMaxRWMN = []; netMaxRWMU = [];
mNetMaxRWMN = []; mNetMaxRWMU = []; 


for k = 1:cellNum
    str = load(files(k).name); % take a cell number
    strMU = [strMU; str.strAll.binMeanTrialFR(1:cond)];
    strMN = [strMN; str.strAll.binMeanTrialFR((cond+1):end)];
end

% FOR THE STATS!!

for i = 1:cellNum % 1:numCells % get the RW values for each object and each cell
    rowN = strMN(i, :);
    rowU = strMU(i, :);
    for ii = 1:cond % take net responses per stimulus
        netR{ii} = rowN{ii} - (mean(rowN{ii}(11:baseline))); % net response
        netRWR{ii} = netR{ii}(1, (baseline+latency+1):(baseline+latency+stimWin)); % net resp win, add one for the zero problem
        mNetRWR{ii} = mean(netRWR{ii});
        netI{ii} = rowU{ii} - (mean(rowU{ii}(11:baseline))); % net response
        netRWI{ii} = netI{ii}(1, (baseline+latency+1):(baseline+latency+stimWin)); % net resp win, add one for the zero problem
        mNetRWI{ii} = mean(netRWI{ii});
    end
    maxValue{i} = (max(vertcat(netR{:}, netI{:}), [], 'all')); % get the max value from all net responses for that cell
    for ii = 1:cond % take normalized net responses per stimulus
        netMaxR{ii} = netR{ii}/maxValue{i}; % normalized response
        netMaxRWR{ii} = netMaxR{ii}(1, (baseline+latency+1):(baseline+latency+stimWin)); % net normalized resp win
        mNetMaxRWR{ii} = mean(netMaxRWR{ii});
        netMaxI{ii} = netI{ii}/maxValue{i};
        netMaxRWI{ii} = netMaxI{ii}(1, (baseline+latency+1):(baseline+latency+stimWin)); % net normalized resp win
        mNetMaxRWI{ii} = mean(netMaxRWI{ii});
    end
    netMN = [netMN; netR]; netMU = [netMU; netI];% initialize
    netMaxMN = [netMaxMN; netMaxR]; netMaxMU = [netMaxMU; netMaxI]; 
    netRWMN = [netRWMN; netRWR]; netRWMU = [netRWMU; netRWI]; 
    mNetRWMN = [mNetRWMN; mNetRWR]; mNetRWMU = [mNetRWMU; mNetRWI];
    netMaxRWMN = [netMaxRWMN; netMaxRWR]; netMaxRWMU = [netMaxRWMU; netMaxRWI];
    mNetMaxRWMN = [mNetMaxRWMN; mNetMaxRWR]; mNetMaxRWMU = [mNetMaxRWMU; mNetMaxRWI];
end

meanMN = mean(cell2mat(mNetRWMN), 2);
meanMU = mean(cell2mat(mNetRWMU), 2);


for i = 1:cellNum
    rowN = strMN(i, :);
    stimR = mean(vertcat(rowN{:}), 1);
    meanR{i} = stimR;
    rowU = strMU(i, :);
    stimI = mean(vertcat(rowU{:}), 1);
    meanI{i} = stimI;
end

meanMNRows = vertcat(meanR{:});
meanMURows = vertcat(meanI{:});

ciMN = bootci(10000, @mean, meanMNRows);
uciMN = ciMN(2, :);
% uerObj = uciObj - meanAllObj{:}; !! ONLY FOR ERROR BARS
lciMN = ciMN(1, :);
% lerObj = meanAllObj{:} - lciObj;

ciMU = bootci(10000, @mean, meanMURows);
uciMU = ciMU(2, :);
% uerMon = uciMon - meanAllMon{:};
lciMU = ciMU(1, :);
% lerMon = meanAllMon{:} - lciMon;

% FOR THE PLOTTING!!

meanAllMR = {mean(vertcat(meanR{:}))};
meanAllMI = {mean(vertcat(meanI{:}))};


% PLOT
fig = figure(1); % set(gcf, 'Visible', 'on', 'Position', get(0, 'Screensize')); 
xx = 1:70; % set values of x-axis for the shading
x1 = 25; x2 = 50; x3 = 35; x4 = 40; x5 = 20; x6 = 45;% set the response window
hold all;
plot(meanAllMR{:}, 'b', 'LineWidth', 1.5);
plot(uciMN, 'LineStyle', 'none'); plot(lciMN, 'LineStyle', 'none');
patch([xx fliplr(xx)], [lciMN fliplr(uciMN)], 'b', 'LineStyle', 'none');
plot(meanAllMI{:}, 'r', 'LineStyle', '-', 'LineWidth', 1.5);
plot(uciMU, 'LineStyle', 'none'); plot(lciMU, 'LineStyle', 'none');
patch([xx fliplr(xx)], [lciMU fliplr(uciMU)], 'r', 'LineStyle', 'none');
set(gca, 'FontSize', 10, 'FontWeight','bold', 'XTick', 0:bins:length(meanAllMR{:})*bins, 'XTickLabel', ...
    -plotBaseline:bins*10:length(meanAllMR{:})*bins, 'YTick', 0:5:65, 'YLim', [0, 65]);
xlabel('Time', 'FontSize', 10, 'FontWeight','bold'), ylabel('Spikes/Second', 'FontSize', 10, 'FontWeight','bold');
plot([x1 x1], [0 55],':r', 'LineWidth', 0.5);
plot([x2 x2], [0 55],':r', 'LineWidth', 0.5);
plot([x5 x5], [0 10],':k', 'LineWidth', 1);
plot([x6 x6], [0 25],':k', 'LineWidth', 1);
plot([x3 x4], [55 55], 'k', 'LineWidth', 1);
text(35, 57, '***', 'FontSize', 20, 'FontWeight','bold');
hold off
alpha(.08);
mn = findobj('LineStyle', '-', 'Color', 'b'); mu = findobj('LineStyle', '-', 'Color', 'r');
pl = [mn(1) mu(1)]; legend(pl, 'MN', 'MU', 'FontSize', 10, 'FontWeight','bold');
h = suptitle([monName, ': ', num2str(cellNum), ' Neurons']);
set(h, 'FontSize', 16, 'FontWeight', 'bold');

figName = fullfile(outFolder, strcat(test, 'figName', '.pdf'));
saveas(fig, figName);
