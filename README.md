# AES-Verilog-HDL - Advanced Encryption Standard (AES-128, AES-192, AES-256)

![AES](https://github.com/alhusseingamal/AES-Verilog-HDL/blob/main/screenshots/AES-logo.jpg)

This repository contains a fully functional implementation of the Advanced Encryption Standard (AES) algorithm in Verilog, suitable for FPGA deployment. The implementation supports AES with key sizes of 128, 192, and 256 bits, providing a robust solution for secure data encryption and decryption in hardware.

## Features
### AES Key Sizes: Supports 128-bit, 192-bit, and 256-bit key lengths.  
### Fully Parameterizable: Easily configurable for different key sizes and operational modes.  
### Optimized for FPGA: Designed and tested for FPGA deployment, ensuring efficient resource utilization and high performance.  
### Modular Design: Clean, modular Verilog code that allows for easy understanding and modification.  

The design is simulated using ModelSim simulator and synthesized using Quartus Prime.

## Code Structure

The code is structured in a hierarchy:
There are 13 code files in addition to the testbenches.
#### First Level
1 - AES.v              : This is the integrated file containing the Cipher and Inverse Cipher algorithms in addition to the KeyExpansion algorithm.
#### Second Level
2 - Cipher.v           : Implements the AES encryption process, including all required rounds.  
3 - InvCipher.v        : Implements the AES decryption process, including all required rounds.  
4 - KeyExpansion.v     : Handles the generation of round keys from the initial key.  
#### Third Level
5 - AddRoundKey.v      : Applies the round key to the state matrix.  
6 - MixColumns.v       : Performs the column mixing transformation in the encryption process.  
7 - ShiftRows.v        : Executes the row shifting transformation in the encryption process.  
8 - SubBytes.v         : Conducts the byte substitution step using the SBox.  
9 - SBox.v             : Contains the substitution box used in the SubBytes step.  
10 - InvMixColumns.v   : Performs the inverse column mixing in the decryption process.  
11 - InvShiftRows.v    : Executes the inverse row shifting in the decryption process.  
12 - InvSubBytes.v     : Conducts the inverse byte substitution step using the InvSBox.  
13 - InvSBox.v         : Contains the inverse substitution box used in the InvSubBytes step.  

### Testbenches

#### Three self-checking testbenches can be found, one for each Key Size:
1 - AES_128_tb.v  
2 - AES_192_tb.v  
3 - AES_256_tb.v  

In additon to the source code, separate testbenches are provided for each module in the "testbenches" directory.  

### FPGA-configurable code

Three addition files can be found under the directory ./src/fpga:  

1 - AES_FPGA.v              : This is the file I used to configure my design and the outputs to be observed on the FPGA.  
2 - AES_sim.v               : This is a file from which you could start if you would like to customize your own setting/outputs on the FPGA.  
3 - sevenSegmentDecoder.v   : In both cases, you may need a 7-segmend decoder to display your outputs on the 7-segment display.  

## Simulation Results

Shown here are the simulation results for the testcases described in *Appendix C – Example Vectors* in the [AES standard](https://github.com/alhusseingamal/AES-Verilog-HDL/blob/main/NIST.FIPS.197.pdf).  

### AES-128
![AES-128-output](https://github.com/alhusseingamal/AES-Verilog-HDL/blob/main/screenshots/Simulation/AES_128_tb%20output.png)

### AES-192
![AES-192-output](https://github.com/alhusseingamal/AES-Verilog-HDL/blob/main/screenshots/Simulation/AES_192_tb%20output.png)

### AES-256
![AES-128-output](https://github.com/alhusseingamal/AES-Verilog-HDL/blob/main/screenshots/Simulation/AES_256_tb%20output.png)

## FPGA Output

The design is was configured on an Altera - Cyclone - DE1-SoC board.

The output on the FPGA 7-segment HEX display is the last 4 hexadecimal digits of each encryption/decryption round.
So after (Nr+1) Encryption rounds the last 4 digits of the encrypted message is shown.
### Encryption Output
![FPGA-encryption-output](https://github.com/alhusseingamal/AES-Verilog-HDL/blob/main/screenshots/FPGA%20-%20Encryption%20Output.jpeg)

So after (Nr+1) Decyryption rounds the last 4 digits of the decrypted message is shown; that is the last 4 digits of the original message.
![FPGA-decryption-output](https://github.com/alhusseingamal/AES-Verilog-HDL/blob/main/screenshots/FPGA%20-%20Decryption%20Output.jpeg)


## Getting Started
### Prerequisites
- Verilog Compiler: A Verilog HDL compiler (e.g., ModelSim, Vivado).
- FPGA Development Tools: Tools such as Xilinx Vivado, Intel Quartus, or any other suitable FPGA development environment.
- To run the simulation, three testbenches are provided.
- All you need to do is to just open modelsim, compile the code, and then either run the testbenches manually as you would normally.
- Or you can simply use the provided do files, as follows:
  ```sh
  do doFiles/aes128.do
  ```
  for the AES_128
  Or
  ```sh
  do doFiles/aes192.do
  ```
  for the AES_192
  Or
   ```sh
  do doFiles/aes256.do
  ```
  for the AES_256

  ## Contributors : AlHussein Gamal
