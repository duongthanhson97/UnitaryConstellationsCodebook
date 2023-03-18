function [amplitudeVector,amplitudeBit] = amplitudeGLRTdecoding(Z_p,amplitudeSet,aBitMappingMat)
    % Decoding amplitude signal by GLRT with exhaustive search
    
    % Z_p = Z .* ( conj(p) * p.' ).'; where Z = Y^H * Y is correlation between symbols, p is decoded (or known) phase vector.
    % amplitudeSet: codebook of amplitude set
    % aBitMappingMat: codebook of bit sequence mapping to amplitude set
    
    % Author: Son Duong - University of Saskatchewan
    % Email: wve765@usask.ca
    GLRT_best_value = -1;
    idx = 1;
    for i=1:size(amplitudeSet,2)
        GLRT_obj_value = abs(amplitudeSet(:,i).' * Z_p * amplitudeSet(:,i));
        if(GLRT_obj_value > GLRT_best_value)
            GLRT_best_value = GLRT_obj_value;
            idx = i;
        end
    end
    amplitudeVector = amplitudeSet(:,idx);
    amplitudeBit = aBitMappingMat(:,idx);
end