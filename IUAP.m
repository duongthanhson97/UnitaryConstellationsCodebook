function [decoded_bit,decoded_signal] = IUAP(Y,amplitudeSet,pBitAllo,aBitMappingMat,mode,varargin)
    % Iterative decoder with:
    % - Amplitude decoding using GLRT exhaustive search
    % - Phase decoding using one of three decoders: MAP-R-sort-DFDD, improved MAP-R-sort-DFDD, or GLRT decoder with exhaustive search

    % Y: Received signal
    % pBitAllo: bit allocation to phase
    % aBitMappingMat: bit mapping to amplitude set
    % mode == 0 -> MAP-R-sort-DFDD
    % mode == 1 -> improved MAP-R-sort-DFDD
    % mode == 2 -> GLRT decoder with exhaustive search
    
    % Author: Son Duong - University of Saskatchewan
    % Email: wve765@usask.ca
    
    maxIter = 3;    % Maximum number of iterations
    if( nargin >= 6)
        maxIter = varargin{1};
    end
    
    K = length(pBitAllo);                       % Number of symbols
    numAmpBit = log2(size(amplitudeSet,2));     % Number of amplitude bits
    numBit = numAmpBit + sum(pBitAllo);         % Total number of bits
    
    Z = Y' * Y;                                 % Correlation matrix
    decoded_bit = zeros(numBit,1);
    % First iteration - Decode amplitude
    [amplitudeVector,amplitudeBit] = amplitudeGLRTdecoding(abs(Z),amplitudeSet,aBitMappingMat);
    decoded_bit(1:numAmpBit) = amplitudeBit;
    
    % Main loop
    for i = 2:maxIter
        if(rem(i,2) == 0)
            % Decode phase
            if(mode == 1)
                [phaseVector,decoded_phaseBit] = improved_MAP_R_sort_DFDD(Z,amplitudeVector,pBitAllo);
            elseif(mode == 0)
                [phaseVector,decoded_phaseBit] = MAP_R_sort_DFDD(Z,amplitudeVector,pBitAllo);
            elseif(mode == 2)
                [phaseVector,decoded_phaseBit] = phase_GLRT_decoding(Z,amplitudeVector,pBitAllo);
            end
            decoded_bit(numAmpBit+1:end) = decoded_phaseBit;
        else
            % Decode amplitude
            Z_equiv = Z .* ( conj(phaseVector) * phaseVector.' ).';
            [amplitudeVector,amplitudeBit] = amplitudeGLRTdecoding(Z_equiv,amplitudeSet,aBitMappingMat);
            decoded_bit(1:numAmpBit) = amplitudeBit;
        end
        decoded_signal = amplitudeVector .* phaseVector;
    end
end