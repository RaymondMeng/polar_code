`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/04/06 21:14:00
// Design Name: 
// Module Name: encode_tb
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

module encode_tb;

reg clk;
reg rst_n;
reg polar_rate_sel, polar_enc_start;
reg [383:0] polar_enc_data_in;

wire polar_enc_done;
wire [1024-1:0] polar_enc_data_dout;

localparam CLK_PERIOD = 10;
always #(CLK_PERIOD/2) clk=~clk;

`ifndef FPGA_SOURCE
initial begin
    $dumpfile("tb.vcd");
    $dumpvars(0, tb);
end
`endif

initial begin
    //信号复位
    #1 rst_n<=1'b1; clk<=1'b0;
        polar_rate_sel<=1'b0;
        polar_enc_start<=1'b0;
        polar_enc_data_in<='d0;
    //复位
    #(CLK_PERIOD*3) 
        rst_n<=0;clk<=0;
    repeat(50) @(posedge clk);
        polar_rate_sel<=1'b1;
        polar_enc_start<=1'b1;
        polar_enc_data_in<='d1;
    repeat(50) @(posedge clk);
        polar_rate_sel<=1'b0;
        polar_enc_start<=1'b0;
        polar_enc_data_in<='d0;
    //取消复位
    repeat(50) @(posedge clk);
                rst_n<=1;
    //start为0测试
    repeat(50) @(posedge clk);
        polar_rate_sel<=1'b1;
        polar_enc_data_in<='d1;
    repeat(50) @(posedge clk);
        polar_rate_sel<=1'b0;
        polar_enc_data_in<='d1;
    //start为1，256位有效比特，10个码字，正式开始测试
    repeat(50) @(posedge clk);
        polar_enc_start<=1'b1;
        polar_rate_sel<=1'b0;
        polar_enc_data_in<='d1;
    @(posedge clk);
        polar_enc_data_in<='d3;
    @(posedge clk);
        polar_enc_data_in<='d7;
    @(posedge clk);
        polar_enc_data_in<='d15;
    @(posedge clk);
        polar_enc_data_in<='d31;
    @(posedge clk);
        polar_enc_data_in<='d63;
    @(posedge clk);
        polar_enc_data_in<='d127;
    @(posedge clk);
        polar_enc_data_in<='d255;
    @(posedge clk);
        polar_enc_data_in<='d511;
    @(posedge clk);
        polar_enc_data_in<='d1023;
    //start为0
    @(posedge clk);
        polar_enc_start<=1'b0;

    repeat(100) @(posedge clk);

    //start为1，384位有效比特，10个码字，正式开始测试
    repeat(50) @(posedge clk);
        polar_enc_start<=1'b1;
        polar_rate_sel<=1'b1;
        polar_enc_data_in<='d1;
    @(posedge clk);
        polar_enc_data_in<='d3;
    @(posedge clk);
        polar_enc_data_in<='d7;
    @(posedge clk);
        polar_enc_data_in<='d15;
    @(posedge clk);
        polar_enc_data_in<='d31;
    @(posedge clk);
        polar_enc_data_in<='d63;
    @(posedge clk);
        polar_enc_data_in<='d127;
    @(posedge clk);
        polar_enc_data_in<='d255;
    @(posedge clk);
        polar_enc_data_in<='d511;
    @(posedge clk);
        polar_enc_data_in<='d1023;
    @(posedge clk);
        polar_enc_start<=1'b0;
    @(posedge clk);
    repeat(2) @(posedge clk);
    $finish(2);
end

POLAR_ENC POLAR_ENC_INST(
    .clk                   (clk),                      //64MHz clock
    .rst_n                 (rst_n),                    //reset
    .polar_rate_sel        (polar_rate_sel),           //0 : 1/4   1 : 3/8
    .polar_enc_start       (polar_enc_start),          //1 : start  one cycle high level signal
    .polar_enc_data_in     (polar_enc_data_in),        //bit sequence before encode
    .polar_enc_done        (polar_enc_done),           //set 1 when encode done
    .polar_enc_data_dout   (polar_enc_data_dout)       //encoded data
);


endmodule
