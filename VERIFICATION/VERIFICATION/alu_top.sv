`include "alu_interface.sv"
`include "alu_tst_pkg.sv"
`include "alu_design.sv"

module tbench_top;
        import uvm_pkg::*;
        import alu_tst_pkg::*;

        // Clock and Reset declarations
        logic clk;
        logic rst;

        // Generate Clock (10ns period -> 100MHz)
        initial begin
                clk = 0;
                forever #5 clk = ~clk;
        end

        // Generate Reset
        initial begin
                rst = 0;
	end
     

        // Instantiate the Interface passing both arguments (clk and rst)
        alu_inf inf(clk, rst);

        // Instantiate the ALU Design Under Test (DUT)
        ALU_DESIGN #(
                .DW(8),
                .CW(4)
        ) dut (
                .CLK       (clk),
                .RST       (rst),
                .CE        (inf.CE),
                .MODE      (inf.MODE),
                .CIN       (inf.CIN),
                .CMD       (inf.CMD),
                .INP_VALID (inf.INP_VALID),
                .OPA       (inf.OPA),
                .OPB       (inf.OPB),
                .COUT      (inf.COUT),
                .OFLOW     (inf.OFLOW),
                .RES       (inf.RES),
                .G         (inf.G),
                .E         (inf.E),
                .L         (inf.L),
                .ERR       (inf.ERR)
        );

        // Store the virtual interface into the uvm_config_db and launch the test
        initial begin
                uvm_config_db#(virtual alu_inf)::set(null, "*", "alu_inf", inf);
                run_test("test3");
        end

endmodule
