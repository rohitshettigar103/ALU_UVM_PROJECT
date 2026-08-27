//`include"alu_interface.sv"
`include"alu_defines.svh"
class alu_transaction extends uvm_sequence_item;
	rand bit[`DW-1:0]opa;
	rand bit [`DW-1:0]opb;
	rand bit ce;
	rand bit mode;
	rand bit cin;
	randc bit [`CW-1:0]cmd;
	rand bit[1:0] inp_valid;
	

	bit[`DW*2-1:0] res;
	bit cout;
	bit err;
	bit oflow;
	bit g;
	bit l;
	bit e;

	constraint c1{
		  inp_valid inside{2'b00,2'b01,2'b10,2'b11};
	}
	constraint c2{
		ce dist{
			1:=80,
			0:=20
		};
	}
	constraint c3{
		if(mode){
			cmd inside { [4'b0000:4'b1010]};
		}
		else{
			cmd inside {[4'b0000:4'b1101]};
		}
	}
	constraint c4{
		if(cmd==4'b1100||cmd==4'b1101){
			opb[7:4] dist{
				4'h0:=80,
				[4'h1:4'hf]:=20
			};
		}
	}



	`uvm_object_utils_begin(alu_transaction)
	`uvm_field_int(opa,UVM_ALL_ON)
	`uvm_field_int(opb,UVM_ALL_ON)
	`uvm_field_int(ce,UVM_ALL_ON)
	`uvm_field_int(mode,UVM_ALL_ON)
	`uvm_field_int(cin,UVM_ALL_ON)
	`uvm_field_int(cmd,UVM_ALL_ON)
	`uvm_field_int(inp_valid,UVM_ALL_ON)
	`uvm_field_int(res,UVM_ALL_ON)
	`uvm_field_int(cout,UVM_ALL_ON)
	`uvm_field_int(err,UVM_ALL_ON)
	`uvm_field_int(oflow,UVM_ALL_ON)
	`uvm_field_int(g,UVM_ALL_ON)
	`uvm_field_int(l,UVM_ALL_ON)
	`uvm_field_int(e,UVM_ALL_ON)
	`uvm_object_utils_end


	function new(string name="alu_transaction");
		super.new(name);
	endfunction
endclass

