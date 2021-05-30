function [lines, headline] = read_headlines(folder)
% function:
%   to count the headlines of mom file
% input: 
%   folder:the [filepath filename]
% output: 
%    lines: double, the number of headerlines
% headline: cell, the context of headlines
% modified: '24-Apr-2021' author:Changliang Xiong
% emails:xiongchangliang20@mails.ucas.ac.cn
% if it works,please cite:
% He X, Yu K, Montillet J P, et al. GNSS-TS-NRS: An Open-Source MATLAB-Based GNSS Time Series Noise Reduction Software[J]. 
% Remote Sensing, 2020, 12(21): 3532.
    fid = fopen(folder);
    lines = 0;
    str = '#';  % obtain the header file lines
    while 1
        a = fgetl(fid);
        if  ~strcmp(a(1),str) 
            % compare the first string 
            % if not " # ", then pick out the loop
            break
        end
        lines = lines+1;
        headline{lines} = a;
    end
    fclose(fid);
end