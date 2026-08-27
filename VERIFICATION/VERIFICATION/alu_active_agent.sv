class alu_active_agent extends uvm_agent;
	`uvm_component_utils(alu_active_agent)
	alu_driver drv;
	alu_sequencer sqr;
	alu_in_monitor mon;
	uvm_analysis_port#(alu_transaction) aport1;

	function new(string name="alu_active_agent",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		aport1=new("aport",this);
		mon=alu_in_monitor::type_id::create("mon",this);
		if(get_is_active()==UVM_ACTIVE)
		begin
		drv=alu_driver::type_id::create("drv",this);
		sqr=alu_sequencer::type_id::create("sqr",this);
		end
	endfunction

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		mon.in_mon_port.connect(aport1);
		if(get_is_active()==UVM_ACTIVE)
		begin
		drv.seq_item_port.connect(sqr.seq_item_export);
		end
	endfunction
endclass





