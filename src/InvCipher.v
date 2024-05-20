module InvCipher #(parameter Nk = 4, parameter Nr = 10) (clk, reset_n, in, round_keys, out, done);

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

reg [KEY_SIZE - 1:0] ARK_key;
reg [BLOCK_SIZE - 1 : 0] ARK_in, state_reg, state_next;
wire [BLOCK_SIZE-1:0] ARK_out, ISB_out, ISR_out, IMC_out;

InvShiftRows ISR(.in(state_reg), .out(ISR_out));
InvSubBytes ISB(.in(ISR_out), .out(ISB_out));
AddRoundKey ARK(.in(ARK_in), .key(ARK_key), .out(ARK_out));
InvMixColumns IMC(.in(ARK_out), .out(IMC_out));

reg [3:0] i, i_next;

always @(*) begin
    i_next = (i == Nr) ? 0 : i + 1;
    ARK_key = round_keys[KEY_SIZE * (i + 1) - 1 -: KEY_SIZE];
    ARK_in = (i == 0) ? in : ISB_out;
    state_next = (i == Nr || i == 0) ? ARK_out : IMC_out;
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
assign done = (i == Nr) ? 1 : 0;

endmodule