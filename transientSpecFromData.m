% File:    transientSpecFromData.m
% Author:  Shane Snover <sws7379@rit.edu>
% Created: 10/21/2016
% Revised: 11/9/2016

function [ transSpec ] = transientSpecFromData( amplitude, time, smooth )
%
%   This function takes the time-domain response of a system to a unit step
% input and determines the system's transient specifications including
% overshoot, peak time, rise time, and settle time.
%
% To Do:
% - Implement a fourth argument, step time, allowing for flexibility in
% importing data.
%
% Arguments:
%   amplitude (1-Dimensional Array): Set of data points representing the
%       amplitude of the time-domain response.
%   time (1-Dimensional Array): Set of data points representing the time
%       steps of the data in the response.
%   smooth (Boolean): Allows the user to specify whether the input data
%       needs to be smoothed (example: if the data is noisy).
%
% Returns:
%       A structure containing the transient specifications of the system
%   response.

if nargin < 3
    smooth = 0;
end

% Transient Specification Structure
transSpec = struct('OS',[],'riseTime',[],'peakTime',[],'settleTime',[]);

% Smooth Out the Data for Noise Reduction
if smooth == 1
    amplitude = rollingAverage(amplitude);
    time = rollingAverage(time);
end
    
% Find the Steady State Value
steady_state = mean(amplitude((end-9):end));

% Overshoot and Peak Time
[magnitude_max, index_max] = max(amplitude);
transSpec.OS = (magnitude_max - steady_state) * 100;
transSpec.peakTime = time(index_max);
if transSpec.OS < 2
    transSpec.OS = 0;
    transSpec.peakTime = NaN;
end

% Rise Time
index_high = find(amplitude > (0.9*steady_state), 1, 'first');
index_low = find(amplitude > (0.1*steady_state), 1, 'first');
transSpec.riseTime = time(index_high) - time(index_low);

% Settle Time
mag_settle_upper = steady_state * 1.02;
mag_settle_lower = steady_state * 0.98;
index_settle_upper = find(amplitude > mag_settle_upper, 1, 'last');
index_settle_lower = find(amplitude < mag_settle_lower, 1, 'last');
index_settle = max(index_settle_lower, index_settle_upper);
if isempty(index_settle_upper) || isempty(index_settle_lower)
    if ~isempty(index_settle_upper)
        index_settle = index_settle_upper;
    else
        index_settle = index_settle_lower;
    end
end

transSpec.settleTime = time(index_settle);
if isempty(transSpec.settleTime)
    transSpec.settleTime = NaN;
end

end

