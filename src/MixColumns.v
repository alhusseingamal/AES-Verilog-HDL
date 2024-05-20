module MixColumns(in, out);

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

genvar i;
generate
    for(i = 0; i < 4; i = i + 1)
    begin: mix_columns
        assign out[(i * 32 + 24) +: 8] = mul2(in[(i * 32 + 24) +: 8]) ^ 
            mul3(in[(i * 32 + 16) +: 8]) ^ in[(i * 32 + 8) +: 8] ^ in[(i * 32) +: 8];
        
        assign out[(i * 32 + 16) +: 8] = in[(i * 32 + 24) +: 8] ^
            mul2(in[(i * 32 + 16) +: 8]) ^ mul3(in[(i * 32 + 8) +: 8]) ^ in[(i * 32) +: 8];
        
        assign out[(i * 32 + 8) +: 8] = in[(i * 32 + 24) +: 8] ^ in[(i * 32 + 16) +: 8] ^ 
            mul2(in[(i * 32 + 8) +: 8]) ^ mul3(in[(i * 32) +: 8]);

        assign out[(i * 32) +: 8] = mul3(in[(i * 32 + 24) +: 8]) ^ in[(i * 32 + 16) +: 8] ^ 
            in[(i * 32 + 8) +: 8] ^ mul2(in[(i * 32) +: 8]);
    end
endgenerate



endmodule

/*
The MixColumns function in AES (Advanced Encryption Standard) is a transformation that operates on
the State column-by-column, treating each column as a four-term polynomial.
The columns are considered as polynomials over GF(2^8) and multiplied modulo x^4+1
with a fixed polynomial a(x) = {03}x^3 + {01}x^2 + {01}x + {02}.

The multiplication by {02} (or 2 in decimal) is a special case in the field GF(2^8).
It can be implemented as a 1-bit left shift, followed by a conditional bitwise XOR
with {1b} (or 0x1b in hexadecimal) if the leftmost bit of the original byte (before the shift) is 1.
This is because the field GF(2^8) is defined with respect to the irreducible polynomial x^8 + x^4 + x^3 + x + 1,
which is {1b} in hexadecimal.

This operation ensures that multiplication by 2 in the field GF(2^8) doesn't result in a byte value greater than
{ff} (or 255 in decimal), which would not be a valid byte value. The conditional XOR with {1b} effectively
performs a modulo operation with the irreducible polynomial, ensuring the result stays within the valid range
of byte values.

The multiplication by {03} (or 3 in decimal) is implemented as a multiplication by {02} followed by a bitwise XOR
with the original byte. This is because {03} can be expressed as {02} + {01} in the field GF(2^8), and the multiplication
by {02} has already been defined.

Addition in the field GF(2^8) is equivalent to the bitwise XOR operation, which is used in the MixColumns transformation
*/