# AES-Verilog-HDL
Implementation of AES with different key sizes (128, 192, 256) using Verilog  
## Simulation Results

Shown here are the simulation results for the testcases described in *Appendix C – Example Vectors* in the [AES NIST.FIPS.197](https://pages.github.com/) standard.  

### AES-128
![AES-128-output](https://github.com/alhusseingamal/AES-Verilog-HDL/blob/main/screenshots/Simulation/AES_128_tb%20output.png)

### AES-192
![AES-192-output](https://github.com/alhusseingamal/AES-Verilog-HDL/blob/main/screenshots/Simulation/AES_192_tb%20output.png)

### AES-256
![AES-128-output](https://github.com/alhusseingamal/AES-Verilog-HDL/blob/main/screenshots/Simulation/AES_256_tb%20output.png)

## FPGA Output
The output on the FPGA 7-segment HEX display is the last 4 hexadecimal digits of each encryption/decryption round.
So after (Nr+1) Encryption rounds the last 4 digits of the encrypted message is shown.
### Encryption Output
![FPGA-encryption-output](https://github.com/alhusseingamal/AES-Verilog-HDL/blob/main/screenshots/FPGA%20-%20Encryption%20Output.jpeg)

So after (Nr+1) Decyryption rounds the last 4 digits of the decrypted message is shown; that is the last 4 digits of the original message.
![FPGA-decryption-output](https://github.com/alhusseingamal/AES-Verilog-HDL/blob/main/screenshots/FPGA%20-%20Decryption%20Output.jpeg)
