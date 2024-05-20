module KeyExpansion #(parameter Nk = 4, parameter Nr = 10) (
    key_in,
    round_keys
);

localparam Nb = 4;
localparam WORD_SIZE = 32;
localparam BYTE_SIZE = 8;

localparam INPUT_KEY_SIZE = Nk * WORD_SIZE;
localparam NUMBER_OF_GENERATED_WORDS = Nb * (Nr + 1);
localparam ROUND_KEYS_SIZE = WORD_SIZE * NUMBER_OF_GENERATED_WORDS;


input [INPUT_KEY_SIZE - 1 : 0] key_in;
output [ROUND_KEYS_SIZE - 1 : 0] round_keys;


// ----------- Auxiliary Functions ------------

// RotWord() takes a word [a0, a1, a2, a3] as input, performs a one-byte circular left shift, and returns the word [a1, a2, a3, a0].    
function [31:0] RotWord(input [31:0] word);
    RotWord = {word[23:0], word[31:24]};
endfunction

// SubWord() takes a four-byte input word and applies the S-Box to each of the four bytes to produce an output word.
function [31:0] SubWord(input [31:0] word);
    begin
        SubWord[31:24] = sB(word[31:24]);
        SubWord[23:16] = sB(word[23:16]);
        SubWord[15:8] = sB(word[15:8]);
        SubWord[7:0] = sB(word[7:0]);
    end
endfunction

