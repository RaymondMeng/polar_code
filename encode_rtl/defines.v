`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/04/05 16:40:54
// Design Name: 
// Module Name: defines
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`define FPGA_SOURCE
// `define DISABLE_SV_ASSERTION

`define CODE_LEN 1024
`define INFO_BITS_384_WIDTH 384
`define INFO_BITS_256_WIDTH 256
 
`define PIPELINE_STAGE 6

`define STAGE1_INPUT_WIDTH 384
`define STAGE1_OUTPUT_WIDTH 496

`define STAGE2_INPUT_WIDTH 496
`define STAGE2_OUTPUT_WIDTH 656

`define STAGE3_INPUT_WIDTH 656
`define STAGE3_OUTPUT_WIDTH 832

`define STAGE4_INPUT_WIDTH 832
`define STAGE4_OUTPUT_WIDTH 1024

`define STAGE5_INPUT_WIDTH 1024
`define STAGE5_OUTPUT_WIDTH 1024

`define STAGE6_INPUT_WIDTH 1024
`define STAGE6_OUTPUT_WIDTH 1024

// `define STAGE1_XOR2IN_WIDTH 192
// `define STAGE1_XOR3IN_WIDTH 20
// `define STAGE1_XOR4IN_WIDTH 72

// `define STAGE2_XOR2IN_WIDTH 248
// `define STAGE2_XOR3IN_WIDTH 32
// `define STAGE2_XOR4IN_WIDTH 88

// `define STAGE3_XOR2IN_WIDTH 352
// `define STAGE3_XOR3IN_WIDTH 80
// `define STAGE3_XOR4IN_WIDTH 96

// `define STAGE4_XOR2IN_WIDTH 384
// `define STAGE4_XOR4IN_WIDTH 192

// `define STAGE5_XOR2IN_WIDTH 352

// `define STAGE6_XOR2IN_WIDTH 352
