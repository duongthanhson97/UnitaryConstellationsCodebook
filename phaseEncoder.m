function p = phaseEncoder( phaseBits, phaseBitAllocation )
    % PSK encoder with Gray mapping

    % Author: Son Duong - University of Saskatchewan
    % Email:wve765@usask.ca
    
    K = length(phaseBitAllocation);
    p = ones(K,1);
    for i=2:length(phaseBitAllocation)
        % Encoding i-th PSK symbol
        if(phaseBitAllocation(i)>=1)
            truncatedBits = phaseBits( sum(phaseBitAllocation(1:i-1))+1 : sum(phaseBitAllocation(1:i)) );
            p(i) = pskmod( bi2de(truncatedBits','left-msb'), 2^phaseBitAllocation(i), 0, 'gray');
        end
    end

end