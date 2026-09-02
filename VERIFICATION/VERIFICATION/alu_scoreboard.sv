/*class alu_scoreboard extends uvm_scoreboard;
	`uvm_component_utils(alu_scoreboard)

	alu_transaction ref_in_mon;
	alu_transaction check_out_mon;

	uvm_tlm_analysis_fifo#(alu_transaction)in_fifo;
	uvm_tlm_analysis_fifo#(alu_transaction)out_fifo;

	function new(string name="alu_scoreboard",uvm_component parent);
		super.new(name,parent);

		in_fifo=new("in_fifo",this);
		out_fifo=new("out_fifo",this);
	endfunction

	task run_phase(uvm_phase phase);
		forever
		begin
			in_fifo.get(ref_in_mon);
			out_fifo.get(check_out_mon);
			//ref_model(ref_in_mon);
			`uvm_info("REFERENCE_MODEL",$sformatf("REFERENCE_MODEL\n%s",ref_in_mon.sprint()),UVM_NONE)
			//validate_out();
			check_out(check_out_mon);
			`uvm_info("CHECKING OUTPUT ",$sformatf("CHECKING OUTPUT\n%s",check_out_mon.sprint()),UVM_NONE)
		end
	endtask

	task check_out(alu_transaction t);
		if(ref_in_mon.res==t.res)
			$display("RES MATCHED");
		else
			$display("RES MISMATCH");
	
		if(ref_in_mon.err==t.err)
			$display("ERR MATCHED");
		else
			$display("ERR MISMATCH");

		if(ref_in_mon.cout==t.cout)
			$display("COUT MATCHED");
		else
			$display("COUT MISMATCH");
	
		if(ref_in_mon.oflow==t.oflow)
			$display("OFLOW MATCHED");
		else
			$display("OFLOW MISMATCH");
		
		if(ref_in_mon.g==t.g)
			$display("G MATCHED");
		else
			$display("G MISMATCH");
		
		if(ref_in_mon.e==t.e)
			$display("E MATCHED");
		else
			$display("E MISMATCH");

		if(ref_in_mon.l==t.l)
			$display("L MATCHED");
		else
			$display("L MISMATCH");
	endtask

	//task ref_model(alu_transaction t);




endclass	*/
/*
class alu_scoreboard extends uvm_scoreboard;
	`uvm_component_utils(alu_scoreboard)

	alu_transaction ref_in_mon;
	alu_transaction check_out_mon;

	uvm_tlm_analysis_fifo#(alu_transaction) in_fifo;
	uvm_tlm_analysis_fifo#(alu_transaction) out_fifo;

	// Pass and Fail Counters
	int pass_count = 0;
	int fail_count = 0;

	// --- 16-Cycle Timeout Tracking Variables ---
	int       wait_counter    = 0;
	bit       waiting_for_opb = 0;
	bit [3:0] active_cmd;

	function new(string name="alu_scoreboard", uvm_component parent);
		super.new(name,parent);
		in_fifo  = new("in_fifo",this);
		out_fifo = new("out_fifo",this);
	endfunction

	task run_phase(uvm_phase phase);
		forever begin
			in_fifo.get(ref_in_mon);
			out_fifo.get(check_out_mon);

			// 1. Check 16-cycle timeout conditions
			check_timeout(ref_in_mon, check_out_mon);

			// 2. Run reference model calculations
			ref_model(ref_in_mon);
			`uvm_info("REFERENCE_MODEL", $sformatf("REFERENCE_MODEL\n%s", ref_in_mon.sprint()), UVM_NONE)

			// 3. Compare outputs with actual DUT transaction
			check_out(check_out_mon);
			`uvm_info("CHECKING OUTPUT", $sformatf("CHECKING OUTPUT\n%s", check_out_mon.sprint()), UVM_NONE)
		end
	endtask

	function void report_phase(uvm_phase phase);
		super.report_phase(phase);
		`uvm_info("SCB_SUMMARY", $sformatf("=== SCOREBOARD REPORT === Passed: %0d | Failed: %0d", pass_count, fail_count), UVM_LOW)
	endfunction

	// --- Separated 16-Cycle Timeout Task ---
	virtual task check_timeout(alu_transaction in_tx, alu_transaction out_tx);
		/*if (in_tx.rst) begin
			waiting_for_opb = 0;
			wait_counter    = 0;
		end*/
/*		 if (in_tx.inp_valid == 2'b01) begin
			// OPA provided, start tracking the 16-cycle window
			waiting_for_opb = 1'b1;
			wait_counter    = 0;
			active_cmd      = in_tx.cmd;
		end
		else if (waiting_for_opb) begin
			// Check if command changed midway (which resets the counter)
			if (in_tx.cmd != active_cmd) begin
				`uvm_info("SCB_INFO", "Command changed midway! Resetting timeout counter.", UVM_MEDIUM)
				active_cmd   = in_tx.cmd;
				wait_counter = 0;
			end
			else begin
				wait_counter++;
			end

			// Check if 16 cycles expired without OPB
			if (wait_counter >= 16) begin
				if (out_tx.err === 1'b1) begin
					`uvm_info("SCB_PASS", "PASS! 16-cycle timeout error flag asserted correctly.", UVM_LOW)
					pass_count++;
				end else begin
					`uvm_error("SCB_FAIL", "FAIL! 16 cycles reached but ERR flag is NOT asserted!")
					fail_count++;
				end
				waiting_for_opb = 0;
				wait_counter    = 0;
			end
		end

		// If both operands are provided, complete transaction and clear tracking
		if (in_tx.inp_valid == 2'b11) begin
			waiting_for_opb = 0;
			wait_counter    = 0;
		end
	endtask

	// --- Data Check Task ---
	task check_out(alu_transaction t);
		if(ref_in_mon.res === t.res) begin
			$display("RES MATCHED");
			pass_count++;
		end else begin
			$display("RES MISMATCH");
			fail_count++;
		end

		if(ref_in_mon.err === t.err) begin
			$display("ERR MATCHED");
			pass_count++;
		end else begin
			$display("ERR MISMATCH");
			fail_count++;
		end

		if(ref_in_mon.cout === t.cout) begin
			$display("COUT MATCHED");
			pass_count++;
		end else begin
			$display("COUT MISMATCH");
			fail_count++;
		end

		if(ref_in_mon.oflow === t.oflow) begin
			$display("OFLOW MATCHED");
			pass_count++;
		end else begin
			$display("OFLOW MISMATCH");
			fail_count++;
		end

		if(ref_in_mon.g === t.g) begin
			$display("G MATCHED");
			pass_count++;
		end else begin
			$display("G MISMATCH");
			fail_count++;
		end

		if(ref_in_mon.e === t.e) begin
			$display("E MATCHED");
			pass_count++;
		end else begin
			$display("E MISMATCH");
			fail_count++;
		end

		if(ref_in_mon.l === t.l) begin
			$display("L MATCHED");
			pass_count++;
		end else begin
			$display("L MISMATCH");
			fail_count++;
		end
	endtask

	// --- Reference Model Task (Arithmetic & Logical) ---
	virtual task ref_model(alu_transaction t);
		bit[7:0]oprd1,oprd2;
		bit[3:0]CMD_tmp;
		bit[7:0]AU_out_tmp1,AU_out_tmp2,OPA_1,OPB_1;

		/*if(t.rst) begin
			oprd1=0;
			oprd2=0;
			CMD_tmp=0;
		end*/
