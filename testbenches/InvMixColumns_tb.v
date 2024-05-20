`timescale 1ps / 1ps
module InvMixColumns_tb;

reg [127:0] in;
wire [127:0] out;
InvMixColumns dut(
    .in(in),
    .out(out)
);

reg [127:0] expected_out = 128'h4773b91ff72f354361cb018ea1e6cf2c;

initial
begin
    in = 128'hbd6e7c3df2b5779e0b61216e8b10b689; // output from InvShiftRows
    #1;

    if (out == expected_out) begin
        $display("Test passed");
    end else begin
        $display("Test failed: expected %h, got %h", expected_out, out);
    end
end

endmodule