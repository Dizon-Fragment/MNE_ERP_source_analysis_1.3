function my_dialog
d = dialog('WindowStyle', 'normal','Name','Please input the corresponding paths:');
% uiwait(d)

txt1 = uicontrol('Parent',d,...
    'Style','text',...
    'Position',[40 80 250 300],...
    'FontSize',16,...
    'String','Data directory:');

btn1 = uicontrol('Parent',d,...
    'Position',[350 345 140 50],...
    'String','...',...
    'FontSize',12,...
    'Callback','data_path = uigetdir();ct = ct + 1;');


txt2 = uicontrol('Parent',d,...
    'Style','text',...
    'Position',[40 80 250 250],...
    'FontSize',16,...
    'String','Save directory:');

btn2 = uicontrol('Parent',d,...
    'Position',[350 295 140 50],...
    'String','...',...
    'FontSize',12,...
    'Callback','output_path = uigetdir();ct = ct + 1;');


txt3 = uicontrol('Parent',d,...
    'Style','text',...
    'Position',[40 80 250 200],...
    'FontSize',16,...
    'String','eeglab directory:');

btn3 = uicontrol('Parent',d,...
    'Position',[350 245 140 50],...
    'String','...',...
    'FontSize',12,...
    'Callback','eeglab_path = uigetdir();ct = ct + 1;');


txt4 = uicontrol('Parent',d,...
    'Style','text',...
    'Position',[40 80 250 150],...
    'FontSize',16,...
    'String','fieldtrip directory:');

btn4 = uicontrol('Parent',d,...
    'Position',[350 195 140 50],...
    'String','...',...
    'FontSize',12,...
    'Callback','fieldtrip_path = uigetdir();ct = ct + 1;');


txt5 = uicontrol('Parent',d,...
    'Style','text',...
    'Position',[40 80 250 100],...
    'FontSize',16,...
    'String','Number of channels:');

btn5 = uicontrol('Parent',d,...
    'Position',[350 145 140 50],...
    'String','...',...
    'FontSize',12,...
    'Callback','channel_num = cell2mat(inputdlg('''','''',[1 30],{''61''}));ct = ct + 1;');


txt6 = uicontrol('Parent',d,...
    'Style','text',...
    'Position',[40 80 250 50],...
    'FontSize',16,...
    'String','Epoch condition:');

btn6 = uicontrol('Parent',d,...
    'Position',[350 95 140 50],...
    'String','...',...
    'FontSize',12,...
    'Callback',['epoch_info=inputdlg({''marker'', ''time series''}, ''Please enter'', [1 30;1 30], {''31,32,41,42'', ''-0.2 1''});',...
    'tmp_epoch1 = epoch_info{1};erp_cond = cellstr(strsplit(tmp_epoch1,{'',''}));icond = regexprep(regexprep(tmp_epoch1,'','',''_''),'' '','''');',...
    'tmp_epoch2 = epoch_info{2};time_range=(tmp_epoch2);ct = ct + 1;']);


txt7 = uicontrol('Parent',d,...
    'Style','text',...
    'Position',[40 30 250 50],...
    'FontSize',16,...
    'String','Resolution of head model');

btn7 = uicontrol('Parent',d,...
    'Position',[350 45 140 50],...
    'String','...',...
    'FontSize',12,...
    'Callback','grid_resolution = str2num(cell2mat(inputdlg(''e.g.10'',''Please enter'',[1 30],{''10''})));ct = ct + 1;');


btn8 = uicontrol('Parent',d,...
    'Position',[255 20 70 25],...
    'String','OK',...
    'FontSize',10,...
    'Callback',['if ct >= 7; delete(gcf);run_mne(icond,time_range,channel_num, data_path, eeglab_path, erp_cond, fieldtrip_path, output_path, grid_resolution);',...
    'else;h = errordlg(''Please make sure of your input'',''error'',''modal'');end']);

% trytest = uicontrol('Parent',d,...
%     'Position',[380 20 70 25],...
%     'String','test',...
%     'FontSize',10,...
%     'Callback', ['data_path = ''''; output_path = '''';',...
%     'eeglab_path=''D:\Installation_package\eeglab14_0_0b'';fieldtrip_path=''D:\Installation_package\fieldtrip-20220104'';',...
%     'channel_num = ''61'';erp_cond={''31'',''32'',''41'',''42''};time_range=''-0.2 1'';grid_resolution=10;ct=7;']);

uiwait(d)
end