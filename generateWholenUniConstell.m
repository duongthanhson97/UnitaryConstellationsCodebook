function [uniConstel, mapBits] = generateWholenUniConstell( amplitudeSet, aBitMappingMat, pBitAllo )
    % Generate all possible unitary signals and its bits mapping to the unitary siganls
    
    % pBitAllo: number of bits for encoding each PSK symbols.
	% Ex: pBitAllo = [0,2,3], 1st symbol is reference, 2nd symbol is 4-PSK, 3nd symbol is 8-PSK
    % amplitudeSet: codebook of amplitude vectors. Each amplitude vector is a column of amplitudeSet.
    % aBitMappingMat: codebook of bit sequence mapping to amplitude set
    
    l_v = size(aBitMappingMat,1) + sum(pBitAllo);   % Number of transmitted bits
    K = size(amplitudeSet,1);                       % Number of symbols
    uniConstel = zeros(K,2^l_v);
    mapBits = zeros(l_v,2^l_v);
    for i=0:2^l_v-1
        txBits = de2bi(i,l_v,'left-msb')';
        mapBits(:,i+1) = txBits;
        uniConstel(:,i+1) = encoder(txBits, aBitMappingMat, amplitudeSet, pBitAllo);
    end
end