function [RMS0] = RMS_Visualize(directions)
% function:
%   caculate RMS and visualize it
% input: 
%   directions:the input file directions.If three directions file in the
%              same folder, using 
%                     directions =  'three directions', 
%              else uses 
%                     directions =  'one direction';
% output: 
%    RMS result: it's a figure, like the example.fig
%          RMS0: the caculation result of RMS

%  modified: '30-May-2021' 
%    author: Changliang Xiong
%    emails: xiongchangliang20@mails.ucas.ac.cn

% if it helps, please cite:
% He X, Yu K, Montillet J P, et al. GNSS-TS-NRS: An Open-Source MATLAB-Based GNSS Time Series Noise Reduction Software[J]. 
% Remote Sensing, 2020, 12(21): 3532.

% example1:
%   RMS_Visualize('one direction')
%   then choose the 'mom3' folder

% example2:
%   RMS_Visualize('three directions')
%   then choose the 'mom1' folder

tic
if nargin ~= 1
    error('error input arrgunment!')
end

switch directions
    case 'one direction'
        step = 1;
    case 'three directions'
        step = 3;
end

filepath = uigetdir(strcat(cd,'\mom3'),'Please choose a folder'); 
current = filepath;
A = dir(current);
k = 0; % site number
if  step == 1
    for ss = 3:step:length(A)
        folder = strcat(current,'\',A(ss,1).name);
        
        [lines, ~] = read_headlines(folder); % return the headlines
        
        fid_E = fopen(folder);
        data =  textscan(fid_E,' %f %f','headerlines',lines);
        resi = data{2};
        fclose(fid_E);
        RMS_E = sqrt(sum(resi.^2)/length(resi));
        RMS0(ss-2) = [RMS_E];
        k = k+1;
        siteName{k} = A(ss,1).name(1:6) ;
    end
    figure
    bar(RMS0,'FaceColor',[1 1 0.8],'EdgeColor',[1 0.5 0.5])
    set(gca,'FontSize',10,'FontName', 'times new roman');
    xlabel('Site')
    ylabel('RMS(mm)')
    xlim([0 k+1]);
    xticklabels(siteName) % set X labels
    xticks(1:length(siteName))
    xtickangle(90) %set X labels rotation angle
    graph = strcat(cd);
    g = get(gcf,'Number');
    graph = strcat(graph,'\', num2str(g) ,'.fig');
    saveas(gcf,graph)
end

if step == 3
    RMS_E0 = [];RMS_N0 = [];RMS_U0 = [];
    for ss = 3:step:length(A)
        folder_E = strcat(current,'\',A(ss,1).name);
        folder_N = strcat(current,'\',A(ss+1,1).name);
        folder_U = strcat(current,'\',A(ss+2,1).name);
        
        [lines_E, ~] = read_headlines(folder_E); % return the headlines
        [lines_N, ~] = read_headlines(folder_N); % return the headlines
        [lines_U, ~] = read_headlines(folder_N); % return the headlines
        fid_E = fopen(folder_E);
        data =  textscan(fid_E,' %f %f','headerlines',lines_E);
        resi_E = data{2};
        fclose(fid_E);
        
        fid_N = fopen(folder_N);
        data =  textscan(fid_N,' %f %f','headerlines',lines_N);
        resi_N = data{2};
        fclose(fid_N);
        
        fid_U = fopen(folder_U);
        data =  textscan(fid_U,' %f %f','headerlines',lines_U);
        resi_U = data{2};
        fclose(fid_U);
        
        RMS_E = sqrt(sum(resi_E.^2)/length(resi_E));
        RMS_N = sqrt(sum(resi_N.^2)/length(resi_N));
        RMS_U = sqrt(sum(resi_U.^2)/length(resi_U));
        
        RMS_E0 = [RMS_E0;RMS_E];
        RMS_N0 = [RMS_N0;RMS_N];
        RMS_U0 = [RMS_U0;RMS_U];
        k = k+1;
        siteName{k} = A(ss,1).name(1:4) ;
    end
    RMS0 = [RMS_E0 RMS_N0 RMS_U0];
    
    figure
    subplot(3,1,1)
    bar(RMS_E0,'FaceColor',[1 1 0.8],'EdgeColor',[1 0.5 0.5])
    set(gca,'FontSize',10,'FontName', 'times new roman');
    xlabel('Site')
    ylabel('RMS(mm)')
    xlim([0 k+1]);
    xticklabels(siteName) % set X labels
    xticks(1:length(siteName))
    xtickangle(90) %set X labels rotation angle
    
    subplot(3,1,2)
    bar(RMS_N0,'FaceColor',[1 1 0.8],'EdgeColor',[1 0.5 0.5])
    set(gca,'FontSize',10,'FontName', 'times new roman');
    xlabel('Site')
    ylabel('RMS(mm)')
    xlim([0 k+1]);
    xticklabels(siteName) % set X labels
    xticks(1:length(siteName))
    xtickangle(90) %set X labels rotation angle
    
    subplot(3,1,3)
    bar(RMS_U0,'FaceColor',[1 1 0.8],'EdgeColor',[1 0.5 0.5])
    set(gca,'FontSize',10,'FontName', 'times new roman');
    xlabel('Site')
    ylabel('RMS(mm)')
    xlim([0 k+1]);
    xticklabels(siteName) % set X labels
    xticks(1:length(siteName))
    xtickangle(90) %set X labels rotation angle
    
    graph = strcat(cd);
    g = get(gcf,'Number');
    graph = strcat(graph,'\', num2str(g) ,'.fig');
    saveas(gcf,graph)
end

toc



