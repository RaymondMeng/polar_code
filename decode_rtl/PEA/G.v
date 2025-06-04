`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Yankai Wang
// 
// Create Date: 2025/05/10 20:02:30
// Design Name: polar_code
// Module Name: G
// Project Name: polar_code
// Target Devices: zcu106
// Tool Versions: 2023.2
// Description: 
//   节点LLR计算G操作
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//   G(x,y) = (-1)^u*x + y
//////////////////////////////////////////////////////////////////////////////////


module G(
    llr_in0,
    llr_in1,
    llr_out,
    ps
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
input                        ps;
/*******************************************************************************/
/*                              Signal Declaration                             */
/*******************************************************************************/
wire [INTER_LLR_WIDTH-1:0] llr_in0_temp;                // llr_in0的相反数
wire [INTER_LLR_WIDTH-1:0] llr_in0_seleted;             // 根据部分和选择做运算的llr_in0
wire [INTER_LLR_WIDTH-1:0] sum_temp;                     

wire overflow_pos;                                      // 正数计算溢出标志位
wire overflow_neg;                                      // 负数计算溢出标志位
/*******************************************************************************/
/*                              Logic                                          */
/*******************************************************************************/
assign llr_in0_temp[INTER_LLR_WIDTH-1] = ~llr_in0[INTER_LLR_WIDTH-1];
assign llr_in0_temp[INTER_LLR_WIDTH-2:0] = ~llr_in0[INTER_LLR_WIDTH-2:0]+1;
assign llr_in0_seleted = ps ? llr_in0_temp : llr_in0;

assign sum_temp = llr_in1 + llr_in0_seleted;
assign overflow_pos = ~llr_in1[INTER_LLR_WIDTH-1] & ~llr_in0_seleted[INTER_LLR_WIDTH-1] & sum_temp[INTER_LLR_WIDTH-1];
assign overflow_neg = llr_in1[INTER_LLR_WIDTH-1] & llr_in0_seleted[INTER_LLR_WIDTH-1] & ~sum_temp[INTER_LLR_WIDTH-1];
assign llr_out = ({INTER_LLR_WIDTH{overflow_pos}} & {1'b0, {INTER_LLR_WIDTH-1{1'b1}}})       |       // 正向溢出饱和处理至最大值
                 ({INTER_LLR_WIDTH{overflow_neg}} & {1'b1, {INTER_LLR_WIDTH-2{1'b0}}, 1'b1}) |       // 负向溢出饱和对称处理至最小值
                 ({INTER_LLR_WIDTH{~overflow_neg & ~overflow_pos}} & sum_temp);
endmodule
