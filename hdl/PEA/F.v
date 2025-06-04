`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Yankai Wang
// 
// Create Date: 2025/05/10 20:02:30
// Design Name: polar_code
// Module Name: F
// Project Name: polar_code
// Target Devices: zcu106
// Tool Versions: 2023.2
// Description: 
//   节点LLR计算F操作
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//   F(x,y) = sgn(x)sgn(y)min(|x|,|y|)
//////////////////////////////////////////////////////////////////////////////////


module F(
    llr_in0,
    llr_in1,
    llr_out
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
output [INTER_LLR_WIDTH-1:0] llr_out;
/*******************************************************************************/
/*                              Signal Declaration                             */
/*******************************************************************************/
// abs result
wire [INTER_LLR_WIDTH-1:0] llr_in0_abs;
wire [INTER_LLR_WIDTH-1:0] llr_in1_abs;

// min result
wire [INTER_LLR_WIDTH-1:0] llr_min0;
wire [INTER_LLR_WIDTH-1:0] llr_min1;

// sgn result
wire llr_out_sgn;
/*******************************************************************************/
/*                              Logic                                          */
/*******************************************************************************/
// abs
assign llr_in0_abs[INTER_LLR_WIDTH-1] = 1'b0;
assign llr_in1_abs[INTER_LLR_WIDTH-1] = 1'b0;
assign llr_in0_abs[INTER_LLR_WIDTH-2:0] = llr_in0[INTER_LLR_WIDTH-1] ? ~llr_in0[INTER_LLR_WIDTH-2:0]+1 : llr_in0[INTER_LLR_WIDTH-2:0];    // 保证数据对称性
assign llr_in1_abs[INTER_LLR_WIDTH-2:0] = llr_in1[INTER_LLR_WIDTH-1] ? ~llr_in1[INTER_LLR_WIDTH-2:0]+1 : llr_in1[INTER_LLR_WIDTH-2:0];

// min
assign llr_min0 = llr_in0_abs <= llr_in1_abs ? llr_in0_abs : llr_in1_abs;      // llr_min0为绝对值最小值
assign llr_min1[INTER_LLR_WIDTH-1] = ~llr_min0[INTER_LLR_WIDTH-1];             // llr_min1为绝对最小值的相反数
assign llr_min1[INTER_LLR_WIDTH-2:0] = ~llr_min0[INTER_LLR_WIDTH-2:0]+1;

// sgn
assign llr_out_sgn = llr_in0[INTER_LLR_WIDTH-1] ^ llr_in1[INTER_LLR_WIDTH-1];  // 输出符号位，置高表示输入两符号不同，结果为负，反之为正

//llr out
assign llr_out = llr_out_sgn ? llr_min1 : llr_min0;                            // 根据符号位进行选择输出的正负
endmodule
