module Cipher #(parameter Nk = 4, parameter Nr = 10) (clk, reset_n, in, round_keys, out, done);

localparam Nb = 4;
localparam WORD_SIZE = 32;
localparam KEY_SIZE = 128;
localparam BLOCK_SIZE = 128;
localparam INPUT_KEY_SIZE = Nk * WORD_SIZE;
localparam NUMBER_OF_GENERATED_WORDS = Nb * (Nr + 1);
localparam ROUND_KEYS_SIZE = WORD_SIZE * NUMBER_OF_GENERATED_WORDS;

input clk, reset_n;
input [BLOCK_SIZE - 1 : 0] in;
input [ROUND_KEYS_SIZE - 1 : 0] round_keys;
output [BLOCK_SIZE - 1 : 0] out;
output done;

reg [BLOCK_SIZE - 1 : 0] ARK_in, state_reg;
wire [BLOCK_SIZE-1:0] ARK_out, SB_out, SR_out, MC_out, state_next;
reg [KEY_SIZE-1:0] ARK_key;

SubBytes SB(.in(state_reg), .out(SB_out));
ShiftRows SR(.in(SB_out), .out(SR_out));
MixColumns MC(.in(SR_out), .out(MC_out));
AddRoundKey ARK(.in(ARK_in), .key(ARK_key), .out(state_next));

reg [3:0] i, i_next;

always @(*) begin
    i_next = (i == Nr) ? 0 : i + 1;
    ARK_key = round_keys[ROUND_KEYS_SIZE - i * KEY_SIZE - 1 -: KEY_SIZE];
    ARK_in = (i == 1'b0) ? in : (i == Nr) ? SR_out : MC_out;
end

always @(posedge clk, negedge reset_n) begin
    if(~reset_n) begin
        state_reg <= 0;
    end else begin
        state_reg <= state_next;
    end
end

always @(negedge clk, negedge reset_n) begin
    if(~reset_n) begin
        i <= 0;
    end else begin
        i <= i_next;
    end
end

assign out = state_reg;
assign done = (i == Nr) ? 1'b1 : 1'b0;

endmodule