// sB is the S-Box transformation, which is a table lookup that replaces each byte of the input word with a corresponding byte from the S-Box.
function [7:0] sB(input [7:0] word);
    begin
        case (word)
            8'h00: sB = 8'h63;
	        8'h01: sB = 8'h7c;
	        8'h02: sB = 8'h77;
            8'h03: sB = 8'h7b;
            8'h04: sB = 8'hf2;
            8'h05: sB = 8'h6b;
            8'h06: sB = 8'h6f;
            8'h07: sB = 8'hc5;
            8'h08: sB = 8'h30;
            8'h09: sB = 8'h01;
            8'h0a: sB = 8'h67;
            8'h0b: sB = 8'h2b;
            8'h0c: sB = 8'hfe;
            8'h0d: sB = 8'hd7;
            8'h0e: sB = 8'hab;
            8'h0f: sB = 8'h76;
            8'h10: sB = 8'hca;
            8'h11: sB = 8'h82;
            8'h12: sB = 8'hc9;
            8'h13: sB = 8'h7d;
            8'h14: sB = 8'hfa;
            8'h15: sB = 8'h59;
            8'h16: sB = 8'h47;
            8'h17: sB = 8'hf0;
            8'h18: sB = 8'had;
            8'h19: sB = 8'hd4;
            8'h1a: sB = 8'ha2;
            8'h1b: sB = 8'haf;
            8'h1c: sB = 8'h9c;
            8'h1d: sB = 8'ha4;
            8'h1e: sB = 8'h72;
            8'h1f: sB = 8'hc0;
            8'h20: sB = 8'hb7;
            8'h21: sB = 8'hfd;
            8'h22: sB = 8'h93;
            8'h23: sB = 8'h26;
            8'h24: sB = 8'h36;
            8'h25: sB = 8'h3f;
            8'h26: sB = 8'hf7;
            8'h27: sB = 8'hcc;
            8'h28: sB = 8'h34;
            8'h29: sB = 8'ha5;
            8'h2a: sB = 8'he5;
            8'h2b: sB = 8'hf1;
            8'h2c: sB = 8'h71;
            8'h2d: sB = 8'hd8;
            8'h2e: sB = 8'h31;
            8'h2f: sB = 8'h15;
            8'h30: sB = 8'h04;
            8'h31: sB = 8'hc7;
            8'h32: sB = 8'h23;
            8'h33: sB = 8'hc3;
            8'h34: sB = 8'h18;
            8'h35: sB = 8'h96;
            8'h36: sB = 8'h05;
            8'h37: sB = 8'h9a;
            8'h38: sB = 8'h07;
            8'h39: sB = 8'h12;
            8'h3a: sB = 8'h80;
            8'h3b: sB = 8'he2;
            8'h3c: sB = 8'heb;
            8'h3d: sB = 8'h27;
            8'h3e: sB = 8'hb2;
            8'h3f: sB = 8'h75;
            8'h40: sB = 8'h09;
            8'h41: sB = 8'h83;
            8'h42: sB = 8'h2c;
            8'h43: sB = 8'h1a;
            8'h44: sB = 8'h1b;
            8'h45: sB = 8'h6e;
            8'h46: sB = 8'h5a;
            8'h47: sB = 8'ha0;
            8'h48: sB = 8'h52;
            8'h49: sB = 8'h3b;
            8'h4a: sB = 8'hd6;
            8'h4b: sB = 8'hb3;
            8'h4c: sB = 8'h29;
            8'h4d: sB = 8'he3;
            8'h4e: sB = 8'h2f;
            8'h4f: sB = 8'h84;
            8'h50: sB = 8'h53;
            8'h51: sB = 8'hd1;
            8'h52: sB = 8'h00;
            8'h53: sB = 8'hed;
            8'h54: sB = 8'h20;
            8'h55: sB = 8'hfc;
            8'h56: sB = 8'hb1;
            8'h57: sB = 8'h5b;
            8'h58: sB = 8'h6a;
            8'h59: sB = 8'hcb;
            8'h5a: sB = 8'hbe;
            8'h5b: sB = 8'h39;
            8'h5c: sB = 8'h4a;
            8'h5d: sB = 8'h4c;
            8'h5e: sB = 8'h58;
            8'h5f: sB = 8'hcf;
            8'h60: sB = 8'hd0;
            8'h61: sB = 8'hef;
            8'h62: sB = 8'haa;
            8'h63: sB = 8'hfb;
            8'h64: sB = 8'h43;
            8'h65: sB = 8'h4d;
            8'h66: sB = 8'h33;
            8'h67: sB = 8'h85;
            8'h68: sB = 8'h45;
            8'h69: sB = 8'hf9;
            8'h6a: sB = 8'h02;
            8'h6b: sB = 8'h7f;
            8'h6c: sB = 8'h50;
            8'h6d: sB = 8'h3c;
            8'h6e: sB = 8'h9f;
            8'h6f: sB = 8'ha8;
            8'h70: sB = 8'h51;
            8'h71: sB = 8'ha3;
            8'h72: sB = 8'h40;
            8'h73: sB = 8'h8f;
            8'h74: sB = 8'h92;
            8'h75: sB = 8'h9d;
            8'h76: sB = 8'h38;
            8'h77: sB = 8'hf5;
            8'h78: sB = 8'hbc;
            8'h79: sB = 8'hb6;
            8'h7a: sB = 8'hda;
            8'h7b: sB = 8'h21;
            8'h7c: sB = 8'h10;
            8'h7d: sB = 8'hff;
            8'h7e: sB = 8'hf3;
            8'h7f: sB = 8'hd2;
            8'h80: sB = 8'hcd;
            8'h81: sB = 8'h0c;
            8'h82: sB = 8'h13;
            8'h83: sB = 8'hec;
            8'h84: sB = 8'h5f;
            8'h85: sB = 8'h97;
            8'h86: sB = 8'h44;
            8'h87: sB = 8'h17;
            8'h88: sB = 8'hc4;
            8'h89: sB = 8'ha7;
            8'h8a: sB = 8'h7e;
            8'h8b: sB = 8'h3d;
            8'h8c: sB = 8'h64;
            8'h8d: sB = 8'h5d;
            8'h8e: sB = 8'h19;
            8'h8f: sB = 8'h73;
            8'h90: sB = 8'h60;
            8'h91: sB = 8'h81;
            8'h92: sB = 8'h4f;
            8'h93: sB = 8'hdc;
            8'h94: sB = 8'h22;
            8'h95: sB = 8'h2a;
            8'h96: sB = 8'h90;
            8'h97: sB = 8'h88;
            8'h98: sB = 8'h46;
            8'h99: sB = 8'hee;
            8'h9a: sB = 8'hb8;
            8'h9b: sB = 8'h14;
            8'h9c: sB = 8'hde;
            8'h9d: sB = 8'h5e;
            8'h9e: sB = 8'h0b;
            8'h9f: sB = 8'hdb;
            8'ha0: sB = 8'he0;
            8'ha1: sB = 8'h32;
            8'ha2: sB = 8'h3a;
            8'ha3: sB = 8'h0a;
            8'ha4: sB = 8'h49;
            8'ha5: sB = 8'h06;
            8'ha6: sB = 8'h24;
            8'ha7: sB = 8'h5c;
            8'ha8: sB = 8'hc2;
            8'ha9: sB = 8'hd3;
            8'haa: sB = 8'hac;
            8'hab: sB = 8'h62;
            8'hac: sB = 8'h91;
            8'had: sB = 8'h95;
            8'hae: sB = 8'he4;
            8'haf: sB = 8'h79;
            8'hb0: sB = 8'he7;
            8'hb1: sB = 8'hc8;
            8'hb2: sB = 8'h37;
            8'hb3: sB = 8'h6d;
            8'hb4: sB = 8'h8d;
            8'hb5: sB = 8'hd5;
            8'hb6: sB = 8'h4e;
            8'hb7: sB = 8'ha9;
            8'hb8: sB = 8'h6c;
            8'hb9: sB = 8'h56;
            8'hba: sB = 8'hf4;
            8'hbb: sB = 8'hea;
            8'hbc: sB = 8'h65;
            8'hbd: sB = 8'h7a;
            8'hbe: sB = 8'hae;
            8'hbf: sB = 8'h08;
            8'hc0: sB = 8'hba;
            8'hc1: sB = 8'h78;
            8'hc2: sB = 8'h25;
            8'hc3: sB = 8'h2e;
            8'hc4: sB = 8'h1c;
            8'hc5: sB = 8'ha6;
            8'hc6: sB = 8'hb4;
            8'hc7: sB = 8'hc6;
            8'hc8: sB = 8'he8;
            8'hc9: sB = 8'hdd;
            8'hca: sB = 8'h74;
            8'hcb: sB = 8'h1f;
            8'hcc: sB = 8'h4b;
            8'hcd: sB = 8'hbd;
            8'hce: sB = 8'h8b;
            8'hcf: sB = 8'h8a;
            8'hd0: sB = 8'h70;
            8'hd1: sB = 8'h3e;
            8'hd2: sB = 8'hb5;
            8'hd3: sB = 8'h66;
            8'hd4: sB = 8'h48;
            8'hd5: sB = 8'h03;
            8'hd6: sB = 8'hf6;
            8'hd7: sB = 8'h0e;
            8'hd8: sB = 8'h61;
            8'hd9: sB = 8'h35;
            8'hda: sB = 8'h57;
            8'hdb: sB = 8'hb9;
            8'hdc: sB = 8'h86;
            8'hdd: sB = 8'hc1;
            8'hde: sB = 8'h1d;
            8'hdf: sB = 8'h9e;
            8'he0: sB = 8'he1;
            8'he1: sB = 8'hf8;
            8'he2: sB = 8'h98;
            8'he3: sB = 8'h11;
            8'he4: sB = 8'h69;
            8'he5: sB = 8'hd9;
            8'he6: sB = 8'h8e;
            8'he7: sB = 8'h94;
            8'he8: sB = 8'h9b;
            8'he9: sB = 8'h1e;
            8'hea: sB = 8'h87;
            8'heb: sB = 8'he9;
            8'hec: sB = 8'hce;
            8'hed: sB = 8'h55;
            8'hee: sB = 8'h28;
            8'hef: sB = 8'hdf;
            8'hf0: sB = 8'h8c;
            8'hf1: sB = 8'ha1;
            8'hf2: sB = 8'h89;
            8'hf3: sB = 8'h0d;
            8'hf4: sB = 8'hbf;
            8'hf5: sB = 8'he6;
            8'hf6: sB = 8'h42;
            8'hf7: sB = 8'h68;
            8'hf8: sB = 8'h41;
            8'hf9: sB = 8'h99;
            8'hfa: sB = 8'h2d;
            8'hfb: sB = 8'h0f;
            8'hfc: sB = 8'hb0;
            8'hfd: sB = 8'h54;
            8'hfe: sB = 8'hbb;
            8'hff: sB = 8'h16;            
        endcase
    end
