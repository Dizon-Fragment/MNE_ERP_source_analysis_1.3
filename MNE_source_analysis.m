%% Source analysis
% This code is used for source analysis for ERP data.
% Guangzhi Deng, 11/21/2022.

%% Run
clear; close all; clc;
tmp_path = strsplit(matlab.desktop.editor.getActiveFilename, filesep);
cd(fullfile(tmp_path{1:end-1}));
ct = 0;
my_dialog
% ---------------------------- Parameter ----------------------------------
% dir_path = 'D:\helping\JiayuYao'; % set the main path, and put the data in the subfolder, like 'D:\helping\JiayuYao\data'
% fieldtrip_path = 'D:\source\class info\FT_learning\EEG_senior\5EEGT_day1\toolboxes\fieldtrip-20180101';
% eeglab_path = 'D:\Installation_package\eeglab14_0_0b';
% channel_num = 61; % channel number must be identical.
% erp_cond = {'31', '32', '41', '42'};
% grid_resolution = 10; % mm
% -------------------------------------------------------------------------

