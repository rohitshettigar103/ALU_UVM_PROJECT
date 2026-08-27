class alu_test extends uvm_test;
	`uvm_component_utils(alu_test)

	alu_environment env;

	function new(string name="alu_test",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		env=alu_environment::type_id::create("env",this);
	endfunction

	function void end_of_elaboration_phase(uvm_phase phase);
		super.end_of_elaboration_phase(phase);
		uvm_top.print_topology();
	endfunction

endclass

class test1 extends alu_test;
	`uvm_component_utils(test1)
	simple_sequence seq;

	function new(string name="test1",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction

	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		//#20;//so that data can settle and start capturing from 20
		 seq=simple_sequence::type_id::create("seq");
		repeat(5) seq.start(env.agnt1.sqr);
		#40;//before comming out let the data be stable
		phase.drop_objection(this);
	endtask
endclass

class test2 extends alu_test;
	`uvm_component_utils(test2)
	airth_sequence seq;

	function new(string name="test2",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction

	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		//#20;
		seq=airth_sequence::type_id::create("seq");
		 seq.start(env.agnt1.sqr);
		#50;
		phase.drop_objection(this);
	endtask
endclass

class test4 extends alu_test;
	`uvm_component_utils(test4)
	logical_sequence seq;

	function new(string name="test4",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction

	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		//#20;
		seq=logical_sequence::type_id::create("seq");
		repeat(15) seq.start(env.agnt1.sqr);
		//#50;
		phase.drop_objection(this);
	endtask
endclass

class test3 extends alu_test;
	`uvm_component_utils(test3)
	err_sequence seq;

	function new(string name="test3",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction

	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		//#20;
		seq=err_sequence::type_id::create("seq");
		seq.start(env.agnt1.sqr);
		#50;
		phase.drop_objection(this);
	endtask
endclass
