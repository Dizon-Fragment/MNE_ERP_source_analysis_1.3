function run_mne(icond, time_range, channel_num, data_path, eeglab_path, erp_cond, fieldtrip_path, output_path, grid_resolution)

fprintf('\nProcessing ......\n')
% cd to the path
tmp_path = strsplit(matlab.desktop.editor.getActiveFilename, filesep);
code_path = fullfile(tmp_path{1:end-1}); % you can change this path to your code position
cd(code_path);
% load data
% data_path = fullfile(dir_path, 'data');
% output_path = fullfile(dir_path, 'result');
mkdir(output_path)
data_input = dir(fullfile(data_path, '*.set')); % put the pre-processing data from eeglab in the subfolder 'data'.
filenames = {data_input.name};
% add the path of codes
restoredefaultpath
if exist(code_path, 'dir')
    addpath(genpath(code_path))
end
if exist(eeglab_path, 'dir')
    addpath(genpath(eeglab_path))
end
eeglab;close all;
% if eeglab dosen't work, run : 'eeglab; close all;'

% run the loop
% process eeglab data
for subj = 1:length(filenames)
    clear -regexp [^icond time_range EEG grid_resolution dir_path code_path fieldtrip_path eeglab_path data_path output_path filenames channel_num erp_cond subj EEG_all]
    % load the eeglab data
    EEG = pop_loadset('filename',filenames{subj},'filepath',data_path);% load data
    % check the channel number
    if length(EEG.chanlocs) ~= str2num(channel_num)
        error('Please check your data channel information.')
    end
    % extract the '7' epoch
%     tmp_data = {EEG.epoch.eventtype};
%     idx = cellfun(@(x) strcmp(x{end}, '7'), tmp_data, 'uniformoutput', false);
%     idx2 = arrayfun(@(x) ismember(x, find(cell2mat(idx) == 1)), cell2mat({EEG.event.epoch}), 'uniformoutput', true);
%     % set a EEG_new with available epoch
%     EEG_new = EEG;
%     EEG_new.epoch = EEG.epoch(logical(cell2mat(idx)));
%     EEG_new.data = EEG.data(:,:,logical(cell2mat(idx)));
%     EEG_new.event = EEG.event(idx2);
    % separate four conditions
    EEG_new = EEG;
    for ee = 1:length(erp_cond)
        fprintf('\nTaking epoch from Subj %s ''s condition %s\n', num2str(subj), erp_cond{ee});
        eval(['EEG_all.EEG_', regexprep(erp_cond{ee},' ',''), '{subj} = pop_epoch( EEG_new, {''', erp_cond{ee}, '''}, [',...
            time_range,'], ''epochinfo'', ''yes'');']);
    end
    ALLEEG = []; ALLCOM = [];
end
fprintf('\nSaving the eeglab structure......\n');
save(fullfile(output_path, ['EEG_eeglab_',icond,'.mat']), 'EEG_all','code_path','fieldtrip_path', 'eeglab_path',...
    'filenames','erp_cond', 'data_path', 'output_path','grid_resolution', 'channel_num', 'time_range','icond');
save(fullfile(output_path, 'setup.mat'), 'code_path','fieldtrip_path', 'eeglab_path',...
    'filenames','erp_cond', 'data_path', 'output_path','grid_resolution', 'channel_num', 'time_range','icond');

% source analysis in fieldtrip
cd(output_path)
clear; close all; clc;
% cd to the path
% tmp_path = split(matlab.desktop.editor.getActiveFilename, filesep);
% eegdata_path = fullfile(tmp_path{1:end-2}, 'result');
load('setup.mat')
load(['EEG_eeglab_',icond,'.mat']);
% sort the fieldnames of EEG_all
cond_name = fieldnames(EEG_all);
% combine the path information
var_names = whos;
vars = {var_names.name};
vars(cell2mat(cellfun(@(x) ismember(x, {'EEG_all'}),vars, 'uniformoutput', false))) = []; % do not save the 'EEG_all' variable
% reset the path environment
restoredefaultpath
addpath(genpath(code_path))
cd(code_path)
% addpath(genpath(fieldtrip_path)) % comment this code when you use the 'ft_defaults' below
% if you use the formal fieldtrip version, you can addpath() your fieldtrip
% path and run 'ft_defaults', like the code below (uncomment when using) :
addpath(fieldtrip_path);
ft_defaults;

% ---------------------------------------------------------------------------
% Now we use one subject's information to calculate the leadfield.
% translate the data to fieldtrip format
fprintf('\nCreating the leadfield......\n');
tmp_eeg = eval(['EEG_all.',cond_name{1}]);
fd_data = eeglab2fieldtrip_gzd(tmp_eeg{1}, 'preprocessing');
cfg = [];
cfg.toilim = str2num(time_range);
% cfg.minlength       = 'maxperlen';
tmp_prep = ft_redefinetrial(cfg, fd_data);
% calculate the leadfield
templateheadmodel = fullfile( fieldtrip_path, 'template/headmodel/standard_bem.mat');
load(templateheadmodel); % vol

cfg = [];
cfg.covariance = 'yes';% hannel x channel
cfg.covariancewindow = [-inf 0]; % 
timelock = ft_timelockanalysis(cfg,tmp_prep);
% run
cfg                 = [];
cfg.elec =  timelock.elec;     % sensor positions
cfg.headmodel = vol;        % volume conduction model
cfg.reducerank      = 3;
cfg.channel         = 'all';
cfg.grid.resolution = grid_resolution;   % use a 3-D grid with a 5 mm resolution
cfg.grid.unit       = 'mm';
leadfield = ft_prepare_leadfield(cfg);
clear timelock tmp_prep fd_data templateheadmodel
% ---------------------------------------------------------------------------

for cc = 1:length(cond_name)
    clear -regexp [^icond cond_name time_range vars erp_source vol leadfield dir_path code_path fieldtrip_path eeglab_path data_path output_path filenames channel_num erp_cond subj EEG_all]
    tmp_data = eval(['EEG_all.',cond_name{cc}]);
    for subj = 1:length(filenames)
        fprintf('\nSource analysis for Subj %s ''s condition %s\n', num2str(subj), cond_name{cc});
        tmp_data2 = tmp_data{subj};
        % translate the data to fieldtrip format
        fd_data = eeglab2fieldtrip_gzd(tmp_data2, 'preprocessing');
        cfg.toilim = str2num(time_range);
        cfg.minlength       = 'maxperlen';
        fd_data_prep = ft_redefinetrial(cfg, fd_data);
        % compute the noise-covariance matrix
        cfg = [];
        cfg.covariance = 'yes';% hannel x channel
        cfg.covariancewindow = [-inf 0]; %
        timelock = ft_timelockanalysis(cfg,fd_data_prep);
        % use 'mne' method to do source analysis
        cfg        = [];
        cfg.method = 'mne';
        cfg.grid   = leadfield; %
        cfg.headmodel     = vol; %
        cfg.mne.prewhiten = 'yes'; %
        cfg.mne.lambda    = 3; %
        cfg.mne.scalesourcecov = 'yes'; %
        eval(['erp_source.', cond_name{cc}, '{subj}= ft_sourceanalysis(cfg,timelock);']);
    end
end
clear leadfield vol
vars = [vars,'cond_name', 'erp_source'];
fprintf('\nSaving the source results......\n');
save(fullfile(output_path,['ERP_source_',icond,'.mat']),vars{:});
fprintf('\nFinish.\n')
plot_dialog
end