function mne_visualization(icond,isave,all_cond,spec_cond,time_range,channel_num, data_path, eeglab_path, erp_cond, fieldtrip_path, output_path, grid_resolution, ROI_time)
%% visulization
% you can check your source results of specific subject in this part.
% set the interested timepoint(time_roi) and you change check this result corresponding to ERP.
fprintf('\nNow plotting the source results, please wait for a second......\n')
load(fullfile(output_path,['ERP_source_',icond,'.mat'])); % contain cond_name
restoredefaultpath
addpath(fieldtrip_path);
ft_defaults
% check the 'add_cond' and 'spec_cond'
if all_cond == 1 && spec_cond == 0
    tmp_ee = 1:length(erp_cond);
elseif all_cond == 0 && all(all_cond==0 & ~contains(string(spec_cond),'0')==1)
    if max(spec_cond)<=length(erp_cond)
        tmp_ee = spec_cond;
    else
        war = warndlg('输入的条件数不在范围内，请重选', '提示');
        uiwait(war, 10)
        plot_dialog
    end
else
    war = warndlg('输入的条件数不在范围内，请重选', '提示');
    uiwait(war, 10)
    plot_dialog
end
% run
for ee = tmp_ee
    tmp_file = eval(['erp_source.', cond_name{ee}]);
    for tt = 1:length(tmp_file)
        sub_file = tmp_file{tt};
        tmp_pow(:,:,tt) = sub_file.avg.pow;
    end
    idx1 = dsearchn(sub_file.time', ROI_time(1));
    idx2= dsearchn(sub_file.time', ROI_time(end));
    source_mean = tmp_file{1};
    source_mean.avg.pow = squeeze(mean(mean(source_mean.avg.pow(:,idx1:idx2,:),2),3));
    % interpolate to mri image
    mri = ft_read_mri(fullfile( fieldtrip_path, 'template\anatomy\single_subj_T1.nii')); % http://www.fieldtriptoolbox.org/template/anatomy/
    mri = ft_volumereslice([], mri);
    mri = ft_convert_units(mri, 'cm'); % set the unit as 'cm'
    cfg              = [];
    cfg.parameter    = 'avg.pow';
    cfg.interpmethod = 'nearest';
    source_int  = ft_sourceinterpolate(cfg, source_mean, mri); % fill the gap between sources
    % extract the mask
    source_int.mask = source_int.pow > max(source_int.pow(:)*0.3); % show something more powerful (mask: 0/1)
    clear tmp_pow sub_file source_mean
    % plot
    cfg               = [];
    % cfg.method        = 'surface'; % plot method
    cfg.method        = 'ortho'; % plot method
    cfg.funparameter  = 'pow';% time ROI, the activity of source(after interpolate)
    cfg.funcolormap = 'hot'; % color theme
    cfg.maskparameter = 'mask'; % show limitation
    cfg.title = ['Mean source results in condtion: EEG ', erp_cond{ee}, ' (Ortho)'];
    % cfg.funcolorlim = [-1 1];
    % cfg.opacitylim    = [3 8];
    % cfg.opacitymap    = 'rampup';
    % cfg.funcolormap   = 'jet';
    cfg.surfdownsample = 10; % downsample to plot
    ft_sourceplot(cfg,source_int);
    if isave == 1
        frame = getframe(gcf);
        im = frame2im(frame);
        imwrite(im,fullfile(output_path, ['Ortho_',erp_cond{ee},'.png']));
        close all
    end
    
    cfg               = [];
    cfg.method        = 'surface'; % plot method
    cfg.funparameter  = 'pow';% time ROI, the activity of source(after interpolate)
    cfg.funcolormap = 'hot'; % color theme
    cfg.maskparameter = 'mask'; % show limitation
    % cfg.funcolorlim = [-1 1];
    % cfg.opacitylim    = [3 8];
    cfg.opacitymap    = 'rampup';
    cfg.funcolormap   = 'parula';
    cfg.title = ['Mean source results in condtion: EEG ', erp_cond{ee}, ' (Surface)'];
    cfg.surfdownsample = 10; % downsample to plot
%     cfg.locationcoordinates = 'head';
    ft_sourceplot(cfg,source_int);
%     shading interp
    light('position',[-1 0 0]);view([-90 0]);lighting none
    if isave == 1
        frame = getframe(gcf);
        im = frame2im(frame);
        imwrite(im,fullfile(output_path, ['Surf_',erp_cond{ee},'.png']));
        close all
    end
    % time break
    if ee ~= tmp_ee(end)
        button=questdlg('是否继续下一个条件的画图？','Timebreak','Yes','No','Yes');
        if strcmp(button,'Yes')
            continue % Yes
        else
            break
        end
    end
    clear source_int
end
fprintf('\nFinish.\n')
end
