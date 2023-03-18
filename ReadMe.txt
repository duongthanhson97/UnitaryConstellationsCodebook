Author: Son Duong - University of Saskatchewan
Email: wve765@usask.ca

Main file: main_test.m
Main encoder: encoder.m
Main decoder: IUAP.m

- K: number of symbols
- l_v: number of bits for unitary constellations
- l_u: number of bits for encoding amplitude vector
- pBitAllo: number of bits for encoding each PSK symbols.
	Ex: pBitAllo = [0,2,3], 1st symbol is reference, 2nd symbol is 4-PSK, 3nd symbol is 8-PSK
- amplitudeSet: codebook of amplitude vectors. Each amplitude vector is a column of amplitudeSet.
- aBitMappingMat: codebook of bit sequence mapping to amplitude set