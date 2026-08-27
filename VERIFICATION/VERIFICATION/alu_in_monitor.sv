class alu_in_monitor extends uvm_monitor;
	`uvm_component_utils(alu_in_monitor)
	virtual alu_inf inf;
	alu_transaction trans;
	uvm_analysis_port#(alu_transaction) in_mon_port;

	function new(string name="alu_in_monitor",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		in_mon_port=new("in_mon_port",this);
		if(!uvm_config_db#(virtual alu_inf)::get(this,"","alu_inf",inf))
			`uvm_fatal(get_type_name(),"No interface is found")
	endfunction

	task run_phase(uvm_phase phase);
		//@(inf.MON.mon_clk);
		forever 
		begin
		//	repeat(4)
		//	begin

			@(inf.MON.mon_clk);
		//	if(inf.MON.mon_clk.CE)
			//@(inf.MON.mon_clk);
		//	begin
			`uvm_info(get_type_name(),"starting of input monitor",UVM_LOW)
			trans=alu_transaction::type_id::create("trans");
			trans.ce=inf.MON.mon_clk.CE;
			trans.mode=inf.MON.mon_clk.MODE;
			trans.cin=inf.MON.mon_clk.CIN;
			trans.cmd=inf.MON.mon_clk.CMD;
			trans.inp_valid=inf.MON.mon_clk.INP_VALID;
			trans.opa=inf.MON.mon_clk.OPA;
			trans.opb=inf.MON.mon_clk.OPB;
			
			/*trans.res=inf.MON.mon_clk.RES;
			trans.cout=inf.MON.mon_clk.COUT;
			trans.oflow=inf.MON.mon_clk.OFLOW;
			trans.g=inf.MON.mon_clk.G;
			trans.l=inf.MON.mon_clk.L;
			trans.e=inf.MON.mon_clk.E;*/

			in_mon_port.write(trans);
			`uvm_info("INPUT_MONITOR", $sformatf("Observed on DUT pins:\n%s", trans.sprint()), UVM_LOW)		
			//`uvm_info("INPUT_MONITOR", $sformatf("Monitored inputs -> CE:%0b MODE:%0d CMD:%0h INP_VALID:%0b OPA:%0h OPB:%0h CIN:%0h", 
                	//	trans.ce, trans.mode, trans.cmd, trans.inp_valid, trans.opa, trans.opb, trans.cin), UVM_LOW)	
			//`uvm_info(get_type_name(),"end of input monitor",UVM_LOW)
			
			//`;wq
			//end
	//	end
		end
	endtask
endclass






	

