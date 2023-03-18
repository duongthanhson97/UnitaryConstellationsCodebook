function [p,pBits] = improved_MAP_R_sort_DFDD(Z,u,pBitAllo)
    % Improved MAP-based reliability sorted DFDD

    % Z_u: matrix whose (i,j)-th element is correllation between i-th and j-th received signal
    % u: known amplitude vector
    % p: decoded phase vector
    % pBits: decoded phase bits
    % pBitAllo: bit allocation to phase vector
    % If you want to use MAP_R_sort_DFDD to only decode non-coherent PSK signal, simply set Z_u = Y^H * Y with Y is received signal.

    % Author: Son Duong - University of Saskatchewan
    % Email: wve765@usask.ca
    
    % Initialization
    detected_list = [];     % list of detected symbols
    undetected_list = [];   % list of undetected symbols
    for i=1:length(pBitAllo)
        if(pBitAllo(i)==0)
            detected_list = [detected_list,i];
        else
            undetected_list = [undetected_list,i];
        end
    end
    p = ones(length(pBitAllo),1);
    
    % Main loop
    while(isempty(undetected_list)==0)
        % In this iteration, we have to choose the highest reliable symbol.;
        R_list = zeros(size(undetected_list));      % reliability of all undetected symbols
        temp_list = zeros(size(undetected_list));   % temporary decision of all undetected symbols
        for j=1:length(undetected_list)
            % For each undetected d-th symbol, calculate its temporary decision and reliability
            d = undetected_list(j);     % undetected d-th symbol
            PSK_set_d = 0:2*pi/2^pBitAllo(d):2*pi - 2*pi/2^pBitAllo(d); % PSK set of d-th symbol
            list_objValue = zeros(size(PSK_set_d)); % Real(\mu * \phi_d) + \sum \eta_{d,q} according to different \phi_d
            
            % Calculate \mu with detected symbols
            mu = 0;
            for k=detected_list
                mu = mu + Z(k,d) * u(d) * u(k) * p(k);
            end
            
            % Calculate correlation with other undetected symbols
            for l=1:length(PSK_set_d)
                phi_d = PSK_set_d(l);
                list_objValue(l) = real(mu*exp(-1i*phi_d));
                for q = undetected_list
                    % Calculate \eta_d_q
                    if(pBitAllo(q) < pBitAllo(d))
                        tmp_PSK_set = -pi:2*pi/2^pBitAllo(q):pi;
                        [tmp_arg_error,tmp_min] = min(abs(tmp_PSK_set - angle( Z(d,q)*exp(1i*phi_d))));
                        best_phi_q = tmp_PSK_set(tmp_min); % find PSK values of q-th symbol that is closest to d-th symbol
                        eta_d_q = real(Z(d,q)*u(q)*u(d)*exp(1i*(phi_d-best_phi_q)));
                        list_objValue(l) = list_objValue(l) + eta_d_q;
                    end
                end
            end
            % Choose the \phi_d which is optimal solution
            [best_objValue,best_phi_d_index] = max( list_objValue );
            % Choose the \phi_d which is second optimal solution
            [second_objValue] = max( list_objValue( [1:best_phi_d_index-1,best_phi_d_index+1:end] ) );
            % Calculate its reliability
            R_list(j) = best_objValue - second_objValue;
            % Obtain temporary decision
            temp_list(j) = PSK_set_d(best_phi_d_index);
        end
        % Choose highest reliable undetected symbol
        [~, idx] = max(R_list);
        highestR_sym = undetected_list(idx);            % highest reliable undetected symbol
        p(highestR_sym) = exp(1i * temp_list(idx));     % update final decision to decoded phase vector
        % Add new detected symbol to detected list
        detected_list = [detected_list, highestR_sym];
        % Remove new detected symbol from undetected list
        undetected_list = undetected_list(undetected_list ~= highestR_sym);
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