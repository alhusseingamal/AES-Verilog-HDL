`timescale 1ps / 1ps
module AES_256_tb;

localparam Nb = 4;
localparam Nk = 8;
localparam Nr = 14;

reg clk;
reg reset_n;
reg [127:0] in;
reg [255:0] key;
wire [1919:0] round_keys; // WordSize * Nb(Nr + 1) = 32 * 4(14 + 1) = 1920
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
reg [1919:0] expected_key_expansion = 1920'h000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1fa573c29fa176c498a97fce93a572c09c1651a8cd0244beda1a5da4c10640badeae87dff00ff11b68a68ed5fb03fc15676de1f1486fa54f9275f8eb5373b8518dc656827fc9a799176f294cec6cd5598b3de23a75524775e727bf9eb45407cf390bdc905fc27b0948ad5245a4c1871c2f45f5a66017b2d387300d4d33640a820a7ccff71cbeb4fe5413e6bbf0d261a7dff01afafee7a82979d7a5644ab3afe6402541fe719bf500258813bbd55a721c0a4e5a6699a9f24fe07e572baacdf8cdea24fc79ccbf0979e9371ac23c6d68de36;
// Test 1
reg [127:0] expected_encryption_out_1 = 128'h8ea2b7ca516745bfeafc49904b496089;
reg [127:0] expected_decryption_out_1 = 128'h00112233445566778899aabbccddeeff;

initial
begin
    clk = 1'b0;
    reset_n = 1'b0;
    key = 256'h000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f;
    in = 128'h00112233445566778899aabbccddeeff;
    #1
    reset_n = 1'b1;
    if (round_keys == expected_key_expansion) begin // assert key expansion
        $display("AES-256 : Key Expansion successful");
    end else begin
        $display("AES-256 : Key Expansion failed");
    end

    #(CLK_PERIOD * (Nr + 1)); // the encryption is completed after (Nr + 1) cycles

    if (encryption_out == expected_encryption_out_1) begin
        $display("AES-256 : Test 1 Encryption passed");
    end else begin
        $display("AES-256 : Test 1 Encryption failed");
    end
    
    #(CLK_PERIOD * (Nr + 1)); // the decryption is completed after (Nr + 1) cycles

    if (decryption_out == expected_decryption_out_1) begin
        $display("AES-256 : Test 1 Decryption passed");
    end else begin
        $display("AES-256 : Test 1 Decryption failed");
    end
end
endmodule