/*		 if (t.inp_valid==2'b01) begin    
			oprd1=t.opa;
			CMD_tmp=t.cmd;
		end
		else if (t.inp_valid==2'b10) begin    
			oprd2=t.opb;
			CMD_tmp=t.cmd;
		end
		else if (t.inp_valid==2'b11) begin    
			oprd1=t.opa;
			oprd2=t.opb;
			CMD_tmp=t.cmd;
		end
		else begin    
			oprd1=0;
			oprd2=0;
			CMD_tmp=0;
		end 

		if(t.ce) begin
		/*	if(t.rst) begin
				t.res=9'bzzzzzzzzz;
				t.cout=1'bz;
				t.oflow=1'bz;
				t.g=1'bz;
				t.e=1'bz;
				t.l=1'bz;
				t.err=1'bz;
				AU_out_tmp1=0;
				AU_out_tmp2=0;
			end*/
	/*		if(t.mode) begin
				t.res=9'bzzzzzzzzz;
				t.cout=1'bz;
				t.oflow=1'bz;
				t.g=1'bz;
				t.e=1'bz;
				t.l=1'bz;
				t.err=1'bz;
				case(CMD_tmp)            
					4'b0000: begin             
						t.res=oprd1+oprd2;
						t.cout=t.res[8]?1:0;
					end
					4'b0001: begin
						t.oflow=(oprd1<oprd2)?1:0;
						t.res=oprd1-oprd2;
					end
					4'b0010: begin            
						t.res=oprd1+oprd2+t.cin;
						t.cout=t.res[8]?1:0;
					end
					4'b0011: begin             
						t.oflow=(oprd1<oprd2)?1:0;
						t.res=oprd1-oprd2-t.cin;
					end
					4'b0100: t.res=oprd1+1;    
					4'b0101: t.res=oprd1-1;    
					4'b0110: t.res=oprd2+1;    
					4'b0111: t.res=oprd2-1; 
					4'b1000: begin              
						t.res=9'bzzzzzzzzz;
						if(oprd1==oprd2) begin
							t.e=1'b1;
							t.g=1'bz;
							t.l=1'bz;
						end
						else if(oprd1>oprd2) begin
							t.e=1'bz;
							t.g=1'b1;
							t.l=1'bz;
						end
						else begin 
							t.e=1'bz;
							t.g=1'bz;
							t.l=1'b1;
						end
					end
					4'b1001: begin    
						AU_out_tmp1 = oprd1 + 1;
						AU_out_tmp2 = oprd2 + 1;
						t.res = AU_out_tmp1 * AU_out_tmp2;
					end
					4'b1010: begin    
						AU_out_tmp1 = oprd1 << 1;
						AU_out_tmp2 = oprd2;
						t.res = AU_out_tmp1 * AU_out_tmp2; 
					end
					default: begin
						t.res=9'bzzzzzzzzz;
						t.cout=1'bz;
						t.oflow=1'bz;
						t.g=1'bz;
						t.e=1'bz;
						t.l=1'bz;
						t.err=1'bz;
					end
				endcase
			end
			else begin         
				t.res=9'bzzzzzzzzz;
				t.cout=1'bz;
				t.oflow=1'bz;
				t.g=1'bz;
				t.e=1'bz;
				t.l=1'bz;
				t.err=1'bz;
				case(CMD_tmp)    
					4'b0000: t.res={1'b0,oprd1&oprd2};    
					4'b0001: t.res={1'b0,~(oprd1&oprd2)};
					4'b0010: t.res={1'b0,oprd1|oprd2};  
					4'b0011: t.res={1'b0,~(oprd1|oprd2)};
					4'b0100: t.res={1'b0,oprd1^oprd2};    
					4'b0101: t.res={1'b0,~(oprd1^oprd2)};  
					4'b0110: t.res={1'b0,~oprd1};        
					4'b0111: t.res={1'b0,~oprd2};        
					4'b1000: t.res={1'b0,oprd1>>1};        
					4'b1001: t.res={1'b0,oprd1<<1};
					4'b1010: t.res={1'b0,oprd2>>1};      
					4'b1011: t.res={1'b0,oprd2<<1};      
					4'b1100: begin  
						if(oprd2[0])
							OPA_1 = {oprd1[6:0], oprd1[7]};
						else
							OPA_1 = oprd1;

						if(oprd2[1])
							OPB_1 = {OPA_1[5:0], OPA_1[7:6]}; 
						else
							OPB_1= OPA_1;

						if(oprd2[2])
							t.res = {OPB_1[3:0], OPB_1[7:4]} ;
						else
							t.res = OPB_1;

						if(oprd2[4] | oprd2[5] | oprd2[6] | oprd2[7])
							t.err=1'b1;
					end
					4'b1101: begin
						if(oprd2[0])
							OPA_1 = {oprd1[0], oprd1[7:1]};
						else
							OPA_1 = oprd1;

						if(oprd2[1])
							OPB_1 = {OPA_1[1:0], OPA_1[7:2]}; 
						else
							OPB_1= OPA_1;

						if(oprd2[2])
							t.res = {OPB_1[3:0], OPB_1[7:4]} ;
						else
							t.res = OPB_1;

						if(oprd2[4] | oprd2[5] | oprd2[6] | oprd2[7])
							t.err=1'b1;
					end
					default: begin
						t.res=9'bzzzzzzzzz;
						t.cout=1'bz;
						t.oflow=1'bz;
						t.g=1'bz;
						t.e=1'bz;
						t.l=1'bz;
						t.err=1'bz;
					end
				endcase
			end
		end
	endtask
endclass*/
/*

class alu_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(alu_scoreboard)
  
  uvm_tlm_analysis_fifo #(alu_transaction) fifo_in;
  uvm_tlm_analysis_fifo #(alu_transaction) fifo_op;
  int total_txn;
  int pass_count;
  int fail_count;

  bit[`DW-1:0] op1;
  bit[`DW-1:0] op2;

  bit[1:0] inp_valid;

  bit ce;
  bit mode;
  bit cin;
  bit [`CW-1:0] cmd;

  bit[`DW*2-1:0] exp_res;
  bit exp_cout;
  bit exp_oflow;
  bit exp_g;
  bit exp_l;
  bit exp_e;
  bit exp_err;

  bit [`DW*2-1:0] exp_res2;
  bit exp_cout2;
  bit exp_oflow2;
  bit exp_g2;
  bit exp_l2;
  bit exp_e2;
  bit exp_err2;
  bit [`DW*2-1:0] exp_res3;

bit exp_g3;
bit exp_l3;
bit exp_e3;

  bit[`DW-1:0] mul_temp1, tempA;
  bit[`DW-1:0] mul_temp2, tempB;
  bit tempc;
  bit op1_valid;
  bit op2_valid;
  bit both_valid;
  alu_transaction inp_txn, out_txn, hold_txn;

  int wait_count;

  bit rst;
  bit mode_q;
  bit[`CW-1:0] cmd_q;
  bit cin_q;

  function new(string name="alu_scoreboard", uvm_component parent);
    super.new(name, parent);
    fifo_in = new("fifo1", this);
    fifo_op = new("fifo2", this);
  endfunction

  task reset_reference_model();
    exp_res = '0;
    exp_cout = '0;
    exp_oflow = '0;
    exp_g = '0;
    exp_e = '0;
    exp_l = '0;
    exp_err = '0;
    op1 = '0;
    op2 = '0;
    op1_valid = 1'b0;
    op2_valid = 1'b0;
    both_valid = 1'b0;
    wait_count = 0;
    mul_temp1 = '0;
    mul_temp2 = '0;
  endtask

  task run_phase(uvm_phase phase);
    forever begin
      fifo_in.get(inp_txn);
      capture_operands(inp_txn);
      total_txn++;
      fifo_op.get(out_txn);
      check_data(out_txn);
    end
  endtask

  task capture_operands(alu_transaction t);
    inp_valid = t.inp_valid;

    if (inp_valid == 1) begin
      op1 = t.opa;
      op1_valid = 1'b1;
      ce = t.ce;
      mode = t.mode;
      cmd = t.cmd;
      cin = t.cin;
      wait_count = 0;
    end
    else if (inp_valid == 2) begin
      op2 = t.opb;
      op2_valid = 1'b1;
      cmd = t.cmd;
      mode = t.mode;
      ce = t.ce;
      cin = t.cin;
      wait_count = 0;
    end
    else if (inp_valid == 3) begin
      op1 = t.opa;
      op2 = t.opb;
      both_valid = 1'b1;
      ce = t.ce;
      cmd = t.cmd;
      mode = t.mode;
      cin = t.cin;
      wait_count = 0;
    end

    if (ce && (op1_valid ^ op2_valid) && !both_valid) begin
      wait_count++;
      if (wait_count >= 16) begin
        exp_err2 = 1'b1;
        op1_valid = 1'b0;
        op2_valid = 1'b0;
        `uvm_warning(get_type_name(), "error")
      end
    end

    if (mode)
      arithmetic_operation();
    else
      logical_operation();
  endtask

  task arithmetic_operation();
    bit consumed;
    consumed = 1'b0;
    if (ce) begin
      case (cmd)
        4'd0: begin
          if ((op1_valid && op2_valid) || both_valid) begin
            exp_res2 = exp_res;
            exp_cout2 = exp_cout;
            exp_res = tempA + tempB;
            exp_cout = exp_res[`DW];
            tempA = op1;
            tempB = op2;
            consumed = 1'b1;
          end
        end
        4'd1: begin
          if ((op1_valid && op2_valid) || both_valid) begin
            exp_res2 = exp_res;
            exp_oflow2 = exp_oflow;
            exp_res = tempA - tempB;
            exp_oflow = (tempA<tempB);
            tempA = op1;
            tempB = op2;
            consumed = 1'b1;
          end
        end
        4'd2: begin
          if ((op1_valid && op2_valid) || both_valid) begin
            exp_res2 = exp_res;
            exp_cout2 = exp_cout;
            exp_res = tempA + tempB + tempc;
	exp_cout = exp_res[`DW];;
            tempA = op1;
            tempB = op2;
            tempc = cin;
            consumed = 1'b1;
          end
        end
        4'd3: begin
          if ((op1_valid && op2_valid) || both_valid) begin
            exp_res2 = exp_res;
            exp_res = tempA - tempB - tempc;
            exp_oflow2 = exp_oflow;
            exp_oflow = (op1<(op2+cin_q));
            tempA = op1;
            tempB = op2;
            tempc = cin;
            consumed = 1'b1;
          end
        end
        4'd4: begin
          if (op1_valid || both_valid) begin
            exp_res2 = exp_res;
            exp_res = tempA + 1;
            tempA = op1;
            consumed = 1'b1;
          end
        end
        4'd5: begin
          if (op1_valid || both_valid) begin
            exp_res2 = exp_res;
            exp_res = tempA;
            tempA = op1-1;
            consumed = 1'b1;
          end
        end
        4'd6: begin
          if (op2_valid || both_valid) begin
            exp_res2 = exp_res;
            exp_res = tempB + 1;
            tempB = op2;
            consumed = 1'b1;
          end
        end
        4'd7: begin
          if (op2_valid || both_valid) begin
            exp_res2 = exp_res;
            exp_res = tempB - 1;
            tempB = op2;
            consumed = 1'b1;
          end
        end
        4'd8: begin
          if ((op1_valid && op2_valid) || both_valid) begin
            //tempA = op1;
           //tempB = op2;
            if (op1 > op2) begin
		    exp_g3=exp_g2;
		    exp_e3=exp_e2;
		    exp_l3=exp_l2;
              exp_g2 = exp_g;
              exp_e2 = exp_e;
              exp_l2 = exp_l;
              exp_g = 1;
              exp_e = 0;
              exp_l = 0;
              consumed = 1'b1;
            end
            else if (op1 < op2) begin
		    exp_g3=exp_g2;
		    exp_e3=exp_e2;
		    exp_l3=exp_l2;

              exp_g2 = exp_g;
              exp_e2 = exp_e;
              exp_l2 = exp_l;
              exp_g = 0;
              exp_e = 0;
              exp_l = 1;
              consumed = 1'b1;
            end
            else begin
		    exp_g3=exp_g2;
		    exp_e3=exp_e2;
		    exp_l3=exp_l2;
              exp_g2 = exp_g;
              exp_e2 = exp_e;
              exp_l2 = exp_l;
              exp_g = 0;
              exp_e = 1;
              exp_l = 0;
              consumed = 1'b1;
            end
          end
        end
        4'd9: begin
          if ((op1_valid && op2_valid) || both_valid) begin
            if (inp_txn.cmd == 9 || inp_txn.cmd == 10) begin
		exp_res3=exp_res2;
              exp_res2 = exp_res;
              exp_res2 = tempA * tempB;
              tempA = mul_temp1 ;
              tempB = mul_temp2 ;
              mul_temp1 = op1 +1;
              mul_temp2 = op2 +1;
              consumed = 1'b1;
            end
          end
        end
        4'd10: begin
          if ((op1_valid && op2_valid) || both_valid) begin
            if (inp_txn.cmd == 9 || inp_txn.cmd == 10) begin
              exp_res2 = exp_res;
              exp_res2 = mul_temp1 * mul_temp2;
              mul_temp1 = tempA << 1;
              mul_temp2 = tempB;
              tempA = op1;
              tempB = op2;
              consumed = 1'b1;
            end
          end
        end
      endcase
      if (consumed) begin
        op1_valid = 1'b0;
        op2_valid = 1'b0;
        both_valid = 1'b0;
      end
    end
  endtask

  task logical_operation();
    bit consumed;
    consumed = 1'b0;
    if (ce) begin
      if (mode == 0) begin
        case (cmd)
          4'd0: begin
            if ((op1_valid && op2_valid) || both_valid) begin
		//exp_res3=exp_res2;
              exp_res2 = exp_res;
              exp_res = {1'b0, tempA & tempB};
              tempA = op1;
              tempB = op2;
              consumed = 1'b1;
            end
          end
          4'd1: begin
            if ((op1_valid && op2_valid) || both_valid) begin
              exp_res2 = exp_res;
              exp_res = tempA;
              tempA = {1'b0,~(op1&op2)};
              //tempB = op2;
              consumed = 1'b1;
            end
          end
          4'd2: begin
            if ((op1_valid && op2_valid) || both_valid) begin
              exp_res2 = exp_res;
              exp_res = {1'b0, tempA | tempB};
              tempA = op1;
              tempB = op2;
              consumed = 1'b1;
            end
          end
          4'd3: begin
            if ((op1_valid && op2_valid) || both_valid) begin
              exp_res2 = exp_res;
              exp_res = tempA;
              tempA = {1'b0,~(op1|op2)};
              //tempB = op2;
              consumed = 1'b1;
            end
          end
          4'd4: begin
            if ((op1_valid && op2_valid) || both_valid) begin
              exp_res2 = exp_res;
              exp_res = tempA;
              tempA = {1'b0,(op1^op2)};
              //tempB = op2;
              consumed = 1'b1;
            end
          end
          4'd5: begin
            if ((op1_valid && op2_valid) || both_valid) begin
              exp_res2 = exp_res;
              exp_res = tempA;
              tempA = {1'b0,~(op1^op2)};
              //tempB = op2;
              consumed = 1'b1;
            end
          end
          4'd6: begin
            if (op1_valid || both_valid) begin
              exp_res2 = exp_res;
              exp_res = tempA;
		    tempA = {1'b0,~op1};
              consumed = 1'b1;
            end
          end
          4'd7: begin
            if (op2_valid || both_valid) begin
              exp_res2 = exp_res;
              exp_res = tempB;
              tempB = {1'b0,~op2};
              consumed = 1'b1;
            end
          end
          4'd8: begin
            if (op1_valid || both_valid) begin
              exp_res2 = exp_res;
              exp_res = tempA;
		    tempA = {1'b0,op1 >> 1};
              consumed = 1'b1;
            end
          end
          4'd9: begin
            if (op1_valid || both_valid) begin
              exp_res2 = exp_res;
              exp_res = tempA;
              tempA = {1'b0,op1<<1};
              consumed = 1'b1;
            end
          end
          4'd10: begin
            if (op2_valid || both_valid) begin
              exp_res2 = exp_res;
              exp_res = tempB;
              tempB = {1'b0,op2>>1};
              consumed = 1'b1;
            end
          end
          4'd11: begin
            if (op2_valid || both_valid) begin
              exp_res2 = exp_res;
              exp_res = tempB;
              tempB = {1'b0,op2<<1};
              consumed = 1'b1;
            end
          end
          4'd12: begin
            if ((op1_valid && op2_valid) || both_valid) begin
              int shift;
              shift = tempA[$clog2(`DW)-1:0];
              exp_res2 = exp_res;
              exp_err2 = exp_err;
              exp_res = '0;
              exp_res[`DW-1:0] = (tempA << shift) | (tempA >> (`DW-shift));
              exp_err = |tempB[`DW-1:$clog2(`DW)+1];
              tempA = op1;
              tempB = op2;
              consumed = 1'b1;
            end
          end
          4'd13: begin
            if ((op1_valid && op2_valid) || both_valid) begin
              int shift;
              shift = tempB[$clog2(`DW)-1:0];
              exp_res2 = exp_res;
              exp_err2 = exp_err;
              exp_res = '0;
              exp_res[`DW-1:0] = (tempA >> shift) | (tempA << (`DW-shift));
              exp_err = |tempB[`DW-1:$clog2(`DW)+1];
              tempA = op1;
              tempB = op2;
              consumed = 1'b1;
            end
          end
        endcase
        if (consumed) begin
          op1_valid = 1'b0;
          op2_valid = 1'b0;
          both_valid = 1'b0;
        end
      end
    end
  endtask

  task check_data(alu_transaction t);
    `uvm_info("SCB", $sformatf("EXP: RES=%0h COUT=%0b OFLOW=%0b G=%0b E=%0b L=%0b ERR=%0b",
              exp_res2, exp_cout2, exp_oflow2, exp_g2, exp_e2, exp_l2, exp_err2), UVM_LOW)
    `uvm_info("SCB", $sformatf("ACT: RES=%0h COUT=%0b OFLOW=%0b G=%0b E=%0b L=%0b ERR=%0b",
              t.res, t.cout, t.oflow, t.g, t.e, t.l, t.err), UVM_LOW)

    if (t.res === exp_res2 && t.cout === exp_cout2 && t.g === exp_g3 && t.l === exp_l3
        && t.e === exp_e3 && t.oflow === exp_oflow2 && t.err === exp_err2) begin
      `uvm_info("SCB", "PASS", UVM_LOW)
      pass_count++;
    end
    else begin
      `uvm_info("SCB", "FAIL", UVM_LOW)
      fail_count++;
    end

    if (exp_err2 == 1'b1 || wait_count >= 16) begin
      exp_err2 = 1'b0;
      wait_count = 1'b0;
    end
  endtask

  virtual function void extract_phase(uvm_phase phase);
    super.extract_phase(phase);
    `uvm_info("RESULTS", $sformatf("TOTAL=%0d PASS_COUNT=%0d FAIL_COUNT=%0d",
              total_txn, pass_count, fail_count), UVM_LOW)
  endfunction

endclass */
/*


class alu_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(alu_scoreboard)

  uvm_tlm_analysis_fifo #(alu_transaction) fifo_in;
  uvm_tlm_analysis_fifo #(alu_transaction) fifo_op;
  int total_txn;
  int pass_count;
  int fail_count;

  bit[`DW-1:0] op1;
  bit[`DW-1:0] op2;

  bit[1:0] inp_valid;

  bit ce;
  bit mode;
  bit cin;
  bit [`CW-1:0] cmd;

  // ------------------------------------------------------------------
  // Pipeline stages for every output field. Stage 0 (no suffix) is the
  // value computed THIS transaction. Stage 1 (_2) / Stage 2 (_3) are
  // delayed copies representing the DUT's output latency.
  //
  // IMPORTANT: all seven fields (res, cout, oflow, g, e, l, err) share
  // ONE pipeline that advances exactly once per consumed transaction,
  // regardless of which command executed. A command only overwrites the
  // stage-0 field(s) it's actually responsible for (e.g. CMP only
  // touches g/e/l, ADD only touches res/cout) -- fields a command
  // doesn't touch simply carry their previous stage-0 value forward,
  // same as an idle pipeline register would in real hardware. This is
  // what keeps RES and G/E/L in lockste
  bit[`DW*2-1:0] exp_res;
  bit exp_cout;
  bit exp_oflow;
  bit exp_g;
  bit exp_l;
  bit exp_e;
  bit exp_err;

  bit [`DW*2-1:0] exp_res2;
  bit exp_cout2;
  bit exp_oflow2;
  bit exp_g2;
  bit exp_l2;
  bit exp_e2;
  bit exp_err2;

  bit [`DW*2-1:0] exp_res4;
  bit [`DW*2-1:0] exp_res3;
  bit exp_cout3;
  bit exp_cout4;
  bit exp_oflow3;
  bit exp_g3;
  bit exp_l3;
  bit exp_e3;
  bit exp_err3;

  bit last_consumed;
  
  bit[`DW-1:0] mul_temp1;
  bit[`DW-1:0] mul_temp2;

  bit op1_valid;
  bit op2_valid;
  bit both_valid;
  alu_transaction inp_txn, out_txn, hold_txn;

  int wait_count;

  bit rst;
  bit mode_q;
  bit[`CW-1:0] cmd_q;
  bit cin_q;

  function new(string name="alu_scoreboard", uvm_component parent);
    super.new(name, parent);
    fifo_in = new("fifo1", this);
    fifo_op = new("fifo2", this);
  endfunction

  task reset_reference_model();
    exp_res = '0; exp_cout = '0;exp_oflow = '0;
    exp_g = '0; exp_e = '0;exp_l = '0;exp_err = '0;

    exp_res2 = '0;exp_cout2 = '0; exp_oflow2 = '0;
    exp_g2 = '0;exp_e2 = '0;exp_l2 = '0;exp_err2 = '0;

	  exp_res3 = '0; exp_res4=0;   exp_cout3 = '0;   exp_oflow3 = '0;
    exp_g3 = '0;      exp_e3 = '0;      exp_l3 = '0;      exp_err3 = '0;

    op1 = '0;
    op2 = '0;
    op1_valid = 1'b0;
    op2_valid = 1'b0;
    both_valid = 1'b0;
    wait_count = 0;
    mul_temp1 = '0;
    mul_temp2 = '0;
    last_consumed = 1'b0;
  endtask

  task run_phase(uvm_phase phase);
    forever begin
      fifo_in.get(inp_txn);
      capture_operands(inp_txn);
      total_txn++;
      fifo_op.get(out_txn);
      check_data(out_txn);
    end
  endtask

  task capture_operands(alu_transaction t);
    inp_valid = t.inp_valid;

    if (inp_valid == 1) begin
      op1 = t.opa;
      op1_valid = 1'b1;
      ce = t.ce;
      mode = t.mode;
      cmd = t.cmd;
      cin = t.cin;
      wait_count = 0;
    end
    else if (inp_valid == 2) begin
      op2 = t.opb;
      op2_valid = 1'b1;
      cmd = t.cmd;
      mode = t.mode;
      ce = t.ce;
      cin = t.cin;
      wait_count = 0;
    end
    else if (inp_valid == 3) begin
      op1 = t.opa;
      op2 = t.opb;
      both_valid = 1'b1;
      ce = t.ce;
      cmd = t.cmd;
      mode = t.mode;
      cin = t.cin;
      wait_count = 0;
    end

    if (ce && (op1_valid ^ op2_valid) && !both_valid) begin
      wait_count++;
      if (wait_count >= 16) begin
        exp_err = 1'b1;
        op1_valid = 1'b0;
        op2_valid = 1'b0;
        `uvm_warning(get_type_name(), "error")
      end
    end

    last_consumed = 1'b0;

    if (mode)
      arithmetic_operation();
    else
      logical_operation();

   
    if (last_consumed) begin
	exp_res4=exp_res3;      exp_res3   = exp_res2;   exp_res2   = exp_res;
	    exp_cout4=exp_cout3;exp_cout3  = exp_cout2;  exp_cout2  = exp_cout;
      exp_oflow3 = exp_oflow2; exp_oflow2 = exp_oflow;
      exp_g3 = exp_g2;     exp_g2 = exp_g;
      exp_e3  = exp_e2;     exp_e2 = exp_e;
      exp_l3  = exp_l2;     exp_l2 = exp_l;
      exp_err3 = exp_err2;   exp_err2 = exp_err;
    end
  endtask

  task arithmetic_operation();
    bit consumed;
    consumed = 1'b0;
    if (ce) begin
      case (cmd)
        4'd0: begin // ADD
          if ((op1_valid && op2_valid) || both_valid) begin
            exp_res = op1 + op2;
            exp_cout = exp_res[`DW];
            consumed = 1'b1;
          end
        end
        4'd1: begin // SUB
          if ((op1_valid && op2_valid) || both_valid) begin
            exp_res = op1 - op2;
            // DUT's "oflow" for subtraction is an unsigned borrow flag:
            // it goes high whenever op1 < op2.
            exp_oflow = (op1 < op2);
            consumed = 1'b1;
          end
        end
        4'd2: begin // ADD w/ carry-in
          if ((op1_valid && op2_valid) || both_valid) begin
            exp_res = op1 + op2 + cin;
            exp_cout = exp_res[`DW];
            consumed = 1'b1;
          end
        end
        4'd3: begin // SUB w/ borrow-in
          if ((op1_valid && op2_valid) || both_valid) begin
            exp_res = op1 - op2 - cin;
            // Unsigned borrow including the incoming borrow bit.
            exp_oflow = (op1 < (op2 + cin));
            consumed = 1'b1;
          end
        end
        4'd4: begin // INC A
          if (op1_valid || both_valid) begin
            exp_res = op1 + 1;
            consumed = 1'b1;
          end
        end
        4'd5: begin // DEC A
          if (op1_valid || both_valid) begin
            exp_res = op1 - 1;
            consumed = 1'b1;
          end
        end
        4'd6: begin // INC B
          if (op2_valid || both_valid) begin
            exp_res = op2 + 1;
            consumed = 1'b1;
          end
        end
        4'd7: begin // DEC B
          if (op2_valid || both_valid) begin
            exp_res = op2 - 1;
            consumed = 1'b1;
          end
        end
        4'd8: begin // COMPARE
          if ((op1_valid && op2_valid) || both_valid) begin
		exp_res=1'b0;
            if (op1 > op2)      begin exp_g = 1; exp_e = 0; exp_l = 0; end
            else if (op1 < op2) begin exp_g = 0; exp_e = 0; exp_l = 1; end
            else                 begin exp_g = 0; exp_e = 1; exp_l = 0; end
            consumed = 1'b1;
          end
        end
        4'd9: begin // MULTIPLY - partial product stage 1
          if ((op1_valid && op2_valid) || both_valid) begin
            if (inp_txn.cmd == 9 || inp_txn.cmd == 10) begin
              exp_res = op1 * op2;
              mul_temp1 = op1;
              mul_temp2 = op2;
              consumed = 1'b1;
            end
          end
        end
        4'd10: begin // MULTIPLY - partial product stage 2
          if ((op1_valid && op2_valid) || both_valid) begin
            if (inp_txn.cmd == 9 || inp_txn.cmd == 10) begin
              exp_res = mul_temp1 * mul_temp2;
              mul_temp1 = op1;
              mul_temp2 = op2;
              consumed = 1'b1;
            end
          end
        end
      endcase
      if (consumed) begin
        op1_valid = 1'b0;
        op2_valid = 1'b0;
        both_valid = 1'b0;
      end
    end
    last_consumed = consumed;
  endtask

  task logical_operation();
    bit consumed;
    consumed = 1'b0;
    if (ce) begin
      if (mode == 0) begin
        case (cmd)
          4'd0: begin // AND
            if ((op1_valid && op2_valid) || both_valid) begin
              exp_res = {1'b0, op1 & op2};
              consumed = 1'b1;
            end
          end
          4'd1: begin // NAND
            if ((op1_valid && op2_valid) || both_valid) begin
              exp_res = {1'b0, ~(op1 & op2)};
              consumed = 1'b1;
            end
          end
          4'd2: begin // OR
            if ((op1_valid && op2_valid) || both_valid) begin
              exp_res = {1'b0, op1 | op2};
              consumed = 1'b1;
            end
          end
          4'd3: begin // NOR
            if ((op1_valid && op2_valid) || both_valid) begin
              exp_res = {1'b0, ~(op1 | op2)};
              consumed = 1'b1;
            end
          end
          4'd4: begin // XOR
            if ((op1_valid && op2_valid) || both_valid) begin
              exp_res = {1'b0, op1 ^ op2};
              consumed = 1'b1;
            end
          end
          4'd5: begin // XNOR
            if ((op1_valid && op2_valid) || both_valid) begin
              exp_res = {1'b0, ~(op1 ^ op2)};
              consumed = 1'b1;
            end
          end
          4'd6: begin // NOT A
            if (op1_valid || both_valid) begin
              exp_res = {1'b0, ~op1};
              consumed = 1'b1;
            end
          end
          4'd7: begin // NOT B
            if (op2_valid || both_valid) begin
              exp_res = {1'b0, ~op2};
              consumed = 1'b1;
            end
          end
          4'd8: begin // SHR A
            if (op1_valid || both_valid) begin
              exp_res = {1'b0, op1 >> 1};
              consumed = 1'b1;
            end
          end
          4'd9: begin // SHL A
            if (op1_valid || both_valid) begin
              exp_res = {1'b0, op1 << 1};
              consumed = 1'b1;
            end
          end
          4'd10: begin // SHR B
            if (op2_valid || both_valid) begin
              exp_res = {1'b0, op2 >> 1};
              consumed = 1'b1;
            end
          end
          4'd11: begin // SHL B
            if (op2_valid || both_valid) begin
              exp_res = {1'b0, op2 << 1};
              consumed = 1'b1;
            end
          end
          4'd12: begin // ROTATE LEFT A by A's low bits; err if B has stray high bits
            if ((op1_valid && op2_valid) || both_valid) begin
              int shift;
              shift = op1[$clog2(`DW)-1:0];
              exp_res = '0;
              exp_res[`DW-1:0] = (op1 << shift) | (op1 >> (`DW-shift));
              exp_err = |op2[`DW-1:$clog2(`DW)+1];
              consumed = 1'b1;
            end
          end
          4'd13: begin // ROTATE RIGHT A by B's low bits; err if B has stray high bits
            if ((op1_valid && op2_valid) || both_valid) begin
              int shift;
              shift = op2[$clog2(`DW)-1:0];
              exp_res = '0;
              exp_res[`DW-1:0] = (op1 >> shift) | (op1 << (`DW-shift));
              exp_err = |op2[`DW-1:$clog2(`DW)+1];
              consumed = 1'b1;
            end
          end
        endcase
        if (consumed) begin
          op1_valid = 1'b0;
          op2_valid = 1'b0;
          both_valid = 1'b0;
        end
      end
    end
    last_consumed = consumed;
  endtask

  task check_data(alu_transaction t);
    `uvm_info("SCB", $sformatf("EXP: RES=%0h COUT=%0b OFLOW=%0b G=%0b E=%0b L=%0b ERR=%0b",
              exp_res4, exp_cout3, exp_oflow3, exp_g3, exp_e3, exp_l3, exp_err3), UVM_LOW)
    `uvm_info("SCB", $sformatf("ACT: RES=%0h COUT=%0b OFLOW=%0b G=%0b E=%0b L=%0b ERR=%0b",
              t.res, t.cout, t.oflow, t.g, t.e, t.l, t.err), UVM_LOW)

    if (t.res === exp_res4 && t.cout === exp_cout3 && t.g === exp_g3 && t.l === exp_l3
        && t.e === exp_e3 && t.oflow === exp_oflow3 && t.err === exp_err3) begin
      `uvm_info("SCB", "PASS", UVM_LOW)
      pass_count++;
    end
    else begin
      `uvm_info("SCB", "FAIL", UVM_LOW)
      fail_count++;
    end

    if (exp_err3 == 1'b1 || wait_count >= 16) begin
      exp_err3 = 1'b0;
      wait_count = 1'b0;
    end
  endtask

  virtual function void extract_phase(uvm_phase phase);
    super.extract_phase(phase);
    `uvm_info("RESULTS", $sformatf("TOTAL=%0d PASS_COUNT=%0d FAIL_COUNT=%0d",
              total_txn, pass_count, fail_count), UVM_LOW)
  endfunction

endclass*/






