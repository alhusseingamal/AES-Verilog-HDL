`timescale 1ps / 1ps
module InvShiftRows_tb;

reg [127:0] in;
wire [127:0] out;
InvShiftRows dut(
    .in(in),
    .out(out)
);

reg [127:0] expected_out = 128'h7a9f102789d5f50b2beffd9f3dca4ea7;

initial
begin
    
    in = 128'h7ad5fda789ef4e272bca100b3d9ff59f;
    #1;

    if (out == expected_out) begin
        $display("Test passed");
    end else begin
        $display("Test failed: expected %h, got %h", expected_out, out);
    end
end

endmodule