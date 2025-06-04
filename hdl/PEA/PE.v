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
//   针对极化码译码的处理单元（Processing Element, PE）
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//   单个PE包含两个G运算模块和一个F运算模块
//////////////////////////////////////////////////////////////////////////////////


module PE(
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
/*******************************************************************************/
/*                              IO Direction                                   */
/*******************************************************************************/
input  [INTER_LLR_WIDTH-1:0] llr_in0;
input  [INTER_LLR_WIDTH-1:0] llr_in1;
input                        ps_g0;
input                        ps_g1;
output [INTER_LLR_WIDTH-1:0] llr_out_g0;
output [INTER_LLR_WIDTH-1:0] llr_out_g1;
output [INTER_LLR_WIDTH-1:0] llr_out_f;
/*******************************************************************************/
/*                              Signal Declaration                             */
/*******************************************************************************/
/*******************************************************************************/
/*                              Instance                                       */
/*******************************************************************************/
G #(
    .INTER_LLR_WIDTH(INTER_LLR_WIDTH)
) G0 (
    .llr_in0(llr_in0   ),
    .llr_in1(llr_in1   ),
    .llr_out(llr_out_g0),
    .ps     (ps_g0     )
);

G #(
    .INTER_LLR_WIDTH(INTER_LLR_WIDTH)
) G1 (
    .llr_in0(llr_in0   ),
    .llr_in1(llr_in1   ),
    .llr_out(llr_out_g1),
    .ps     (ps_g1     )
);

F #(
    .INTER_LLR_WIDTH(INTER_LLR_WIDTH)
) F0 (
    .llr_in0(llr_in0  ),
    .llr_in1(llr_in1  ),
    .llr_out(llr_out_f)
);
/*******************************************************************************/
/*                              Logic                                          */
/*******************************************************************************/
endmodule