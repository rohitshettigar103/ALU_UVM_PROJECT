class alu_sequence extends uvm_sequence#(alu_transaction);

	`uvm_object_utils(alu_sequence)

	function new(string name="alu_sequence");
		super.new(name);
	endfunction

/*	virtual task body();
		alu_transaction trans;
		trans=alu_transaction::type_id::create("trans");
		start_item(trans);
		`uvm_info("alu_sequence","started generating seqence",UVM_LOW);
		assert(trans.randomize());
		trans.print();
		`uvm_info("alu_sequence","done generating seqence",UVM_LOW);
		finish_item(trans);
	endtask */
endclass

class simple_sequence extends alu_sequence;

	`uvm_object_utils(simple_sequence)

	function new(string name="simple_sequence");
		super.new(name);
	endfunction

	virtual task body();
		alu_transaction trans;
		trans=alu_transaction::type_id::create("trans");
		start_item(trans);
		//`uvm_info("simple_sequence","started generating seqence-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------",UVM_LOW);
		assert(trans.randomize() with {
				ce==1'b1;
				inp_valid==2'b11;
				cmd=='d0;
				opa<='d10;
				opb<='d10;
		});
//		trans.print();
		//`uvm_info("simple_sequence","done generating seqence",UVM_LOW);
		finish_item(trans);
	endtask
endclass

class airth_sequence extends alu_sequence;
	`uvm_object_utils(airth_sequence)

	function new(string name="airth_sequence");
		super.new(name);
	endfunction

	virtual task body();
		alu_transaction trans;
		for(int i=0;i<=11;i++)
		//repeat(10)
		begin
		trans=alu_transaction::type_id::create("trans");
		start_item(trans);
		`uvm_info("airth_sequence","started generating seqence",UVM_LOW);
		assert(trans.randomize() with {
			ce==1'b1;
			mode==1'b0;
			inp_valid==2'b11;
			cmd== i[3:0];
			cin ==1;
			//cmd==13;
			cmd inside{[0:11]};
			opa inside {[0:8]};
			opb inside {[0:8]};
		});
//		trans.print();
		`uvm_info("airth_sequence","done generating seqence",UVM_LOW);
		finish_item(trans);
		end
	endtask
endclass

class logical_sequence extends alu_sequence;
	`uvm_object_utils(logical_sequence)

	function new(string name="logical_sequence");
		super.new(name);
	endfunction

	virtual task body();
		alu_transaction trans;
		//for(int i=0;i<=13;i++)
		//begin
		trans=alu_transaction::type_id::create("trans");
		start_item(trans);
		`uvm_info("logical_sequence","started generating seqence",UVM_LOW);
		assert(trans.randomize() with {
			ce==1'b1;
			mode==1'b0;
			inp_valid==2'b11;
			//cmd==4'b0100;
			opa inside {[0:10]};
			opb inside {[0:10]};
		});
//		trans.print();
		`uvm_info("logical_sequence","done generating seqence",UVM_LOW);
		finish_item(trans);
		//end
	endtask
endclass


class err_sequence extends alu_sequence;
	`uvm_object_utils(err_sequence)

	function new(string name="err_sequence");
		super.new(name);
	endfunction

	virtual task body();
		alu_transaction trans;

		trans=alu_transaction::type_id::create("trans");
		start_item(trans);
		`uvm_info("err_sequence","started generating sequence",UVM_LOW)
		assert(trans.randomize() with {
			ce==1'b0;
			inp_valid==2'b11;
			opa inside {[0:9]};
			opb inside {[0:9]};
			mode==1'b1;
			cmd==0;
		});
		 trans.print();
		 `uvm_info("err_sequence","done generating sequence",UVM_LOW)
		finish_item(trans);
/*

		repeat(2)
		begin
			trans=alu_transaction::type_id::create("trans");
			start_item(trans);
			`uvm_info("err_sequence","started generating sequence",UVM_LOW);
			assert(trans.randomize() with {
				ce==1'b0;
				inp_valid==2'b00;
				mode==1'b1;
				cmd==0;
				opa inside {[0:9]};
				opb inside {[0:9]};
			});
		//	trans.print();
		 	`uvm_info("err_sequence","done generating sequence",UVM_LOW);
			finish_item(trans);
	
		end
*/
		repeat(1)
		begin
			trans=alu_transaction::type_id::create("trans");
			start_item(trans);
			`uvm_info("err_sequence","started generating sequence",UVM_LOW);
			assert(trans.randomize() with {
				ce==1'b1;
				inp_valid==2'b11;
				mode==1'b1;
				cmd==8;
				opa inside {[0:9]};
				opb inside {[0:9]};
			});
		//	trans.print();
		 	`uvm_info("err_sequence","done generating sequence",UVM_LOW);
			finish_item(trans);
	
		end




	endtask
endclass
