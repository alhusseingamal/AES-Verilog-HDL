vsim AES_128_tb
add wave clk reset_n in key round_keys
add wave encryption_out encryption_done decryption_out decryption_done
add wave expected_key_expansion expected_encryption_out_1 expected_decryption_out_1
run 50ps
wave zoom full