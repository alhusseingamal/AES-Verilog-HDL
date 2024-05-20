module AddRoundKey (in, out, key);

    input [127:0] in;
    input [127:0] key;
    output [127:0] out;
    
    assign out = in ^ key;
    
endmodule