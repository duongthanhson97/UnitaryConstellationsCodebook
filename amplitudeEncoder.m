function u = amplitudeEncoder( amplitudeBits, aBitMappingMat, amplitudeSet )

    % amplitudeBits: bit allocated to amplitude vector
    % amplitudeSet: codebook of amplitude set
    % aBitMappingMat: codebook of bit sequence mapping to amplitude set
    % u: transmitted amplitude vector
    
    % Author: Son Duong - University of Saskatchewan
    % Email: wve765@usask.ca
    l_u = length(amplitudeBits);
    idx = 1;
    if(l_u>=1)
        for i=1:2^l_u
            if( sum(xor(amplitudeBits,aBitMappingMat(:,i))) == 0 )
                idx = i;
                break;
            end 
        end
    end
    u = amplitudeSet(:,idx);
end