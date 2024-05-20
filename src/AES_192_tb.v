`timescale 1ps / 1ps
module AES_192_tb;

localparam Nb = 4;
localparam Nk = 6;
localparam Nr = 12;

reg clk;
reg reset_n;
reg [127:0] in;
reg [191:0] key;
wire [1663:0] round_keys; // WordSize * Nb(Nr + 1) = 32 * 4(12 + 1) = 1664
wire [127:0] encryption_out, decryption_out;
wire encryption_done, decryption_done;

AES #(.Nk(Nk), .Nr(Nr)) dut(
    .clk(clk),
    .reset_n(reset_n),
    .in(in),
    .key(key),
    .round_keys(round_keys), // not used but just to avoid compiler warnings
    .encryption_out(encryption_out),
    .decryption_out(decryption_out),
    .encryption_done(encryption_done),
    .decryption_done(decryption_done)
);

localparam CLK_PERIOD = 2;
always
    # (CLK_PERIOD/2) clk = ~clk;

// Expanded Key
reg [1663:0] expected_key_expansion = 1664'h000102030405060708090a0b0c0d0e0f10111213141516175846f2f95c43f4fe544afef55847f0fa4856e2e95c43f4fe40f949b31cbabd4d48f043b810b7b34258e151ab04a2a5557effb5416245080c2ab54bb43a02f8f662e3a95d66410c08f501857297448d7ebdf1c6ca87f33e3ce510976183519b6934157c9ea351f1e01ea0372a995309167c439e77ff12051edd7e0e887e2fff68608fc842f9dcc154859f5f237a8d5a3dc0c02952beefd63ade601e7827bcdf2ca223800fd8aeda32a4970a331a78dc09c418c271e3a41d5d;
// Test 1
reg [127:0] expected_encryption_out_1 = 128'hdda97ca4864cdfe06eaf70a0ec0d7191;
reg [127:0] expected_decryption_out_1 = 128'h00112233445566778899aabbccddeeff;

initial
begin
    clk = 1'b0;
    reset_n = 1'b0;
    key = 192'h000102030405060708090a0b0c0d0e0f1011121314151617;
    in = 128'h00112233445566778899aabbccddeeff; 
    #1
    reset_n = 1'b1;
    if (round_keys == expected_key_expansion) begin // assert key expansion
        $display("AES-192 : Key Expansion successful");
    end else begin
        $display("AES-192 : Key Expansion failed");
    end

    #(CLK_PERIOD * (Nr + 1)); // the encryption is completed after (Nr + 1) cycles
    if (encryption_out == expected_encryption_out_1) begin
        $display("AES-192 : Test 1 Encryption passed");
    end else begin
        $display("AES-192 : Test 1 Encryption failed");
    end
    
    #(CLK_PERIOD * (Nr + 1)); // the decryption is completed after (Nr + 1) cycles

    if (decryption_out == expected_decryption_out_1) begin
        $display("AES-192 : Test 1 Decryption passed");
    end else begin
        $display("AES-192 : Test 1 Decryption failed");
    end
end
endmodule