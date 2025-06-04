`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Yankai Wang
// 
// Create Date: 2025/05/10 20:02:30
// Design Name: polar_code
// Module Name: PE
// Project Name: polar_code
// Target Devices: zcu106
// Tool Versions: 2023.2
// Description: 
//   针对极化码译码的处理单元阵列（Processing Element Array, PEA）
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//   PEA中包含M个PE单元
//////////////////////////////////////////////////////////////////////////////////


module PEA(
    llr_in0,
    llr_in1,
    ps_g0,
    ps_g1,
    llr_out_g0,
    llr_out_g1,
    llr_out_f
);
/*******************************************************************************/
/*                              Parameter                                      */
/*******************************************************************************/
parameter INTER_LLR_WIDTH = 6;
parameter M = 512;
/*******************************************************************************/
/*                              IO Direction                                   */
/*******************************************************************************/
input  [INTER_LLR_WIDTH*M-1:0] llr_in0;
input  [INTER_LLR_WIDTH*M-1:0] llr_in1;
input  [M-1:0]                 ps_g0;
input  [M-1:0]                 ps_g1;
output [INTER_LLR_WIDTH*M-1:0] llr_out_g0;
output [INTER_LLR_WIDTH*M-1:0] llr_out_g1;
output [INTER_LLR_WIDTH*M-1:0] llr_out_f;
/*******************************************************************************/
/*                              Signal Declaration                             */
/*******************************************************************************/
/*******************************************************************************/
/*                              Instance                                       */
/*******************************************************************************/
genvar i;
generate
    for (i = 0; i < M; i = i + 1) begin : PE_inst
        PE #(
            .INTER_LLR_WIDTH(INTER_LLR_WIDTH)
        ) PE_inst(
            .llr_in0   (llr_in0[i*INTER_LLR_WIDTH+:INTER_LLR_WIDTH]),
            .llr_in1   (llr_in1[i*INTER_LLR_WIDTH+:INTER_LLR_WIDTH]),
            .ps_g0     (ps_g0[i]                                   ),
            .ps_g1     (ps_g1[i]),
            .llr_out_g0(llr_out_g0[i*INTER_LLR_WIDTH+:INTER_LLR_WIDTH]),
            .llr_out_g1(llr_out_g1[i*INTER_LLR_WIDTH+:INTER_LLR_WIDTH]),
            .llr_out_f (llr_out_f[i*INTER_LLR_WIDTH+:INTER_LLR_WIDTH] )
        );
    end
endgenerate
/*******************************************************************************/
/*                              Logic                                          */
/*******************************************************************************/
endmodule
