module AES #(parameter Nk = 4, parameter Nr = 10) (KEY3, SW, HEX0, HEX1, HEX2, HEX3);

localparam Nb = 4;
localparam WORD_SIZE = 32;
localparam BYTE_SIZE = 8;
localparam NUMBER_OF_GENERATED_WORDS = Nb * (Nr + 1);
localparam ROUND_KEYS_SIZE = WORD_SIZE * NUMBER_OF_GENERATED_WORDS;
localparam KEY_SIZE = Nk * WORD_SIZE;
localparam BLOCK_SIZE = 128;


wire [BLOCK_SIZE - 1 : 0] encryption_out_128;
wire [BLOCK_SIZE - 1 : 0] decryption_out_128;
wire [BLOCK_SIZE - 1 : 0] encryption_out_192;
wire [BLOCK_SIZE - 1 : 0] decryption_out_192;
wire [BLOCK_SIZE - 1 : 0] encryption_out_256;
wire [BLOCK_SIZE - 1 : 0] decryption_out_256;

wire [1407 : 0] round_keys_128;
wire [1663 : 0] round_keys_192;
wire [1919 : 0] round_keys_256;

reg [BLOCK_SIZE - 1 : 0] in = 128'h00112233445566778899aabbccddeeff;

// 128
reg [127:0] key_128 = 128'h000102030405060708090a0b0c0d0e0f;
reg [127:0] expected_encryption_out_128 = 128'h69c4e0d86a7b0430d8cdb78070b4c55a;
// 192
reg [191:0] key_192 = 192'h000102030405060708090a0b0c0d0e0f1011121314151617;
reg [127:0] expected_encryption_out_192 = 128'hdda97ca4864cdfe06eaf70a0ec0d7191;
// 256
reg [255:0] key_256 = 256'h000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f;
reg [127:0] expected_encryption_out_256 = 128'h8ea2b7ca516745bfeafc49904b496089;

reg [127:0] expected_decryption_out = 128'h00112233445566778899aabbccddeeff;


input KEY3;
input [9:0] SW;
output [6:0] HEX0, HEX1, HEX2, HEX3;

wire encryption_done, decryption_done;

KeyExpansion #(.Nk(4), .Nr(10)) KeyExpansion_instance128(.key_in(key_128), .round_keys(round_keys_128));
Cipher #(.Nk(4), .Nr(10)) Cipher_instance128(.clk(KEY3), .reset_n(SW[0]), .in(in),
.round_keys(round_keys_128), .out(encryption_out_128));
InvCipher #(.Nk(4), .Nr(10)) InvCipher_instance128(.clk(KEY3), .reset_n(SW[0]),
.in(encryption_out_128), .round_keys(round_keys_128), .out(decryption_out_128));

KeyExpansion #(.Nk(6), .Nr(12)) KeyExpansion_instance192(.key_in(key_192), .round_keys(round_keys_192));
Cipher #(.Nk(6), .Nr(12)) Cipher_instance192(.clk(KEY3), .reset_n(SW[0]), .in(in),
.round_keys(round_keys_192), .out(encryption_out_192));
InvCipher #(.Nk(6), .Nr(12)) InvCipher_instance192(.clk(KEY3), .reset_n(SW[0]), .in(encryption_out_192), .round_keys(round_keys_192),
.out(decryption_out_192));


KeyExpansion #(.Nk(8), .Nr(14)) KeyExpansion_instance256(.key_in(key_256), .round_keys(round_keys_256));
Cipher #(.Nk(8), .Nr(14)) Cipher_instance256(.clk(KEY3), .reset_n(SW[0]), .in(in), .round_keys(round_keys_256), .out(encryption_out_256));
InvCipher #(.Nk(8), .Nr(14)) InvCipher_instance256(.clk(KEY3), .reset_n(SW[0]), .in(encryption_out_256), .round_keys(round_keys_256),
.out(decryption_out_256));

reg DisplaySelector;
reg [4:0] count_128 = 5'b00000;
reg [4:0] count_192 = 5'b00000;
reg [5:0] count_256 = 6'b000000;

always @(posedge KEY3) begin
    case (SW[9:7])
        3'b001 : begin
            count_256 = count_256 + 1;
            if (count_256 <= 5'b10000) begin
                DisplaySelector = 1;
            end else begin
                DisplaySelector = 0;
            end
            if (count_256 % 6'b100000 == 0) begin
                count_256 = 6'b000000;
            end
            count_128 = 5'b00000;
            count_192 = 5'b00000;
        end
        3'b010 : begin
            count_192 = count_192 + 1;
            if (count_192 <= 5'b01110) begin
                DisplaySelector = 1;
            end else begin
                DisplaySelector = 0;
            end
            if (count_192 % 5'b110100 == 0) begin
                count_192 = 5'b000000;
            end
            count_128 = 5'b00000;
            count_256 = 6'b000000;            
        end
        default : begin
            count_128 = count_128 + 1;
            if (count_128 <= 5'b01100) begin
                DisplaySelector = 1;
            end else begin
                DisplaySelector = 0;
            end
            if (count_128 % 5'b11000 == 0) begin
                count_128 = 5'b00000;
            end
            count_192 = 5'b00000;
            count_256 = 6'b000000;
        end
    endcase
end

reg [7:0] byte0, byte1;

always @(DisplaySelector, SW[9:7])
begin
    if(SW[7] == 1'b1) begin
        byte0 = DisplaySelector == 1 ? encryption_out_256[7:0] : decryption_out_256[7:0];
        byte1 = DisplaySelector == 1 ? encryption_out_256[15:8] : decryption_out_256[15:8];
    end else if(SW[8] == 1'b1) begin
        byte0 = DisplaySelector == 1 ? encryption_out_192[7:0] : decryption_out_192[7:0];
        byte1 = DisplaySelector == 1 ? encryption_out_192[15:8] : decryption_out_192[15:8];
    end else begin
        byte0 = DisplaySelector == 1 ? encryption_out_128[7:0] : decryption_out_128[7:0];
        byte1 = DisplaySelector == 1 ? encryption_out_128[15:8] : decryption_out_128[15:8];
    end
end

sevenSegmentDecoder sevenSeg_instance0(.SW(byte0), .HEX0(HEX0), .HEX1(HEX1));
sevenSegmentDecoder sevenSeg_instance1(.SW(byte1), .HEX0(HEX2), .HEX1(HEX3));

endmodule