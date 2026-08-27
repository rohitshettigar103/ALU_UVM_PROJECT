class alu_out_monitor extends uvm_monitor;
	`uvm_component_utils(alu_out_monitor)
	virtual alu_inf inf;
	alu_transaction trans;
	uvm_analysis_port#(alu_transaction)out_mon_port;

	function new(string name="alu_out_monitor",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		out_mon_port=new("out_mon_port",this);
		if(!uvm_config_db#(virtual alu_inf)::get(this,"","alu_inf",inf))
			`uvm_fatal(get_type_name(),"No interface is found")
	endfunction

	task run_phase(uvm_phase phase);
		// @(inf.MON.mon_clk);
		forever 
		begin
			//repeat(3)
		//	fork
			//begin
		//	@(inf.MON.mon_clk);
			//if(inf.MON.mon_clk.CE)
		//	begin
			@(inf.MON.mon_clk);
			`uvm_info(get_type_name(),"starting of output monitor",UVM_LOW)
			trans=alu_transaction::type_id::create("trans");
			trans.ce=inf.MON.mon_clk.CE;
			trans.mode=inf.MON.mon_clk.MODE;
			trans.cin=inf.MON.mon_clk.CIN;
			trans.cmd=inf.MON.mon_clk.CMD;
			trans.inp_valid=inf.MON.mon_clk.INP_VALID;
			trans.opa=inf.MON.mon_clk.OPA;
			trans.opb=inf.MON.mon_clk.OPB;
	//		@(inf.MON.mon_clk);
			
			trans.res=inf.MON.mon_clk.RES;
			trans.cout=inf.MON.mon_clk.COUT;
			trans.oflow=inf.MON.mon_clk.OFLOW;
			trans.g=inf.MON.mon_clk.G;
			trans.l=inf.MON.mon_clk.L;
			trans.e=inf.MON.mon_clk.E;
		//	`uvm_info("OUPUT_MONITOR", $sformatf("Observed on DUT pins:\n%s", trans.sprint()), UVM_LOW)
		//	$display("output monitor");
			out_mon_port.write(trans);
			`uvm_info("OUPUT_MONITOR", $sformatf("Observed on DUT pins:\n%s", trans.sprint()), UVM_LOW)	


      			//`uvm_info("OUTPUT_MONITOR", $sformatf("Monitored pins -> OUT: [RES:%0h COUT:%0b OFLOW:%0b G:%0b,L:%0b E:%0b]",trans.res, trans.cout, trans.oflow, trans.g, trans.l, 				trans.e), UVM_LOW)
      
      			//`uvm_info("DONE", "----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------", UVM_LOW)
//			`uvm_info(get_type_name(),"end of output monitor",UVM_LOW);
		//end
		end
	endtask
endclass



 	


	

