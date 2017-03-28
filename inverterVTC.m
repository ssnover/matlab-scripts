function [ VTC, S, valid ] = inverterVTC( Vin, Vout )
% This function takes the voltage input and output curves for an inverter
% and finds the inveter's voltage transfer characteristics.
%
% Arguments:
%   Vin (1-Dimensional Matrix): The stepped input for the inverter, usually
%       from V = 0 to V = Vdd.
%   Vout (1-Dimensional Matrix): The output of the inverter for a given
%       input.
%
% Returns:
%   VTC: A structure containing the voltage transfer characteristics Voh,
%       Vol, Vih, Vil, Vs, NMH, and NML.
%   S: A matrix containing the derivative of Vout with respect to Vin.
%       Useful for finding the maximum gain of the inverter.
%   valid: A boolean indicating whether the data fits the VTC of an
%       inverter.
%   
% File:    inverterVTC.m
% Author:  Shane Snover <sws7379@rit.edu>
% Created: 10/31/2016
% Revised: 11/7/2016

VTC = struct('Voh',0,'Vih',0,'Vil',0,'Vol',0,'Vs',0,'NMH',0,'NML',0);

% Find the Slope of the Plot for all Vin
for i = 1:(length(Vin)-1)
    S(i) = (Vout(i+1) - Vout(i))/(Vin(i+1) - Vin(i));
end

% The Maxmimum |S| is the Max Gain at Vs = Vin = Vout
[mag_S, index_s] = min(S);
VTC.Vs = Vin(index_s);

% Determine if Valid Inverter or Not
if mag_S > -1
    valid = 0;
    fprintf('Improper Inverter.\n');
    return
end

valid = 1;

% Find Inflection Points, Slope = -1
[~, index_left] = find(S < -1, 1, 'first');
[~, index_right] = find(S < -1, 1, 'last');

% Inflection Point VTCs
VTC.Voh = Vout(index_left);
VTC.Vol = Vout(index_right);
VTC.Vih = Vin(index_right);
VTC.Vil = Vin(index_left);

% Noise Margins
VTC.NMH = VTC.Voh - VTC.Vih;
VTC.NML = VTC.Vil - VTC.Vol;

end

