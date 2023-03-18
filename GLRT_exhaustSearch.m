function [decoded_bit,decoded_signal] = GLRT_exhaustSearch(Y,uniConstel,mapBits)
    % GLRT detector based on exhaustive search
    
    % Y: received signal
    % uniConstel: the list of all possible unitary signals
    % mapBits: bits mapping to all possible unitary signals
    
    % Author: Son Duong - University of Saskatchewan
    % Email: wve765@usask.ca
    
    Z = Y' * Y;
    best_GLRT_objValue = -1;
    for i=1:size(uniConstel,2)
        GLRT_objValue = abs( uniConstel(:,i).' * Z * conj(uniConstel(:,i)) );
        if(GLRT_objValue > best_GLRT_objValue)
            best_GLRT_objValue = GLRT_objValue;
            decoded_signal = uniConstel(:,i);
            decoded_bit = mapBits(:,i);
        end
    end
end