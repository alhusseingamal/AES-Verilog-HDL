module InvSubBytes(in, out);
    
    input [127:0] in;
    output [127:0] out;

    genvar i;
    generate
        for(i = 0; i < 128; i = i + 8)
        begin: inv_sub_bytes
            InvSBox invSBox_instance(in[i +: 8], out[i +: 8]);
        end
    endgenerate
endmodule