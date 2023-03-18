% Test constellations on Rayleigh fading channel in SIMO systems

% Author: Son Duong - University of Saskatchewan
% Email: wve765@usask.ca

clear;
SNR = 2;        % Signal to noise ratio (per antenna)
numRand = 1e5;  % Number of randomization
M = 32;         % Number of received antennas
l_v = 8;       % Number of transmitted bits
K = 3;          % Number of symbols

% Load codebook from .mat file
[amplitudeSet, l_u, pBitAllo, chordalDistance] = loadCodebook(K,l_v);
% Generate bit mapping to amplitude set
aBitMappingMat = bitMappingAmplitudeSet( l_u, amplitudeSet );
% Generate the whole unitary constellations (for ML exhaustive search)
[uniConstel, mapBits] = generateWholenUniConstell( amplitudeSet, aBitMappingMat, pBitAllo );

blkErr_iMAPsortDFDD = 0;    % Number of block errors by improved MAP-R-sort-DFDD
bitErr_iMAPsortDFDD = 0;    % Number of bit errors by improved MAP-R-sort-DFDD
blkErr_MAPsortDFDD = 0;     % Number of block errors by MAP-R-sort-DFDD
bitErr_MAPsortDFDD = 0;     % Number of bit errors by MAP-R-sort-DFDD
blkErr_GLRT = 0;              % Number of block errors by ML (GLRT) detector with exhaustive search
bitErr_GLRT = 0;              % Number of bit errors by ML (GLRT) detector with exhaustive search

for i=1:numRand

    noisePower = 1/K/10^(SNR/10);

    % Random transmit bits
    txBit = rand(l_v,1)>=0.5;

    % Encoding signal
    v = encoder(txBit, aBitMappingMat, amplitudeSet, pBitAllo);

    % Rayleigh channel
    h = (1/sqrt(2))*(randn(M,1)+1i*randn(M,1));                     % Rayleigh fading with power = 1
    n = sqrt(noisePower) * (1/sqrt(2))*(randn(M,K)+1i*randn(M,K));  % Noise matrix
    Y = h * v.' + n;                                                % Received signal

    % Iteraive decoder with phase decoded by improved MAP-R-sort-DFDD
    [RxBit,decoded_signal] = IUAP(Y,amplitudeSet,pBitAllo,aBitMappingMat,1);  
    blkErr_iMAPsortDFDD = blkErr_iMAPsortDFDD + (sum(xor(txBit,RxBit))>0);
    bitErr_iMAPsortDFDD = bitErr_iMAPsortDFDD + sum(xor(txBit,RxBit));
    
     % Iteraive decoder with phase decoded by MAP-R-sort-DFDD
    [RxBit,decoded_signal] = IUAP(Y,amplitudeSet,pBitAllo,aBitMappingMat,0);  
    blkErr_MAPsortDFDD = blkErr_MAPsortDFDD + (sum(xor(txBit,RxBit))>0);
    bitErr_MAPsortDFDD = bitErr_MAPsortDFDD + sum(xor(txBit,RxBit));
    
    % Iteraive decoder with phase decoded by ML (GLRT) detector with exhaustive search
    [RxBit,decoded_signal] = GLRT_exhaustSearch(Y,uniConstel,mapBits);
    blkErr_GLRT = blkErr_GLRT + (sum(xor(txBit,RxBit))>0);
    bitErr_GLRT = bitErr_GLRT + sum(xor(txBit,RxBit));
end
    
BER_iMAPsortDFDD = bitErr_iMAPsortDFDD / numRand / l_v;
BLER_iMAPsortDFDD = blkErr_iMAPsortDFDD / numRand;

BER_MAPsortDFDD = bitErr_MAPsortDFDD / numRand / l_v;
BLER_MAPsortDFDD = blkErr_MAPsortDFDD / numRand;

BER_GLRT = bitErr_GLRT / numRand / l_v;
BLER_GLRT = blkErr_GLRT / numRand;