endfunction


// Rcon[i]: is the i-th value of the round constant word array, which is used in the key schedule.
function [31:0] Rcon(input [3:0]i);
    begin
        case(i) 
            4'h1 : Rcon = 32'h01000000;
            4'h2 : Rcon = 32'h02000000;
            4'h3 : Rcon = 32'h04000000;
            4'h4 : Rcon = 32'h08000000;
            4'h5 : Rcon = 32'h10000000;
            4'h6 : Rcon = 32'h20000000;
            4'h7 : Rcon = 32'h40000000;
            4'h8 : Rcon = 32'h80000000;
            4'h9 : Rcon = 32'h1b000000;
            4'hA : Rcon = 32'h36000000;
            default : Rcon = 32'h00000000;
        endcase
    end
endfunction

// ----------- Key Expansion ------------

// the first Nk words of the expanded key are filled with the Cipher Key.
assign round_keys[ROUND_KEYS_SIZE - 1 : ROUND_KEYS_SIZE - INPUT_KEY_SIZE] = key_in;

genvar i;
generate    
    begin
        for(i = Nk; i < NUMBER_OF_GENERATED_WORDS; i = i + 1) begin : key_expansion
            wire [WORD_SIZE - 1 : 0] temp1, temp2;
            assign temp1 = round_keys[ROUND_KEYS_SIZE - (i - 1) * WORD_SIZE - 1 -: WORD_SIZE];
            if(i % Nk == 0) begin
                assign temp2 = SubWord(RotWord(temp1)) ^ Rcon(i / Nk);
            end
            else if (Nk > 6 && i % Nk == 4) begin
                assign temp2 = SubWord(temp1);
            end            
            else begin
                assign temp2 = temp1;
            end
            assign round_keys[ROUND_KEYS_SIZE - i * WORD_SIZE - 1 -: WORD_SIZE] = 
                round_keys[ROUND_KEYS_SIZE - (i - Nk) * WORD_SIZE - 1 -: WORD_SIZE] ^ temp2;
        end
    end
