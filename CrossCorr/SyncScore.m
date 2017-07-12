function [syncZ,peakIx,cchZ] = SyncScore(t1,t2,bins)

% Computes a sync score for two spike trains (i.e.  the number of z-values
% above the cross-correlogram when all fine temporal coordination
% is removed.
% 
% USAGE:
%     syncZ = SyncScore(t1,t2,bins,nbins)
%     
%    INPUTS
%    t1       spike train of 1st cell (in ms)
%    t2       spike train of 2nd cell (in ms)
%    binSize  size of the bins (in ms)
%
%    OUTPUT
%    syncZ    sync zscore (in z values)
%
%    Dependencies:
%    cch_conv

% Copyright (C) 2017 Adrien Peyrache


%PArameters:
window = 21; %number of bins used for smoothing the cross-corr

%Compute cross-correlation
[xc,bxc] = CrossCorr(t1,t2,bins,100);
bix = abs(bxc/bins)<7;

%Compute z-scored sync
%Convert in number of events
cch = xc*length(t1)*bins/1000;

%compute expected cross-corr by smoothing initial cross-corr
[~, pred, ~] = cch_conv(round(cch),window);

   
%Interval of confidence assuming a Poisson process
confInt = poissinv(0.95,pred);

%Z-scored CCH
cchZ = (cch-pred)./(confInt-pred);

%look for peak value
[syncZ,peakIx] = max(cchZ(bix));
b = bxc(bix);
peakIx = b(peakIx);

