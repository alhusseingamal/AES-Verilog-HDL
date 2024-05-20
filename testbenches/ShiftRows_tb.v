`timescale 1ps / 1ps
module ShiftRows_tb;

reg [127:0] in;
wire [127:0] out;
ShiftRows dut(
    .in(in),
    .out(out)
);

reg [127:0] expected_out = 128'h6353e08c0960e104cd70b751bacad0e7;

initial
begin
    in = 128'h63cab7040953d051cd60e0e7ba70e18c;
    #1;

    if (out == expected_out) begin
        $display("Test passed");
    end else begin
        $display("Test failed: expected %h, got %h", expected_out, out);
    end
end

endmodule