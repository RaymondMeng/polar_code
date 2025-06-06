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
//   排序器，输入2L个权重输出筛选后L个最小权重，顺序从小到大
//   排序算法采用简化冒泡排序算法，利用PM特性：
//   PM_{2l} < PM_{2l+1}
//   PM_{2l} < PM_{2l+2}
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//   
//////////////////////////////////////////////////////////////////////////////////
`include "../defines.v"

module Sorter(
    sorter_en,
    sorter_res,
    PM_in,
    PM_out
);
/*******************************************************************************/
/*                              Function                                       */
/*******************************************************************************/
function integer clogb2 (input integer bit_depth); 
    for(clogb2=0; bit_depth>0; clogb2=clogb2+1)
        bit_depth = bit_depth >> 1;
endfunction
/*******************************************************************************/
/*                              Parameter                                      */
/*******************************************************************************/
`ifdef LIST_SIZE4
    parameter L = 4;
`elsif LIST_SIZE2
    parameter L = 2;
`endif 

parameter PM_WIDTH    = 8;
parameter INDEX_WIDTH = clogb2(2*L-1);
/*******************************************************************************/
/*                              IO Direction                                   */
/*******************************************************************************/
input                      sorter_en;             // sorter使能端口，0表示不进行排序筛选，输出为默认L条路径；1表示进行排序筛选输出最小的L条路径
output [L*INDEX_WIDTH-1:0] sorter_res;            // 排序筛选结果，按照PM从小到大输出保留路径的L个索引
input  [PM_WIDTH*2*L-1:0]  PM_in;
output [PM_WIDTH*L-1:0]    PM_out;
/*******************************************************************************/
/*                              Signal Declaration                             */
/*******************************************************************************/
wire [PM_WIDTH*2*L-1:0]               pm_in;
wire [(PM_WIDTH+INDEX_WIDTH)*L-1:0]   pm_out;
/*******************************************************************************/
/*                              Instance                                       */
/*******************************************************************************/
`ifdef LIST_SIZE4
    Sorter4 #(
        .PM_WIDTH   (PM_WIDTH),
        .INDEX_WIDTH(INDEX_WIDTH)
    ) Sorter4_inst(
        .PM_in(pm_in),
        .PM_out(pm_out)
    );
`elsif LIST_SIZE2
    Sorter2 #(
        .PM_WIDTH   (PM_WIDTH),
        .INDEX_WIDTH(INDEX_WIDTH)
    ) Sorter2_inst(
        .PM_in(pm_in),
        .PM_out(pm_out)
    );
`endif 
/*******************************************************************************/
/*                              Logic                                          */
/*******************************************************************************/
assign pm_in = sorter_en ? PM_in : 'd0;
`ifdef LIST_SIZE4
    assign PM_out = sorter_en ? {pm_out[(PM_WIDTH+INDEX_WIDTH)*L-INDEX_WIDTH-1-:PM_WIDTH], pm_out[(PM_WIDTH+INDEX_WIDTH)*(L-1)-INDEX_WIDTH-1-:PM_WIDTH], pm_out[(PM_WIDTH+INDEX_WIDTH)*(L-2)-INDEX_WIDTH-1-:PM_WIDTH], pm_out[(PM_WIDTH+INDEX_WIDTH)*(L-3)-INDEX_WIDTH-1-:PM_WIDTH]} : 
                                {PM_in[PM_WIDTH*2*L-1-:PM_WIDTH], PM_in[PM_WIDTH*2*(L-1)-1-:PM_WIDTH], PM_in[PM_WIDTH*2*(L-2)-1-:PM_WIDTH], PM_in[PM_WIDTH*2*(L-3)-1-:PM_WIDTH]};
    assign sorter_res = sorter_en ? {pm_out[(PM_WIDTH+INDEX_WIDTH)*L-1-:INDEX_WIDTH], pm_out[(PM_WIDTH+INDEX_WIDTH)*(L-1)-1-:INDEX_WIDTH], pm_out[(PM_WIDTH+INDEX_WIDTH)*(L-2)-1-:INDEX_WIDTH], pm_out[(PM_WIDTH+INDEX_WIDTH)*(L-3)-1-:INDEX_WIDTH]} : 
                                    {3'd0, 3'd2, 3'd4, 3'd6};
`elsif LIST_SIZE2
    assign PM_out = sorter_en ? {pm_out[(PM_WIDTH+INDEX_WIDTH)*L-INDEX_WIDTH-1-:PM_WIDTH], pm_out[(PM_WIDTH+INDEX_WIDTH)*(L-1)-INDEX_WIDTH-1-:PM_WIDTH]} : 
                                {PM_in[PM_WIDTH*2*L-1-:PM_WIDTH], PM_in[PM_WIDTH*2*(L-1)-1-:PM_WIDTH]};
    assign sorter_res = sorter_en ? {pm_out[(PM_WIDTH+INDEX_WIDTH)*L-1-:INDEX_WIDTH], pm_out[(PM_WIDTH+INDEX_WIDTH)*(L-1)-1-:INDEX_WIDTH]} : {2'd0, 2'd2};
`endif
endmodule
