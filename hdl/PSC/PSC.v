`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Yankai Wang
// 
// Create Date: 2025/05/10 20:02:30
// Design Name: polar_code
// Module Name: PSC
// Project Name: polar_code
// Target Devices: zcu106
// Tool Versions: 2023.2
// Description: 
//   实现极化码译码中的比特回传异或操作（Partial Sum Calculate）
//   模块采用6级可重构异或阵列，每级分别有16，32，64，128，256，512个异或操作
//   此处默认索引越低置信度越高，即B_in0位于PSC下方，B_in1位于PSC上方
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//////////////////////////////////////////////////////////////////////////////////


module PSC(
    sel,
    B_in1,
    B_in0,
    B_out
);
/*******************************************************************************/
/*                              Parameter                                      */
/*******************************************************************************/
parameter LAYER_NUM       = 6;
parameter LAYER1_NODE_NUM = 16;
parameter LAYER2_NODE_NUM = 32;
parameter LAYER3_NODE_NUM = 64;
parameter LAYER4_NODE_NUM = 128;
parameter LAYER5_NODE_NUM = 256;
parameter LAYER6_NODE_NUM = 512;
/*******************************************************************************/
/*                              IO Direction                                   */
/*******************************************************************************/
input  [LAYER_NUM-1:0] sel;
input  [511:0]         B_in1;
input  [511:0]         B_in0;
output [1023:0]        B_out;
/*******************************************************************************/
/*                              Signal Declaration                             */
/*******************************************************************************/
wire sel_layer1;
wire sel_layer2;
wire sel_layer3;
wire sel_layer4;
wire sel_layer5;
wire sel_layer6;

wire [LAYER1_NODE_NUM-1:0] layer1_in1;
wire [LAYER1_NODE_NUM-1:0] layer1_in0;
wire [LAYER2_NODE_NUM-1:0] layer2_in1;
wire [LAYER2_NODE_NUM-1:0] layer2_in0;
wire [LAYER3_NODE_NUM-1:0] layer3_in1;
wire [LAYER3_NODE_NUM-1:0] layer3_in0;
wire [LAYER4_NODE_NUM-1:0] layer4_in1;
wire [LAYER4_NODE_NUM-1:0] layer4_in0;
wire [LAYER5_NODE_NUM-1:0] layer5_in1;
wire [LAYER5_NODE_NUM-1:0] layer5_in0;
wire [LAYER6_NODE_NUM-1:0] layer6_in1;
wire [LAYER6_NODE_NUM-1:0] layer6_in0;

wire [LAYER1_NODE_NUM-1:0] layer1_out1;
wire [LAYER1_NODE_NUM-1:0] layer1_out0;
wire [LAYER2_NODE_NUM-1:0] layer2_out1;
wire [LAYER2_NODE_NUM-1:0] layer2_out0;
wire [LAYER3_NODE_NUM-1:0] layer3_out1;
wire [LAYER3_NODE_NUM-1:0] layer3_out0;
wire [LAYER4_NODE_NUM-1:0] layer4_out1;
wire [LAYER4_NODE_NUM-1:0] layer4_out0;
wire [LAYER5_NODE_NUM-1:0] layer5_out1;
wire [LAYER5_NODE_NUM-1:0] layer5_out0;
wire [LAYER6_NODE_NUM-1:0] layer6_out1;
wire [LAYER6_NODE_NUM-1:0] layer6_out0;
/*******************************************************************************/
/*                              Instance                                       */
/*******************************************************************************/
genvar i;
generate
    for (i = 0; i < LAYER1_NODE_NUM; i = i + 1) begin : Layer1_inst
        PolarBase PolarBase_inst_l1(
            .sel(sel_layer1    ),
            .u1 (layer1_in1[i] ),
            .u0 (layer1_in0[i] ),
            .x1 (layer1_out1[i]),
            .x0 (layer1_out0[i])
        );
    end
endgenerate

genvar j;
generate
    for (j = 0; j < LAYER2_NODE_NUM; j = j + 1) begin : Layer2_inst
        PolarBase PolarBase_inst_l2(
            .sel(sel_layer2    ),
            .u1 (layer2_in1[j] ),
            .u0 (layer2_in0[j] ),
            .x1 (layer2_out1[j]),
            .x0 (layer2_out0[j])
        );
    end
endgenerate

genvar k;
generate
    for (k = 0; k < LAYER3_NODE_NUM; k = k + 1) begin : Layer3_inst
        PolarBase PolarBase_inst_l3(
            .sel(sel_layer3    ),
            .u1 (layer3_in1[k] ),
            .u0 (layer3_in0[k] ),
            .x1 (layer3_out1[k]),
            .x0 (layer3_out0[k])
        );
    end
endgenerate

genvar l;
generate
    for (l = 0; l < LAYER4_NODE_NUM; l = l + 1) begin : Layer4_inst
        PolarBase PolarBase_inst_l4(
            .sel(sel_layer4    ),
            .u1 (layer4_in1[l] ),
            .u0 (layer4_in0[l] ),
            .x1 (layer4_out1[l]),
            .x0 (layer4_out0[l])
        );
    end
endgenerate

genvar m;
generate
    for (m = 0; m < LAYER5_NODE_NUM; m = m + 1) begin : Layer5_inst
        PolarBase PolarBase_inst_l5(
            .sel(sel_layer5    ),
            .u1 (layer5_in1[m] ),
            .u0 (layer5_in0[m] ),
            .x1 (layer5_out1[m]),
            .x0 (layer5_out0[m])
        );
    end
endgenerate

genvar n;
generate
    for (n = 0; n < LAYER6_NODE_NUM; n = n + 1) begin : Layer6_inst
        PolarBase PolarBase_inst_l6(
            .sel(sel_layer6    ),
            .u1 (layer6_in1[n] ),
            .u0 (layer6_in0[n] ),
            .x1 (layer6_out1[n]),
            .x0 (layer6_out0[n])
        );
    end
endgenerate
/*******************************************************************************/
/*                              Logic                                          */
/*******************************************************************************/
assign {sel_layer1, sel_layer2, sel_layer3, sel_layer4, sel_layer5, sel_layer6} = sel;

assign layer6_in1 = B_in1;
assign {layer5_in1, layer4_in1, layer3_in1, layer2_in1, layer1_in1, layer1_in0} = B_in0;

assign layer2_in0 = {layer1_out1, layer1_out0};
assign layer3_in0 = {layer2_out1, layer2_out0};
assign layer4_in0 = {layer3_out1, layer3_out0};
assign layer5_in0 = {layer4_out1, layer4_out0};
assign layer6_in0 = {layer5_out1, layer5_out0};
assign B_out = {layer6_out1, layer6_out0};
endmodule
