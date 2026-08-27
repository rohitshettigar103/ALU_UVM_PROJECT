`include"alu_defines.svh"
interface alu_inf(input bit clk,input bit rst);
	logic CE;
	logic MODE;
	logic CIN;
	logic [`CW-1:0] CMD;
	logic [1:0]INP_VALID;
	logic [`DW-1:0]OPA;
	logic [`DW-1:0]OPB;
	logic [`DW*2-1:0]RES;
	logic COUT;
	logic OFLOW;
	logic G;
	logic E;
	logic L;
	logic ERR;


	clocking drv_clk @(posedge clk);
		default input #1ns output #1ns;
		output CE;
		output MODE;
		output CIN;
		output CMD;
		output INP_VALID;
		output OPA;
		output OPB;
		//output OPA;
	endclocking

	clocking mon_clk @(posedge clk);
		default input #1ns output #1ns;
		input CE;
		input MODE;
		input CIN;
		input CMD;
		input INP_VALID;
		input OPA;
		input OPB;
		input RES;
		input COUT;
		input OFLOW;
		input G;
		input E;
		input L;
		input ERR;
	endclocking

	modport DRV(clocking drv_clk,input rst);
	modport MON(clocking mon_clk,input rst);
endinterface

