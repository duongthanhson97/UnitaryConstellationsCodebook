function [p,pBits] = phase_GLRT_decoding(Z,u,pBitAllo)
    % Decoding phase by GLRT with exhaustive search
    
    % Z: correlation between different symbols
    % u: known (or detected) amplitude vector
    % pBitAllo: number of bits for encoding each PSK symbols.
	% Ex: pBitAllo = [0,2,3], 1st symbol is reference, 2nd symbol is 4-PSK, 3nd symbol is 8-PSK
    
    % p: decoded phase vector
    % pBits: decoded phase bits

    % Author: Son Duong - University of Saskatchewan
    % Email: wve765@usask.ca
    K = length(pBitAllo);
    p = ones(K,1);
    Z_u = Z .* (u * u');
    numPBit = sum(pBitAllo) - 1;
    best_GLRT_objValue = -1;
    
    % Generate all possible bit sequence
    for i=0:2^numPBit-1
        % Generate a phase vector
        temp_p = phaseEncoder( de2bi(i,numPBit,'left-msb'), pBitAllo );
        
        % Obtain its GLRT values
        GLRT_objValue = abs(temp_p.' * Z_u * conj(temp_p));
        if(GLRT_objValue >= best_GLRT_objValue)
            % Optimal phase vector
            best_GLRT_objValue = GLRT_objValue;
            p = temp_p;
        end
    end
    
    % Decoding PSK signals to bits
    pBits = [];
    if(sum(pBitAllo)>=1)
        for k=1:length(pBitAllo)
            if(pBitAllo(k)>=1)
                pBits = [pBits;de2bi( pskdemod(p(k), 2^pBitAllo(k), 0, 'gray' ), pBitAllo(k), 'left-msb')'];
            end
        end
    end
    
end