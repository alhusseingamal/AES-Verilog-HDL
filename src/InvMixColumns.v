module InvMixColumns(in, out);

input [127:0] in;
output [127:0] out;

function [7:0] mul2;
    input [7:0] a;
    begin
        if(a[7] == 1) begin
            mul2 = (a << 1) ^ 8'h1b;
        end
        else begin
            mul2 = a << 1;
        end
    end
endfunction

function [7:0] mul3;
    input [7:0] a;
    begin
        mul3 = mul2(a) ^ a;
    end
endfunction

function [7:0] mul0b;
    input [7:0] a;
    begin
        mul0b = mul2(mul2(mul2(a))) ^ mul2(a) ^ a;
    end
endfunction

function [7:0] mul0d;
    input [7:0] a;
    begin
        mul0d = mul2(mul2(mul2(a))) ^ mul2(mul2(a)) ^ a;
    end
endfunction

function [7:0] mul09;
    input [7:0] a;
    begin
        mul09 = mul2(mul2(mul2(a))) ^ a;
    end
endfunction

function [7:0] mul0e;
    input [7:0] a;
    begin
        mul0e = mul2(mul2(mul2(a))) ^ mul2(mul2(a)) ^ mul2(a);
    end
endfunction

genvar i;
generate
    for(i = 0; i < 4; i = i + 1)
    begin: mix_columns
        assign out[(i * 32 + 24) +: 8] = mul0e(in[(i * 32 + 24) +: 8]) ^ 
            mul0b(in[(i * 32 + 16) +: 8]) ^ mul0d(in[(i * 32 + 8) +: 8]) ^ mul09(in[(i * 32) +: 8]);
        
        assign out[(i * 32 + 16) +: 8] = mul09(in[(i * 32 + 24) +: 8]) ^
            mul0e(in[(i * 32 + 16) +: 8]) ^ mul0b(in[(i * 32 + 8) +: 8]) ^ mul0d(in[(i * 32) +: 8]);
        
        assign out[(i * 32 + 8) +: 8] = mul0d(in[(i * 32 + 24) +: 8]) ^ mul09(in[(i * 32 + 16) +: 8]) ^ 
            mul0e(in[(i * 32 + 8) +: 8]) ^ mul0b(in[(i * 32) +: 8]);

        assign out[(i * 32) +: 8] = mul0b(in[(i * 32 + 24) +: 8]) ^ mul0d(in[(i * 32 + 16) +: 8]) ^ 
            mul09(in[(i * 32 + 8) +: 8]) ^ mul0e(in[(i * 32) +: 8]);
    end
endgenerate


endmodule

/*
The InvMixColumns function in AES (Advanced Encryption Standard) is the inverse of the MixColumns transformation.
It operates on the State column-by-column, treating each column as a four-term polynomial.
The columns are considered as polynomials over GF(2^8) and multiplied modulo x^4+1
with a fixed polynomial a-1(x) = {0b}x^3 + {0d}x^2 + {09}x + {0e}.

The multiplication by {0b} is achieved by:
    multiplication by {02} 3 times which is equivalent to multiplication by {08} XOR
    multiplication by {02} 1 time which is equivalent to multiplication by {02} XOR
    XOR the original value
    Thus multiplication by {0b} is equivalent to multiplication by {08} XOR {02} XOR original value
    ==> 8 + 2 + 1 = 11

The multiplication by {0d} is achieved by:
    multiplication by {02} 3 times which is equivalent to multiplication by {08} XOR
    multiplication by {02} 2 time which is equivalent to multiplication by {04} XOR
    XOR the original value
    Thus multiplication by {0d} is equivalent to multiplication by {08} XOR {04} XOR original value
    ==> 8 + 4 + 1 = 13

The multiplication by {09} is achieved by:
    multiplication by {02} 3 times which is equivalent to multiplication by {08} XOR
    XOR the original value
    Thus multiplication by {09} is equivalent to multiplication by {08} XOR original value
    ==> 8 + 1 = 9

The multiplication by {0e} is achieved by:
    multiplication by {02} 3 times which is equivalent to multiplication by {08} XOR
    multiplication by {02} 2 time which is equivalent to multiplication by {04} XOR
    multiplication by {02} 1 time which is equivalent to multiplication by {02} XOR
    Thus multiplication by {0e} is equivalent to multiplication by {08} XOR {04} XOR {02}
    ==> 8 + 4 + 2 = 14

*/