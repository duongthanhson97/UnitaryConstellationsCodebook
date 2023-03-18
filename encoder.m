function TxSig = encoder(inputBits, aBitMappingMat, amplitudeSet, pBitAllo)
    % Encoder for proposed unitary signals

    % pBitAllo: number of bits for encoding each PSK symbols.
	% Ex: pBitAllo = [0,2,3], 1st symbol is reference, 2nd symbol is 4-PSK, 3nd symbol is 8-PSK
    % amplitudeSet: codebook of amplitude vectors. Each amplitude vector is a column of amplitudeSet.
    % aBitMappingMat: codebook of bit sequence mapping to amplitude set
    
    % Author: Son Duong - University of Saskatchewan
    % Email: wve765@usask.ca
    l_u = log2( size(amplitudeSet,2) );
    amplitudeBits = inputBits(1:l_u);
    phaseBits = inputBits(l_u+1:end);
    u = amplitudeEncoder( amplitudeBits, aBitMappingMat, amplitudeSet );
    p = phaseEncoder( phaseBits, pBitAllo );
    TxSig = u .* p;
end