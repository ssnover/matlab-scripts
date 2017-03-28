function [ cleaned_wave ] = rollingAverage( wave )
% This function takes a data sample and performs a rolling average to help
% reduce variation in the data.
%
% Arguments:
%   wave (1-Dimensional Matrix): The input data to be cleaned up.
%
% Returns:
%   cleaned_wave (1-Dimensional Matrix): Averaged data. The length is the
%       same as the length of the input vector minus 8 points lost due to
%       the data processing technique.
% File:    rollingAverage.m
% Author:  Shane Snover <sws7379@rit.edu>
% Created: 11/6/2016
% Revised: 11/6/2016

for i = 5:(length(wave)-4)
    cleaned_wave(i-4) = sum(wave(i-4:i+4))/9;
end

end