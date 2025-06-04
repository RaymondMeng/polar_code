`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Yankai Wang
// 
// Create Date: 2025/05/29 
// Design Name: polar_code
// Module Name: AT
// Project Name: polar_code
// Target Devices: zcu106
// Tool Versions: 2023.2
// Description: 
//   并行加法树（Adder Tree），采用递归形式实现
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//   
//////////////////////////////////////////////////////////////////////////////////
module AT(in_addends, out_sum);

parameter DATA_WIDTH = 8;
parameter LENGTH = 128;

localparam OUT_WIDTH = DATA_WIDTH;
localparam LENGTH_A = LENGTH / 2;
localparam LENGTH_B = LENGTH - LENGTH_A;
localparam OUT_WIDTH_A = DATA_WIDTH;
localparam OUT_WIDTH_B = DATA_WIDTH;

input [DATA_WIDTH*LENGTH-1:0] in_addends;
output [OUT_WIDTH-1:0] out_sum;

generate
	if (LENGTH == 1) begin
		assign out_sum = in_addends;
	end else begin
		wire [OUT_WIDTH_A-1:0] sum_a;
		wire [OUT_WIDTH_B-1:0] sum_b;
		
		wire [DATA_WIDTH*LENGTH_A-1:0] addends_a;
		wire [DATA_WIDTH*LENGTH_B-1:0] addends_b;

        wire [DATA_WIDTH:0] out_sum_temp;
        wire overflow_flag;

		assign {addends_a, addends_b} = in_addends;

		//divide set into two chunks, conquer
		AT #(
			.DATA_WIDTH(DATA_WIDTH),
			.LENGTH(LENGTH_A)
		) subtree_a (
			.in_addends(addends_a),
			.out_sum(sum_a)
		);
		
		AT #(
			.DATA_WIDTH(DATA_WIDTH),
			.LENGTH(LENGTH_B)
		) subtree_b (
			.in_addends(addends_b),
			.out_sum(sum_b)
		);
		
        assign out_sum_temp = sum_a + sum_b;
        assign overflow_flag = out_sum_temp[DATA_WIDTH];

		assign out_sum = overflow_flag ? {DATA_WIDTH{1'b1}} : out_sum_temp[DATA_WIDTH-1:0];
	end
endgenerate

endmodule
