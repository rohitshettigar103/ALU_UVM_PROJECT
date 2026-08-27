//`include "alu_interface.sv"
class alu_driver extends uvm_driver#(alu_transaction);
	`uvm_component_utils(alu_driver)
	virtual alu_inf inf;

	function new(string name="alu_driver",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db#(virtual alu_inf)::get(this,"","alu_inf",inf))
			`uvm_fatal(get_type_name(),"no interface recieved")
	endfunction


	task run_phase(uvm_phase phase);
		forever
		begin
			seq_item_port.get_next_item(req);
			drive(req);
			seq_item_port.item_done();
		end
	endtask
		

	task drive(alu_transaction trans);
		@(inf.DRV.drv_clk);
		inf.DRV.drv_clk.CE<=trans.ce;
		inf.DRV.drv_clk.MODE<=trans.mode;
		//inf.DRV.drv_clk.CIN<=trans.cin;
		inf.DRV.drv_clk.CMD<=trans.cmd;
		inf.DRV.drv_clk.INP_VALID<=trans.inp_valid;
		inf.DRV.drv_clk.OPA<=trans.opa;
		inf.DRV.drv_clk.OPB<=trans.opb;

	//	if((trans.mode==1) && ((trans.cmd==4'b0010) || (trans.cmd==4'b0011)))
			inf.DRV.drv_clk.CIN<=trans.cin;
		`uvm_info("INPUT_DRIVER",$sformatf("Input Driver\n%s",trans.sprint()),UVM_NONE)
 		//`uvm_info("----------","--------------------------------------------------------------------------------------------------------",UVM_LOW)
		//`uvm_info("INPUT_DRIVER", $sformatf("Driven values -> CE:%0b MODE:%0d CMD:%0h INP_VALID:%0b OPA:%0h OPB:%0h CIN:%0h", 
              	//	trans.ce, trans.mode, trans.cmd, trans.inp_valid, trans.opa, trans.opb, trans.cin), UVM_NONE)
	endtask
endclass






