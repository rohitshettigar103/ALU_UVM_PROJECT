class alu_passive_agent extends uvm_agent;
	`uvm_component_utils(alu_passive_agent)
	//alu_driver drv;
	//alu_sequencer sqr;
	alu_out_monitor mon;
	uvm_analysis_port#(alu_transaction) aport2;

	function new(string name="alu_passive_agent",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		aport2=new("aport",this);
		mon=alu_out_monitor::type_id::create("mon",this);
	/*	if(get_is_active()==UVM_ACTIVE)
		begin
		drv=alu_driver::type_id::create("drv",this);
		sqr=alu_sequencer::type_id::create("sqr",this);
		end*/
	endfunction

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		mon.out_mon_port.connect(aport2);
		/*if(get_is_active()==UVM_ACTIVE)
		begin
		drv.seq_item_port.connect(sqr.seq_item_export);
		end*/
	endfunction 
endclass





