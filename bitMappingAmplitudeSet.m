function aBitMappingMat = bitMappingAmplitudeSet( l_u, amplitudeSet )
    % Generate a bit mapping for amplitude set
    % Please note that this version is purely random mapping and results in terrible BER performance.
    
    % Author: Son Duong - University of Saskatchewan
    % Email: wve765@usask.ca
    
    aBitMappingMat = zeros(l_u,2^l_u);
    for i=0:2^l_u-1
        aBitMappingMat(:,i+1) = de2bi(i,l_u,'left-msb')';
    end
end