`timescale 1ps / 1ps
module KeyExpansion_128_tb;

localparam Nb = 4;
localparam Nk = 4;
localparam Nr = 10;

reg clk;
reg reset_n;
reg [127:0] key_in;
wire [1407:0] round_keys; // WordSize * Nb(Nr + 1) = 32 * 4(10 + 1) = 1408
KeyExpansion dut(
    .clk(clk),
    .reset_n(reset_n),
    .key_in(key_in),
    .round_keys(round_keys)
);

localparam CLK_PERIOD = 2;
always
    # (CLK_PERIOD/2) clk = ~clk;


reg [1407:0] expected_out_1 = 1408'h2b7e151628aed2a6abf7158809cf4f3ca0fafe1788542cb123a339392a6c7605f2c295f27a96b9435935807a7359f67f3d80477d4716fe3e1e237e446d7a883bef44a541a8525b7fb671253bdb0bad00d4d1c6f87c839d87caf2b8bc11f915bc6d88a37a110b3efddbf98641ca0093fd4e54f70e5f5fc9f384a64fb24ea6dc4fead27321b58dbad2312bf5607f8d292fac7766f319fadc2128d12941575c006ed014f9a8c9ee2589e13f0cc8b6630ca6;
reg [1407:0] expected_out_2 = 1408'hcbae1d16384e56a69b07111e3f2aeffa2f713063173f66c58c3877dbb3129821e437cd0ef308abcb7f30dc10cc224431732c0a458024a18eff147d9e333639af7e3e7386fe1ad208010eaf963238963969ae61a597b4b3ad96ba1c3ba4828a025ad016eccd64a5415bdeb97aff5c33785013aafa9d770fbbc6a9b6c139f585b93684fce8abf3f3536d5a459254afc02b543e0dc8ffcdfe9b9297bb09c6387b22651f9e7c9ad260e70845dbeece7da0cc;
initial
begin
    clk = 1'b0;
    reset_n = 1'b0;
    key_in = 128'h2b7e1516_28aed2a6_abf71588_09cf4f3c;
    #1
    reset_n = 1'b1;
    # (CLK_PERIOD * (Nb*(Nr+1) - (Nk-1))); // See Note
    if (round_keys == expected_out_1) begin
        $display("Test 1 passed");
    end else begin
        $display("Test 1 failed");
    end

    key_in = 128'hcbae1d16_384e56a6_9b07111e_3f2aeffa;
    # (CLK_PERIOD * (Nb*(Nr+1) - (Nk-1)) + 1)
    if (round_keys == expected_out_2) begin
        $display("Test 2 passed");
    end else begin
        $display("Test 2 failed");
    end
    $stop;
end

endmodule


/*
this is the minimum time at which, for the given CLK_PERIOD and parameters, the key expansion is done
This is 41 clock cycles (+ve clock edges), the first time the KeyExpansion is finished
Nb(Nr+1) is the total number of words, (Nk-1) is here as we compressed the first Nk words into a single cycle,
hence we "saved" (Nk-1) cycles
Needless to say, this can be evaluated at any time later than that


Later on, if we made it that the initial key is assigned in Nk cycles, then the term [-(Nk-1)] should be removed

*/