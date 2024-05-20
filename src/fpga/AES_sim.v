module AES #(parameter Nk = 4, parameter Nr = 10) (
    clk,
    reset_n,
    encryption_done,
    decryption_done
);

localparam Nb = 4;
localparam WORD_SIZE = 32;
localparam NUMBER_OF_GENERATED_WORDS = Nb * (Nr + 1);
localparam ROUND_KEYS_SIZE = WORD_SIZE * NUMBER_OF_GENERATED_WORDS;
localparam KEY_SIZE = Nk * WORD_SIZE;
localparam BLOCK_SIZE = 128;

input clk, reset_n;
output encryption_done, decryption_done;

reg [BLOCK_SIZE - 1 : 0] in;
reg [KEY_SIZE - 1 : 0] key;
wire [BLOCK_SIZE - 1 : 0] encryption_out, decryption_out;

wire [ROUND_KEYS_SIZE - 1 : 0] round_keys;

KeyExpansion #(.Nk(Nk), .Nr(Nr)) KeyExpansion_instance(
    .key_in(key),
    .round_keys(round_keys)
);

Cipher #(.Nk(Nk), .Nr(Nr)) Cipher_instance(
    .clk(clk),
    .reset_n(reset_n),
    .in(in),
    .round_keys(round_keys),
    .out(encryption_out),
    .done(encryption_done)
);

InvCipher #(.Nk(Nk), .Nr(Nr)) InvCipher_instance(
    .clk(clk),
    .reset_n(reset_n),
    .in(encryption_out),
    .round_keys(round_keys),
    .out(decryption_out),
    .done(decryption_done)
);

endmodule