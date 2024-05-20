`timescale 1ps / 1ps
module SubBytes_tb;

reg [127:0] in;
wire [127:0] out;
SubBytes dut(
    .in(in),
    .out(out)
);

reg [127:0] expected_out = 128'h63cab7040953d051cd60e0e7ba70e18c;

initial
begin
    in = 128'h00102030405060708090a0b0c0d0e0f0;
    #1;

    if (out == expected_out) begin
        $display("Test passed");
    end else begin
        $display("Test failed: expected %h, got %h", expected_out, out);
    end
end

endmodule