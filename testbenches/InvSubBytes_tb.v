`timescale 1ps / 1ps
module InvSubBytes_tb;

reg [127:0] in;
wire [127:0] out;
InvSubBytes dut(
    .in(in),
    .out(out)
);

reg [127:0] expected_out = 128'hbdb52189f261b63d0b107c9e8b6e776e;

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