`timescale 1ps / 1ps
module Decryption_tb;

localparam Nb = 4;
localparam Nk = 4;
localparam Nr = 10;
reg clk;
reg reset_n;
reg [127:0] in;
reg [127:0] key;
wire [127:0] out;

Decryption dut(
    .clk(clk),
    .reset_n(reset_n),
    .in(in),
    .key(key),
    .out(out)
);

reg [127:0] expected_out = 128'h00112233445566778899aabbccddeeff;

localparam CLK_PERIOD = 2;
always
    # (CLK_PERIOD/2) clk = ~clk;
initial
begin
    clk = 1'b0;
    reset_n = 1'b0;
    in = 128'h0;
    key = 128'h000102030405060708090a0b0c0d0e0f;
    #1
    reset_n = 1'b1;
    # (CLK_PERIOD * (Nb*(Nr+1) - (Nk-1)));
    in = 128'h69c4e0d86a7b0430d8cdb78070b4c55a;
    #21;
    if (out == expected_out) begin
        $display("Test passed");
    end else begin
        $display("Test failed");
    end
end

endmodule