endgenerate

endmodule


/*
The AES algorithm 

- KeyExpansion(): generates the key schedule from the initial key.

- Cipher Key(K) ----Key Expansion routine----> generate a key schedule.
- The Key Expansion generates a total of Nb(Nr+1) words, where each word is 4 bytes long.
- The algorithm requires an initial set of Nb words, which are copied from the original key.
- Each of the Nr rounds requires Nb words of key data
- The key is copied into the first Nk words of the key schedule.
- The resulting key schedule consists of a linear array of 4-byte words, denoted [w(0), w(1), ..., w(Nb*(Nr+1)-1)].

- SubWord(): takes a four-byte input word and applies the S-Box to each of the four bytes to produce an output word.
- RotWord(): takes a word [a0, a1, a2, a3] as input, performs a one-byte circular left shift, and returns the word [a1, a2, a3, a0].
- Rcon[i]: is the i-th value of the round constant word array, which is used in the key schedule.
    Rcon[i] contains the values given by [x^(i-1), 0, 0, 0], where x is the primitive polynomial of the Galois field.   


The first Nk words of the expanded key are filled with the Cipher Key.
- Every following word, w[i], is equal to the XOR of the previous word, w[i - 1], and the word Nk positions before it.

For words in positions that are a multiple of Nk,
a transformation is applied to w[i-1] prior to the XOR, followed by an XOR with a round constant, Rcon[i].
This transformation consists of a cyclic shift of the bytes in a word (RotWord()), followed by the application of a table
lookup to all four bytes of the word (SubWord()).

*/