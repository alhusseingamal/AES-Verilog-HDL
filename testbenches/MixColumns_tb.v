`timescale 1ps / 1ps
module MixColumns_tb;

reg [127:0] in;
wire [127:0] out;
MixColumns dut(
    .in(in),
    .out(out)
);

reg [127:0] expected_out = 128'h5f72641557f5bc92f7be3b291db9f91a;

initial
begin
    in = 128'h6353e08c0960e104cd70b751bacad0e7; // output from ShiftRows
    #1;

    if (out == expected_out) begin
        $display("Test passed");
    end else begin
        $display("Test failed: expected %h, got %h", expected_out, out);
    end
end

endmodule