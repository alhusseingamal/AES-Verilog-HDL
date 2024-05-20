`timescale 1ps / 1ps
module AddRoundKey_tb;

reg [127:0] in;
reg [127:0] key;
wire [127:0] out;
AddRoundKey dut(
    .in(in),
    .key(key),
    .out(out)
);

reg [127:0] expected_out = 128'h89d810e8855ace682d1843d8cb128fe4;

initial
begin
    in = 128'h5f72641557f5bc92f7be3b291db9f91a; // output from MixColumns
    key = 128'hd6aa74fdd2af72fadaa678f1d6ab76fe; // output from KeyExpansion
    #1;

    if (out == expected_out) begin
        $display("Test passed");
    end else begin
        $display("Test failed: expected %h, got %h", expected_out, out);
    end
end

endmodule