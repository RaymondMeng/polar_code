`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Yankai Wang
// 
// Create Date: 2025/05/10 20:02:30
// Design Name: polar_code
// Module Name: Sorter
// Project Name: polar_code
// Target Devices: zcu106
// Tool Versions: 2023.2
// Description: 
//   L为4的排序器
//   排序算法采用简化冒泡排序算法，利用PM特性：
//   PM_{2l} < PM_{2l+1}
//   PM_{2l} < PM_{2l+2}
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//   
//////////////////////////////////////////////////////////////////////////////////


module Sorter4(
    PM_in,
    PM_out
);

/*******************************************************************************/
/*                              Parameter                                      */
/*******************************************************************************/
parameter  PM_WIDTH = 8;
localparam L        = 4;
/*******************************************************************************/
/*                              IO Direction                                   */
/*******************************************************************************/
input  [PM_WIDTH*2*L-1:0] PM_in;
output [PM_WIDTH*L-1:0]   PM_out;
/*******************************************************************************/
/*                              Signal Declaration                             */
/*******************************************************************************/
// 第零阶段
wire [PM_WIDTH-1:0] m0_0;
wire [PM_WIDTH-1:0] m1_0;
wire [PM_WIDTH-1:0] m2_0;
wire [PM_WIDTH-1:0] m3_0;
wire [PM_WIDTH-1:0] m4_0;
wire [PM_WIDTH-1:0] m5_0;
wire [PM_WIDTH-1:0] m6_0;
wire [PM_WIDTH-1:0] m7_0;

// 第一阶段
wire [PM_WIDTH-1:0] m0_1;
wire [PM_WIDTH-1:0] m1_1;
wire [PM_WIDTH-1:0] m2_1;
wire [PM_WIDTH-1:0] m3_1;
wire [PM_WIDTH-1:0] m4_1;
wire [PM_WIDTH-1:0] m5_1;
wire [PM_WIDTH-1:0] m6_1;
wire [PM_WIDTH-1:0] m7_1;

// 第二阶段
wire [PM_WIDTH-1:0] m0_2;
wire [PM_WIDTH-1:0] m1_2;
wire [PM_WIDTH-1:0] m2_2;
wire [PM_WIDTH-1:0] m3_2;
wire [PM_WIDTH-1:0] m4_2;
wire [PM_WIDTH-1:0] m5_2;
wire [PM_WIDTH-1:0] m6_2;
wire [PM_WIDTH-1:0] m7_2;

// 第三阶段
wire [PM_WIDTH-1:0] m0_3;
wire [PM_WIDTH-1:0] m1_3;
wire [PM_WIDTH-1:0] m2_3;
wire [PM_WIDTH-1:0] m3_3;
wire [PM_WIDTH-1:0] m4_3;
wire [PM_WIDTH-1:0] m5_3;
wire [PM_WIDTH-1:0] m6_3;
wire [PM_WIDTH-1:0] m7_3;
/*******************************************************************************/
/*                              Instance                                       */
/*******************************************************************************/
/*******************************************************************************/
/*                              Logic                                          */
/*******************************************************************************/
assign {m0_0, m1_0, m2_0, m3_0, m4_0, m5_0, m6_0, m7_0} = PM_in;
assign PM_out = {m0_3, m1_3, m2_3, m3_3};

// 第一阶段
assign m0_1 = m0_0;
CAS #(.PM_WIDTH(PM_WIDTH)) CAS_11 (.Din0(m1_0), .Din1(m2_0), .Dout0(m1_1), .Dout1(m2_1));
CAS #(.PM_WIDTH(PM_WIDTH)) CAS_12 (.Din0(m3_0), .Din1(m4_0), .Dout0(m3_1), .Dout1(m4_1));
CAS #(.PM_WIDTH(PM_WIDTH)) CAS_13 (.Din0(m5_0), .Din1(m6_0), .Dout0(m5_1), .Dout1(m6_1));
assign m7_1 = m7_0;

// 第二阶段
assign m0_2 = m0_1;
assign m1_2 = m1_1;
CAS #(.PM_WIDTH(PM_WIDTH)) CAS_21 (.Din0(m2_1), .Din1(m3_1), .Dout0(m2_2), .Dout1(m3_2));
CAS #(.PM_WIDTH(PM_WIDTH)) CAS_22 (.Din0(m4_1), .Din1(m5_1), .Dout0(m4_2), .Dout1(m5_2));
assign m6_2 = m6_1;
assign m7_2 = m7_1;

// 第三阶段
assign m0_3 = m0_2;
assign m1_3 = m1_2;
assign m2_3 = m2_2;
CAS #(.PM_WIDTH(PM_WIDTH)) CAS_31 (.Din0(m3_2), .Din1(m4_2), .Dout0(m3_3), .Dout1(m4_3));
assign m5_3 = m5_2;
assign m6_3 = m6_2;
assign m7_3 = m7_2;
endmodule
