%% Source analysis
% This code is used for source analysis for ERP data.
% Guangzhi Deng, 11/21/2022.

%% Run
clear; close all; clc;
% ---------------------------- Parameter ----------------------------------
tmp_path = strsplit(matlab.desktop.editor.getActiveFilename, filesep);
cd(fullfile(tmp_path{1:end-1}));
ct = 0;
my_dialog
% -------------------------------------------------------------------------
