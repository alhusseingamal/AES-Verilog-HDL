`timescale 1ps / 1ps
module AES_128_tb;

localparam Nb = 4;
localparam Nk = 4;
localparam Nr = 10;

reg clk;
reg reset_n;
reg [127:0] in;
reg [127:0] key;
wire [1407:0] round_keys; // WordSize * Nb(Nr + 1) = 32 * 4(10 + 1) = 1408
wire [127:0] encryption_out;
wire [127:0] decryption_out;

AES #(.Nk(Nk), .Nr(Nr)) dut(
    .clk(clk),
    .reset_n(reset_n),
    .in(in),
    .key(key),
    .round_keys(round_keys),
    .encryption_out(encryption_out),
    .decryption_out(decryption_out)
);

localparam CLK_PERIOD = 2;
always
    # (CLK_PERIOD/2) clk = ~clk;

// Expanded Key
reg [1407:0] expected_key_expansion = 1408'h000102030405060708090a0b0c0d0e0fd6aa74fdd2af72fadaa678f1d6ab76feb692cf0b643dbdf1be9bc5006830b3feb6ff744ed2c2c9bf6c590cbf0469bf4147f7f7bc95353e03f96c32bcfd058dfd3caaa3e8a99f9deb50f3af57adf622aa5e390f7df7a69296a7553dc10aa31f6b14f9701ae35fe28c440adf4d4ea9c02647438735a41c65b9e016baf4aebf7ad2549932d1f08557681093ed9cbe2c974e13111d7fe3944a17f307a78b4d2b30c5;
// Test 1
reg [127:0] expected_encryption_out_1 = 128'h69c4e0d86a7b0430d8cdb78070b4c55a;
reg [127:0] expected_decryption_out_1 = 128'h00112233445566778899aabbccddeeff;

// Test 2
reg [127:0] expected_encryption_out_2 = 128'h29C3505F_571420F6_402299B3_1A02D73A; 
reg [127:0] expected_decryption_out_2 = 128'h54776F20_4F6E6520_4E696E65_2054776F;
initial
begin
    clk = 1'b0;
    reset_n = 1'b0;
    in = 128'h0;
    key = 128'h000102030405060708090a0b0c0d0e0f;
    #11
    reset_n = 1'b1;
    # (CLK_PERIOD * (Nb*(Nr+1) - (Nk-1)) + 10); // The time until the key is expanded
    if (round_keys == expected_key_expansion) begin
        $display("Key Expansion successful");
    end else begin
        $display("Key Expansion failed");
    end
    
    in = 128'h00112233445566778899aabbccddeeff;
    #100
    

    if (encryption_out == expected_encryption_out_1 /*&& decryption_out == expected_decryption_out_1*/) begin
        $display("Test 1 passed");
    end else begin
        $display("Test 1 failed");
    end

    $stop;
    
end

endmodule