class alu_environment extends uvm_env;
	`uvm_component_utils(alu_environment)
	alu_active_agent agnt1;
	alu_passive_agent agnt2;
	alu_scoreboard scr;

	function new(string name="alu_environment",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		uvm_config_db#(uvm_active_passive_enum)::set(this,"agnt1","is_active",UVM_ACTIVE);
		uvm_config_db#(uvm_active_passive_enum)::set(this,"agnt2","is_active",UVM_PASSIVE);
		agnt1=alu_active_agent::type_id::create("agnt1",this);
		agnt2=alu_passive_agent::type_id::create("agnt2",this);
		scr=alu_scoreboard::type_id::create("scr",this);
	endfunction

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		agnt1.aport1.connect(scr.fifo_in.analysis_export);
		agnt2.aport2.connect(scr.fifo_op.analysis_export);
	
	
	endfunction
endclass


