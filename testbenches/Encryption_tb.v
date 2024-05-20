`timescale 1ps / 1ps
module Encryption_tb;

reg [127:0] in;
reg [127:0] key;
wire [127:0] out;

Encryption dut(
    .in(in),
    .key(key),
    .out(out)
);

reg [127:0] expected_out = 128'h69c4e0d86a7b0430d8cdb78070b4c55a;
initial
begin
    in = 128'h00112233445566778899aabbccddeeff;
    key = 128'h000102030405060708090a0b0c0d0e0f;
    #10;

    if (out == expected_out) begin
        $display("Test passed");
    end else begin
        $display("Test failed");
    end
end

endmodule