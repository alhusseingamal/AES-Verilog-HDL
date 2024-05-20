module ShiftRows(
    in,
    out
);

input [127:0] in;
output [127:0] out;

wire [31:0] x0_curr, x1_curr, x2_curr, x3_curr;
wire [31:0] x0_next, x1_next, x2_next, x3_next;

// construct the 4 columns
assign x0_curr = in[127:96];
assign x1_curr = in[95:64];
assign x2_curr = in[63:32];
assign x3_curr = in[31:0];

// shift the rows
assign x0_next = {x0_curr[31:24], x1_curr[23:16], x2_curr[15:8], x3_curr[7:0]}; // no shift
assign x1_next = {x1_curr[31:24], x2_curr[23:16], x3_curr[15:8], x0_curr[7:0]}; // shift left by 8 bits
assign x2_next = {x2_curr[31:24], x3_curr[23:16], x0_curr[15:8], x1_curr[7:0]}; // shift left by 16 bits
assign x3_next = {x3_curr[31:24], x0_curr[23:16], x1_curr[15:8], x2_curr[7:0]}; // shift left by 24 bits

assign out = {x0_next, x1_next, x2_next, x3_next}; // concatenate the 4 rows

endmodule

/*
Explanation:

Given a block of 128 bits, ShiftRows performs a cyclic shift on the rows of the block.

Let's assume that each 8 bits are represented by a letter Si: So the data is represented as: 

{S0, S1, S2, S3, S4, S5, S6, S7, S8, S9, S10, S11, S12, S13, S14, S15}

In matrix Form:

S0 S4 S8  S12
S1 S5 S9  S13
S2 S6 S10 S14
S3 S7 S11 S15

Notice the that the values are arranged in a 4x4 matrix column-wise. This is specified by the AES standard.

It is probably done as such for the sake of the MixColumns transformation, which operates on the columns of the block.

This is inconvenient for the ShiftRows transformation, which requires shifting the rows cyclically.

We have to deal with that.

After the ShiftRows transformation, the data is represented as:

{S0, S5, S10, S15, S4, S9, S14, S3, S8, S13, S2, S7, S12, S1, S6, S11}

In matrix Form:

S0  S4  S8  S12
S5  S9  S13 S1
S10 S14 S2  S6
S15 S3  S7  S11
*/