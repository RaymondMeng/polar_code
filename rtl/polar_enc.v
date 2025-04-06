`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/04/05 16:19:56
// Design Name: 
// Module Name: encode
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

`include "defines.v"

module POLAR_ENC(
    input                                    clk,                      //64MHz clock
    input                                    rst_n,                    //reset
    input                                    polar_rate_sel,           //0 : 1/4   1 : 3/8
    input                                    polar_enc_start,          //1 : start  one cycle high level signal
    input         [383 : 0]                  polar_enc_data_in,        //bit sequence before encode
    output                                   polar_enc_done,           //set 1 when encode done
    output        [`CODE_LEN-1 : 0]          polar_enc_data_dout       //encoded data
    );

wire [`STAGE1_INPUT_WIDTH-1 : 0] stage_1_comp_in;
wire [`STAGE1_OUTPUT_WIDTH-1 : 0] stage_1_comp_out;

wire [`STAGE2_INPUT_WIDTH-1 : 0] stage_2_comp_in;
wire [`STAGE2_OUTPUT_WIDTH-1 : 0] stage_2_comp_out;

wire [`STAGE3_INPUT_WIDTH-1 : 0] stage_3_comp_in;
wire [`STAGE3_OUTPUT_WIDTH-1 : 0] stage_3_comp_out;

wire [`STAGE4_INPUT_WIDTH-1 : 0] stage_4_comp_in;
wire [`STAGE4_OUTPUT_WIDTH-1 : 0] stage_4_comp_out;

wire [`STAGE5_INPUT_WIDTH-1 : 0] stage_5_comp_in;
wire [`STAGE5_OUTPUT_WIDTH-1 : 0] stage_5_comp_out;

wire [`STAGE6_INPUT_WIDTH-1 : 0] stage_6_comp_in;
wire [`STAGE6_OUTPUT_WIDTH-1 : 0] stage_6_comp_out;

wire polar_enc_start_d, polar_enc_start_dd, polar_enc_start_ddd, polar_enc_start_dddd, polar_enc_start_ddddd, polar_enc_start_dddddd;
wire dff_lden;

assign dff_lden = polar_enc_start | polar_enc_start_dddddd;
assign polar_enc_done = polar_enc_start_dddddd;

assign stage_1_comp_in = polar_enc_data_in;

stage_1_xor_unit stage_1_xor_unit_inst(.i_stage_1_comp_in(stage_1_comp_in), .o_stage_1_comp_out(stage_1_comp_out));
stage_2_xor_unit stage_2_xor_unit_inst(.i_stage_2_comp_in(stage_2_comp_in), .o_stage_2_comp_out(stage_2_comp_out));
stage_3_xor_unit stage_3_xor_unit_inst(.i_stage_3_comp_in(stage_3_comp_in), .o_stage_3_comp_out(stage_3_comp_out));
stage_4_xor_unit stage_4_xor_unit_inst(.i_stage_4_comp_in(stage_4_comp_in), .o_stage_4_comp_out(stage_4_comp_out));
stage_5_xor_unit stage_5_xor_unit_inst(.i_stage_5_comp_in(stage_5_comp_in), .o_stage_5_comp_out(stage_5_comp_out));
stage_6_xor_unit stage_6_xor_unit_inst(.i_stage_6_comp_in(stage_6_comp_in), .o_stage_6_comp_out(stage_6_comp_out));

//TODO:有个点：start信号经过dff打一拍可以作为下一个dff的load_enable信号，这样可以正好卡住数据流入流出的时序(影响不大)
synth_gnrl_dfflr #(.DW(`STAGE1_OUTPUT_WIDTH+1)) stage_1_2_dfflr(.lden(dff_lden), .dnxt({polar_enc_start, stage_1_comp_out}), .qout({polar_enc_start_d, stage_2_comp_in}), .clk(clk), .rst_n(rst_n));
synth_gnrl_dfflr #(.DW(`STAGE2_OUTPUT_WIDTH+1)) stage_2_3_dfflr(.lden(dff_lden), .dnxt({polar_enc_start_d, stage_2_comp_out}), .qout({polar_enc_start_dd, stage_3_comp_in}), .clk(clk), .rst_n(rst_n));
synth_gnrl_dfflr #(.DW(`STAGE3_OUTPUT_WIDTH+1)) stage_3_4_dfflr(.lden(dff_lden), .dnxt({polar_enc_start_dd, stage_3_comp_out}), .qout({polar_enc_start_ddd, stage_4_comp_in}), .clk(clk), .rst_n(rst_n));
synth_gnrl_dfflr #(.DW(`STAGE4_OUTPUT_WIDTH+1)) stage_4_5_dfflr(.lden(dff_lden), .dnxt({polar_enc_start_ddd, stage_4_comp_out}), .qout({polar_enc_start_dddd, stage_5_comp_in}), .clk(clk), .rst_n(rst_n));
synth_gnrl_dfflr #(.DW(`STAGE5_OUTPUT_WIDTH+1)) stage_5_6_dfflr(.lden(dff_lden), .dnxt({polar_enc_start_dddd, stage_5_comp_out}), .qout({polar_enc_start_ddddd, stage_6_comp_in}), .clk(clk), .rst_n(rst_n));
synth_gnrl_dfflr #(.DW(`STAGE6_OUTPUT_WIDTH+1)) out_dfflr(.lden(dff_lden), .dnxt({polar_enc_start_ddddd, stage_6_comp_out}), .qout({polar_enc_start_dddddd, polar_enc_data_dout}), .clk(clk), .rst_n(rst_n));

endmodule
