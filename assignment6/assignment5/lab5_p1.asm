LDUR  X9, [XZR, 0]            11111000010000000000001111101001
ADD   X9, X9, X9              10001011000010010000000100101001
ADD   X10, X9, X9             10001011000010010000000100101010
SUB   X11, X10, X9            11001011000010010000000101001011
STUR  X11, [XZR, 8]           11111000000000001000001111101011
STUR  X11, [XZR, 12]          11111000000000001100001111101011
NOP                           filled with zero - see imem
NOP                           filled with zero - see imem
NOP                           filled with zero - see imem
NOP                           filled with zero - see imem
