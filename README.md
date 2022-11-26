# MNE ERP source analysis

### This is the little package for source analysis by mne, using in ERP time series source analysis

### Written by Guangzhi Deng, 11/23/2022.

### Here is the README below

1. This code is used for source analysis of ERP by the MNE method. Users should prepare the EEGLAB and Fieldtrip packages. Note that store EEGLAB and Fieldtrip packages in the other folders rather than this code folder.
2. Users should put the post-preprocessing data from EEGLAB in one folder. Then open MATLAB, and change the current path to the place this code was put on. Finally, run ‘MNE_source_analysis’ in the command window.
3. With an opening window, users should press the corresponding bottoms and add the path correctly. After that, press the ‘OK’ bottom, and the computer will analyze them automatically.
4. The results will automatically be saved in the output path. Users should run one condition every time if their computer memory is limited.
5. We also provide a simple visualization of the source results of each condition. Just press ‘Continue’ bottom and wait for a minus, then the ‘Ortho’ and ‘Surface’ plots will show on the screen. 
   1. If users want to plot again, just print ‘clear’ in the command window, then load the specific ‘ERP_source.mat’ in the output folder and print ’plot_dialog’.
   2. Users can plot specific condition results by the method above (i)
   3. If users choose to save the visualization results, the figure will close automatically. If not, the figures will be shown on the screen.
6. This code is also useful for resting data. Users should make sure to insert the related markers and add the epoch time range in the opening window. However, if the resting epoch is without pre-stimulus time series, this code (mne method) is unsuitable.

Please cite: Deng G, Ai H, Qin L, Xu J, Feng C, Xu P. Dissociated modulations of intranasal vasopressin on prosocial learning between reward-seeking and punishment-avoidance. Psychol Med. 2022 Aug 19. DOI: 10.1017/S0033291722002483.

Please contact me if you have any problem.

email: dengguangzhi@ccnlab.cn