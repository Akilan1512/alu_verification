`include "interface.sv"
`include "test_pkg.sv"
`include "uvm_macros.svh"
//`include "alu_config.sv"
`include "design.sv"

 module top();       
	import uvm_pkg::*;
    import test_pkg::*;
	bit clk;

	alu_if DUV_IF(clk);

   
 //instatiate DUV
   ALU_DESIGN DUV(.OPA(DUV_IF.OPA),.OPB(DUV_IF.OPB),.CLK(DUV_IF.clk),.RST(DUV_IF.RST),.CE(DUV_IF.CE),.MODE(DUV_IF.MODE),
		.CIN(DUV_IF.CIN),.CMD(DUV_IF.CMD),.INP_VALID(DUV_IF.INP_VALID),.RES(DUV_IF.RES),.COUT(DUV_IF.COUT),
		.OFLOW(DUV_IF.OFLOW),.G(DUV_IF.G),.E(DUV_IF.E),.L(DUV_IF.L),.ERR(DUV_IF.ERR));

   alu_config cfg;

 	initial
	begin
      //uvm_config_db#(virtual alu_if)::set(null,"*","alu_if",DUV_IF);
       cfg = alu_config::type_id::create("cfg");

       cfg.vif = DUV_IF;

      uvm_config_db#(alu_config)::set(
        null,
        "*",
        "alu_config",
        cfg
      );
		$dumpfile("dump.vcd");
        $dumpvars(0,top);

      run_test("test1");
		
	end


	
	initial
	begin
		clk=1'b0;
		forever 
		   #5 clk=~clk;
	end
   
      
  /* initial begin
      $dumpfile("dump.vcd");
     $dumpvars;
   end */

endmodule

