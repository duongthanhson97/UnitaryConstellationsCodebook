function [amplitudeSet, l_u, phaseBitAllocation, chordalDistance] = loadCodebook(K,l_v)
    % Load unitary set from .mat file

    % K: number of symbols
    % l_v: number of bits for unitary constellations
    
    % amplitudeSet: codebook of amplitude vectors. Each amplitude vector is a column of amplitudeSet.
    % l_u: number of bits for encoding amplitude vector
    % pBitAllo: number of bits for encoding each PSK symbols.
	% Ex: pBitAllo = [0,2,3], 1st symbol is reference, 2nd symbol is 4-PSK, 3nd symbol is 8-PSK
    
    % Author: Son Duong - University of Saskatchewan
    % Email: wve765@usask.ca
    filename = ['OptimalCodebook/K=',num2str(K),'/Codebook_constellation_',num2str(l_v),'bits.mat'];
    load(filename,'l_u','phaseBitAllocation','amplitudeSet','chordalDistance');
end