class alu_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(alu_scoreboard)

  uvm_tlm_analysis_fifo #(alu_transaction) fifo_in;
  uvm_tlm_analysis_fifo #(alu_transaction) fifo_op;
  int total_txn;
  int pass_count;
  int fail_count;

  bit[`DW-1:0] op1;
  bit[`DW-1:0] op2;

  bit[1:0] inp_valid;

  bit ce;
  bit mode;
  bit cin;
  bit [`CW-1:0] cmd;
	
  bit[`DW*2-1:0] exp_res;
  bit exp_cout;
  bit exp_oflow;
  bit exp_g;
  bit exp_l;
  bit exp_e;
  bit exp_err;

  bit [`DW*2-1:0] exp_res2;
  bit exp_cout2;
  bit exp_oflow2;
  bit exp_g2;
  bit exp_l2;
  bit exp_e2;
  bit exp_err2;

  bit [`DW*2-1:0] exp_res3;
  bit [`DW*2-1:0] exp_res4;
  bit exp_cout3;
  bit exp_oflow3;
  bit exp_g3;
  bit exp_l3;
  bit exp_e3;
  bit exp_err3;
  bit last_consumed;
  bit[`DW-1:0] mul_temp1;
  bit[`DW-1:0] mul_temp2;

  bit op1_valid;
  bit op2_valid;
  bit both_valid;
	bit exp_g4;
  alu_transaction inp_txn, out_txn, hold_txn;

  int wait_count;

  bit rst;
  bit mode_q;
  bit[`CW-1:0] cmd_q;
  bit cin_q;

  function new(string name="alu_scoreboard", uvm_component parent);
    super.new(name, parent);
    fifo_in = new("fifo1", this);
    fifo_op = new("fifo2", this);
  endfunction

  task reset_reference_model();
    exp_res = '0; exp_cout = '0; exp_oflow = '0;
    exp_g = '0;  exp_e = '0; exp_l = '0; exp_err = '0;

    exp_res2 = '0; exp_cout2 = '0; exp_oflow2 = '0;
    exp_g2 = '0; exp_e2 = '0;  exp_l2 = '0; exp_err2 = '0;

    exp_res3 = '0;exp_cout3 = '0;  exp_oflow3 = '0;
    exp_g3 = '0;exp_e3 = '0; exp_l3 = '0;exp_err3 = '0;
	  exp_res4='0; exp_g4='0;

    op1 = '0;
    op2 = '0;
    op1_valid = 1'b0;
    op2_valid = 1'b0;
    both_valid = 1'b0;
    wait_count = 0;
    mul_temp1 = '0;
    mul_temp2 = '0;
    last_consumed = 1'b0;
  endtask

  task run_phase(uvm_phase phase);
    forever begin
      fifo_in.get(inp_txn);
      capture_operands(inp_txn);
      total_txn++;
      fifo_op.get(out_txn);
      check_data(out_txn);
    end
  endtask

  task capture_operands(alu_transaction t);
    inp_valid = t.inp_valid;

    if (inp_valid == 1) begin
      op1 = t.opa;
      op1_valid = 1'b1;
      ce = t.ce;
      mode = t.mode;
      cmd = t.cmd;
      cin = t.cin;
      wait_count = 0;
    end
    else if (inp_valid == 2) begin
      op2 = t.opb;
      op2_valid = 1'b1;
      cmd = t.cmd;
      mode = t.mode;
      ce = t.ce;
      cin = t.cin;
      wait_count = 0;
    end
    else if (inp_valid == 3) begin
      op1 = t.opa;
      op2 = t.opb;
      both_valid = 1'b1;
      ce = t.ce;
      cmd = t.cmd;
      mode = t.mode;
      cin = t.cin;
      wait_count = 0;
    end

    if (ce && (op1_valid ^ op2_valid) && !both_valid) begin
      wait_count++;
      if (wait_count >= 16) begin
        exp_err = 1'b1;
        op1_valid = 1'b0;
        op2_valid = 1'b0;
	 wait_count=0;
        `uvm_warning(get_type_name(), "error")
      end
    end

    last_consumed = 1'b0;

    if (mode)
      arithmetic_operation();
    else
      logical_operation();

    // Single, unconditional pipeline advance -- fires once per consumed
    // transaction regardless of command type, keeping every field's
    // latency bookkeeping in lockstep. See comment on the stage
    // declarations above for why this matters.
    //if (last_consumed) 
    //begin
	exp_res4=exp_res3;
      exp_res3   = exp_res2;   exp_res2   = exp_res;
      exp_cout3  = exp_cout2;  exp_cout2  = exp_cout;
      exp_oflow3 = exp_oflow2; exp_oflow2 = exp_oflow;
	exp_g4=exp_g3;
      exp_g3     = exp_g2;     exp_g2     = exp_g;
      exp_e3     = exp_e2;     exp_e2     = exp_e;
      exp_l3     = exp_l2;     exp_l2     = exp_l;
      exp_err3   = exp_err2;   exp_err2   = exp_err;
   // end
  endtask

  task arithmetic_operation();
    bit consumed;
    consumed = 1'b0;
    if (ce) begin
      case (cmd)
        4'd0: begin // ADD
          if ((op1_valid && op2_valid) || both_valid) begin
            exp_res = op1 + op2;
            exp_cout = exp_res[`DW];
            consumed = 1'b1;
          end
        end
        4'd1: begin // SUB
          if ((op1_valid && op2_valid) || both_valid) begin
            exp_res = op1 - op2;
            exp_oflow = (op1 < op2);
            consumed = 1'b1;
          end
        end
        4'd2: begin // ADD w/ carry-in
          if ((op1_valid && op2_valid) || both_valid) begin
            exp_res = op1 + op2 + cin;
            exp_cout = exp_res[`DW];
            consumed = 1'b1;
          end
        end
        4'd3: begin // SUB w/ borrow-in
          if ((op1_valid && op2_valid) || both_valid) begin
            exp_res = op1 - op2 - cin;
            // Unsigned borrow including the incoming borrow bit.
            exp_oflow = (op1 < (op2 + cin));
            consumed = 1'b1;
          end
        end
        4'd4: begin // INC A
          if (op1_valid || both_valid) begin
            exp_res = op1 + 1;
            consumed = 1'b1;
          end
        end
        4'd5: begin // DEC A
          if (op1_valid || both_valid) begin
            exp_res = op1 - 1;
            consumed = 1'b1;
          end
        end
        4'd6: begin // INC B
          if (op2_valid || both_valid) begin
            exp_res = op2 + 1;
            consumed = 1'b1;
          end
        end
        4'd7: begin // DEC B
          if (op2_valid || both_valid) begin
            exp_res = op2 - 1;
            consumed = 1'b1;
          end
        end
        4'd8: begin // COMPARE
          if ((op1_valid && op2_valid) || both_valid) begin
            if (op1 > op2)      begin exp_g = 1; exp_e = 0; exp_l = 0; end
            else if (op1 < op2) begin exp_g = 0; exp_e = 0; exp_l = 1; end
            else                 begin exp_g = 0; exp_e = 1; exp_l = 0; end
            consumed = 1'b1;
          end
        end
        4'd9: begin // MULTIPLY - partial product stage 1
          if ((op1_valid && op2_valid) || both_valid) begin
            if (inp_txn.cmd == 9 || inp_txn.cmd == 10) begin
              exp_res = op1 * op2;
              mul_temp1 = op1;
              mul_temp2 = op2;
              consumed = 1'b1;
            end
          end
        end
        4'd10: begin // MULTIPLY - partial product stage 2
          if ((op1_valid && op2_valid) || both_valid) begin
            if (inp_txn.cmd == 9 || inp_txn.cmd == 10) begin
              exp_res = mul_temp1 * mul_temp2;
              mul_temp1 = op1;
              mul_temp2 = op2;
              consumed = 1'b1;
            end
          end
        end
      endcase
      if (consumed) begin
        op1_valid = 1'b0;
        op2_valid = 1'b0;
        both_valid = 1'b0;
      end
    end
    last_consumed = consumed;
  endtask

  task logical_operation();
    bit consumed;
    consumed = 1'b0;
    if (ce) begin
      if (mode == 0) begin
        case (cmd)
          4'd0: begin // AND
            if ((op1_valid && op2_valid) || both_valid) begin
              exp_res = {1'b0, op1 & op2};
              consumed = 1'b1;
            end
          end
          4'd1: begin // NAND
            if ((op1_valid && op2_valid) || both_valid) begin
              exp_res = {1'b0, ~(op1 & op2)};
              consumed = 1'b1;
            end
          end
          4'd2: begin // OR
            if ((op1_valid && op2_valid) || both_valid) begin
              exp_res = {1'b0, op1 | op2};
              consumed = 1'b1;
            end
          end
          4'd3: begin // NOR
            if ((op1_valid && op2_valid) || both_valid) begin
              exp_res = {1'b0, ~(op1 | op2)};
              consumed = 1'b1;
            end
          end
          4'd4: begin // XOR
            if ((op1_valid && op2_valid) || both_valid) begin
              exp_res = {1'b0, op1 ^ op2};
              consumed = 1'b1;
            end
          end
          4'd5: begin // XNOR
            if ((op1_valid && op2_valid) || both_valid) begin
              exp_res = {1'b0, ~(op1 ^ op2)};
              consumed = 1'b1;
            end
          end
          4'd6: begin // NOT A
            if (op1_valid || both_valid) begin
              exp_res = {1'b0, ~op1};
              consumed = 1'b1;
            end
          end
          4'd7: begin // NOT B
            if (op2_valid || both_valid) begin
              exp_res = {1'b0, ~op2};
              consumed = 1'b1;
            end
          end
          4'd8: begin // SHR A
            if (op1_valid || both_valid) begin
              exp_res = {1'b0, op1 >> 1};
              consumed = 1'b1;
            end
          end
          4'd9: begin // SHL A
            if (op1_valid || both_valid) begin
              exp_res = {1'b0, op1 << 1};
              consumed = 1'b1;
            end
          end
          4'd10: begin // SHR B
            if (op2_valid || both_valid) begin
              exp_res = {1'b0, op2 >> 1};
              consumed = 1'b1;
            end
          end
          4'd11: begin // SHL B
            if (op2_valid || both_valid) begin
              exp_res = {1'b0, op2 << 1};
              consumed = 1'b1;
            end
          end
          4'd12: begin // ROTATE LEFT A by A's low bits; err if B has stray high bits
            if ((op1_valid && op2_valid) || both_valid) begin
              int shift;
              shift = op1[$clog2(`DW)-1:0];
              exp_res = '0;
              exp_res[`DW-1:0] = (op1 << shift) | (op1 >> (`DW-shift));
              exp_err = |op2[`DW-1:$clog2(`DW)+1];
              consumed = 1'b1;
            end
          end
          4'd13: begin // ROTATE RIGHT A by B's low bits; err if B has stray high bits
            if ((op1_valid && op2_valid) || both_valid) begin
              int shift;
              shift = op2[$clog2(`DW)-1:0];
              exp_res = '0;
              exp_res[`DW-1:0] = (op1 >> shift) | (op1 << (`DW-shift));
              exp_err = |op2[`DW-1:$clog2(`DW)+1];
              consumed = 1'b1;
            end
          end
        endcase
        if (consumed) begin
          op1_valid = 1'b0;
          op2_valid = 1'b0;
          both_valid = 1'b0;
        end
      end
    end
    last_consumed = consumed;
  endtask

  task check_data(alu_transaction t);
    `uvm_info("SCB", $sformatf("EXP: RES=%0h COUT=%0b OFLOW=%0b G=%0b E=%0b L=%0b ERR=%0b",
              exp_res4, exp_cout3, exp_oflow3, exp_g4, exp_e3, exp_l3, exp_err3), UVM_LOW)
    `uvm_info("SCB", $sformatf("ACT: RES=%0h COUT=%0b OFLOW=%0b G=%0b E=%0b L=%0b ERR=%0b",
              t.res, t.cout, t.oflow, t.g, t.e, t.l, t.err), UVM_LOW)

    if (t.res === exp_res4 && t.cout === exp_cout3 && t.g === exp_g4 && t.l === exp_l3
        && t.e === exp_e3 && t.oflow === exp_oflow3 && t.err === exp_err3) begin
      `uvm_info("SCB", "PASS", UVM_LOW)
      pass_count++;
    end
    else begin
      `uvm_info("SCB", "FAIL", UVM_LOW)
      fail_count++;
    end

    if (exp_err3 == 1'b1 || wait_count >= 16) begin
      exp_err3 = 1'b0;
      wait_count = 1'b0;
    end
  endtask

  virtual function void extract_phase(uvm_phase phase);
    super.extract_phase(phase);
    `uvm_info("RESULTS", $sformatf("TOTAL=%0d PASS_COUNT=%0d FAIL_COUNT=%0d",
              total_txn, pass_count, fail_count), UVM_LOW)
  endfunction

endclass
