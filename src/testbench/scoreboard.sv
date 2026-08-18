class scoreboard extends uvm_scoreboard;
        `uvm_component_utils(scoreboard)
	uvm_tlm_analysis_fifo #(seq_item)inp_mon_fifo;
	uvm_tlm_analysis_fifo #(seq_item)out_mon_fifo;
 
	seq_item inp_mon_xn;
	seq_item out_mon_xn;
        seq_item exp_item[int];
        seq_item exp_xn;
	
	bit [7:0] oprd1, oprd2;
	bit [3:0] CMD_tmp;
	bit oprd1_valid, oprd2_valid;
	int in_count,out_count;
 
	
	int total_txn;
	int total_match;
	int total_mismatch;
	int report_fd;   
function new(string name="scoreboard",uvm_component parent);
	super.new(name,parent);
	inp_mon_fifo=new("inp_mon_fifo",this);
	out_mon_fifo=new("out_mon_fifo",this);
	report_fd = $fopen("scoreboard_io_report.txt","w"); 
endfunction
 
task run_phase(uvm_phase phase);
	forever
		begin
		inp_mon_fifo.get(inp_mon_xn);
                in_count++;
                if(inp_mon_xn.MODE==1'b1 && inp_mon_xn.CMD inside{9,10})
                 exp_item[in_count+3]=inp_mon_xn;
                else
                 exp_item[in_count+2]=inp_mon_xn;
		out_mon_fifo.get(out_mon_xn);
                out_count++;
		ref_model(inp_mon_xn);
	   	`uvm_info("REFERENCE_MODEL",$sformatf("REFERENCE_MODEL\n%s",inp_mon_xn.sprint()),UVM_NONE)
		check_Data(out_mon_xn);
		`uvm_info("CHECKING OUTPUT ",$sformatf("CHECKING OUTPUT\n%s",out_mon_xn.sprint()),UVM_NONE)
 
		
		report_io(inp_mon_xn, out_mon_xn);
		end
endtask
 
 
virtual task validate_output();
	if(inp_mon_xn.compare(out_mon_xn))
	begin
	  `uvm_info(get_type_name,$sformatf("DATA MATCH SUCCESSFUL"),UVM_NONE)
	end
	else
	begin
	  `uvm_info(get_type_name,$sformatf("DATA DISMATCH SUCCESSFUL"),UVM_NONE)
	  `uvm_info(get_type_name,$sformatf("Expected Packet\n%s",inp_mon_xn.sprint()),UVM_NONE)
	  `uvm_info(get_type_name,$sformatf("DUT Packet\n%s",out_mon_xn.sprint()),UVM_NONE)
	end
	 endtask
 
task check_Data(seq_item ch);
	begin
	   if(inp_mon_xn.RES == ch.RES)
		$display("\n RES IS  MATCHING");
	   else
		$display("\n RES IS NOT MATCHING");
 
           if(inp_mon_xn.ERR == ch.ERR)
		$display("\n ERR IS MATCHING");
	   else
		$display("\n ERR IS NOT MATCHING");
 
	   if(inp_mon_xn.COUT == ch.COUT)
		$display("\n COUT IS MATCHING");
	   else
		$display("\n COUT IS NOT MATCHING");
 
	    if(inp_mon_xn.OFLOW == ch.OFLOW)
		$display("\n OFLOW IS MATCHING");
	   else
		$display("\n OFLOW IS NOT MATCHING");
 
            if(inp_mon_xn.G == ch.G)
		$display("\n Greater IS MATCHING");
	   else
		$display("\n Greater IS NOT MATCHING");
 
	   if(inp_mon_xn.L == ch.L)
		$display("\n Lesser IS MATCHING");
	   else
		$display("\n Lesser IS NOT MATCHING");
 
            if(inp_mon_xn.E == ch.E)
		$display("\n Equal IS MATCHING");
	   else
		$display("\n Equal IS NOT MATCHING");
	end
endtask
 
// ============================================================
// Added task: reports ALL input stimulus fields and ALL output
// fields (expected vs actual) for every transaction, writes the
// comparison to scoreboard_io_report.txt, and keeps a running
// pass/fail count for the final summary report.
// This task only reads fields and prints/counts - it does not
// touch or modify any existing checking / reference-model logic.
// ============================================================
task report_io(seq_item in, seq_item out);
	bit txn_match;
	begin
	  txn_match = (in.RES   == out.RES)   &&
	              (in.ERR   == out.ERR)   &&
	              (in.COUT  == out.COUT)  &&
	              (in.OFLOW == out.OFLOW) &&
	              (in.G     == out.G)     &&
	              (in.L     == out.L)     &&
	              (in.E     == out.E);
 
	  total_txn++;
	  if (txn_match)
	     total_match++;
	  else
	     total_mismatch++;
 
	  if (report_fd) begin
	     $fdisplay(report_fd, "---------------------------------------------------");
	     $fdisplay(report_fd, "TRANSACTION #%0d", total_txn);
	     $fdisplay(report_fd, "  INPUTS  : RST=%0b CE=%0b MODE=%0b CIN=%0b INP_VALID=%0b CMD=%0b OPA=%0d OPB=%0d",
	                in.RST, in.CE, in.MODE, in.CIN, in.INP_VALID, in.CMD, in.OPA, in.OPB);
	     $fdisplay(report_fd, "  EXPECTED: OPA=%0d OPB=%0d RES=%0d ERR=%0b COUT=%0b OFLOW=%0b G=%0b E=%0b L=%0b",
	                in.OPA,in.OPB, in.RES, in.ERR, in.COUT, in.OFLOW, in.G, in.E, in.L);
	     $fdisplay(report_fd, "  ACTUAL  : OPA=%0d OPB=%0d RES=%0d ERR=%0b COUT=%0b OFLOW=%0b G=%0b E=%0b L=%0b",
	                out.OPA,out.OPB,out.RES, out.ERR, out.COUT, out.OFLOW, out.G, out.E, out.L);
	     $fdisplay(report_fd, "  STATUS  : %s", txn_match ? "MATCH" : "MISMATCH");
	     $fdisplay(report_fd, "  FIELD-BY-FIELD:");
	     $fdisplay(report_fd, "    RES   : %s", (in.RES   == out.RES)   ? "MATCH" : "MISMATCH");
	     $fdisplay(report_fd, "    ERR   : %s", (in.ERR   == out.ERR)   ? "MATCH" : "MISMATCH");
	     $fdisplay(report_fd, "    COUT  : %s", (in.COUT  == out.COUT)  ? "MATCH" : "MISMATCH");
	     $fdisplay(report_fd, "    OFLOW : %s", (in.OFLOW == out.OFLOW) ? "MATCH" : "MISMATCH");
	     $fdisplay(report_fd, "    G     : %s", (in.G     == out.G)     ? "MATCH" : "MISMATCH");
	     $fdisplay(report_fd, "    L     : %s", (in.L     == out.L)     ? "MATCH" : "MISMATCH");
	     $fdisplay(report_fd, "    E     : %s", (in.E     == out.E)     ? "MATCH" : "MISMATCH");
	     $fdisplay(report_fd, "---------------------------------------------------\n");
	  end
 
	  `uvm_info("IO_REPORT",
	     $sformatf("\n---------------------------------------------------\n\
TRANSACTION #%0d\n\
  INPUTS  : RST=%0b CE=%0b MODE=%0b CIN=%0b INP_VALID=%0b CMD=%0b OPA=%0d OPB=%0d\n\
  EXPECTED: OPA=%0d OPB=%0d RES=%0d ERR=%0b COUT=%0b OFLOW=%0b G=%0b E=%0b L=%0b\n\
  ACTUAL  : OPA=%0d OPB=%0d RES=%0d ERR=%0b COUT=%0b OFLOW=%0b G=%0b E=%0b L=%0b\n\
  STATUS  : %s\n\
---------------------------------------------------",
	     total_txn,
	     in.RST, in.CE, in.MODE, in.CIN, in.INP_VALID, in.CMD, in.OPA, in.OPB,
	     in.OPA, in.OPB, in.RES, in.ERR, in.COUT, in.OFLOW, in.G, in.E, in.L,
	     out.OPA, out.OPB, out.RES, out.ERR, out.COUT, out.OFLOW, out.G, out.E, out.L,
	     txn_match ? "MATCH" : "MISMATCH"),
	     UVM_NONE)
	end
endtask
 

function void report_phase(uvm_phase phase);
	if (report_fd) begin
	   $fdisplay(report_fd, "=====================================================");
	   $fdisplay(report_fd, "SCOREBOARD SUMMARY REPORT");
	   $fdisplay(report_fd, "  TOTAL TRANSACTIONS CHECKED : %0d", total_txn);
	   $fdisplay(report_fd, "  TOTAL MATCH                : %0d", total_match);
	   $fdisplay(report_fd, "  TOTAL MISMATCH             : %0d", total_mismatch);
	   $fdisplay(report_fd, "=====================================================");
	end
 
	`uvm_info("IO_REPORT_SUMMARY",
	   $sformatf("\n=====================================================\n\
SCOREBOARD SUMMARY REPORT\n\
  TOTAL TRANSACTIONS CHECKED : %0d\n\
  TOTAL MATCH                : %0d\n\
  TOTAL MISMATCH              : %0d\n\
=====================================================",
	   total_txn, total_match, total_mismatch),
	   UVM_NONE)
endfunction
 
// Added: closes the .txt report file at the very end of the run
function void final_phase(uvm_phase phase);
	if (report_fd)
	   $fclose(report_fd);
endfunction
 
virtual task ref_model(seq_item t);
     bit[7:0]AU_out_tmp1,AU_out_tmp2,OPA_1,OPB_1;
     bit[7:0]oprd1,oprd2;
     bit[3:0]CMD_tmp;
     
     if(t.RST) begin
      oprd1 = 0;
      oprd2 = 0;
      CMD_tmp = 0;
    end
    else if (t.INP_VALID == 2'b01) begin
      oprd1 = t.OPA;
      CMD_tmp = t.CMD;
    end
    else if (t.INP_VALID == 2'b10) begin
      oprd2 = t.OPB;
      CMD_tmp = t.CMD;
    end
    else if (t.INP_VALID == 2'b11) begin
      oprd1 = t.OPA;
      oprd2 = t.OPB;
      CMD_tmp = t.CMD;
    end
    else begin
      oprd1 = 0;
      oprd2 = 0;
      CMD_tmp = 0;
    end
 
    if(t.CE) begin
      if(t.RST) begin
        t.RES = 16'b0;
        t.COUT = 1'b0;
        t.OFLOW = 1'b0;
        t.G = 1'b0;
        t.E = 1'b0;
        t.L = 1'b0;
        t.ERR = 1'b0;
        AU_out_tmp1 = 0;
        AU_out_tmp2 = 0;
      end
      else if(t.MODE) begin
        t.RES = 16'b0;
        t.COUT = 1'b0;
        t.OFLOW = 1'b0;
        t.G = 1'b0;
        t.E = 1'b0;
        t.L = 1'b0;
        t.ERR = 1'b0;
 
        case(CMD_tmp)
          4'b0000: begin
            t.RES = oprd1 + oprd2;
            t.COUT = t.RES[8] ? 1 : 0;
          end
          4'b0001: begin
            t.OFLOW = (oprd1 < oprd2) ? 1 : 0;
            t.RES = oprd1 - oprd2;
          end
          4'b0010: begin
            t.RES = oprd1 + oprd2 + t.CIN;
            t.COUT = t.RES[8] ? 1 : 0;
          end
          4'b0011: begin
            t.OFLOW = (oprd1 < oprd2) ? 1 : 0;
            t.RES = oprd1 - oprd2 - t.CIN;
          end
          4'b0100: t.RES = oprd1 + 1;
          4'b0101: t.RES = oprd1 - 1;
          4'b0110: t.RES = oprd2 + 1;
          4'b0111: t.RES = oprd2 - 1;
          4'b1000: begin
            t.RES = 16'b0;
            if(oprd1 == oprd2) begin
              t.E = 1'b1;
              t.G = 1'bz;
              t.L = 1'bz;
            end
            else if(oprd1 > oprd2) begin
              t.E = 1'bz;
              t.G = 1'b1;
              t.L = 1'bz;
            end
            else begin
              t.E = 1'bz;
              t.G = 1'bz;
              t.L = 1'b1;
            end
          end
          4'b1001: begin
            AU_out_tmp1 = oprd1 + 1;
            AU_out_tmp2 = oprd2 + 1;
            t.RES = AU_out_tmp1 * AU_out_tmp2;
          end
          4'b1010: begin
            AU_out_tmp1 = oprd1 << 1;
            AU_out_tmp2 = oprd2;
            t.RES = AU_out_tmp1 * AU_out_tmp2;
          end
          default: begin
            t.RES = 16'b0;
            t.COUT = 1'b0;
            t.OFLOW = 1'b0;
            t.G = 1'b0;
            t.E = 1'b0;
            t.L = 1'b0;
            t.ERR = 1'b0;
          end
        endcase
      end
      else begin
        t.RES = 16'b0;
        t.COUT = 1'b0;
        t.OFLOW = 1'b0;
        t.G = 1'b0;
        t.E = 1'b0;
        t.L = 1'b0;
        t.ERR = 1'b0;
 
        case(CMD_tmp)
          4'b0000: t.RES = {1'b0, oprd1 & oprd2};
          4'b0001: t.RES = {1'b0, ~(oprd1 & oprd2)};
          4'b0010: t.RES = {1'b0, oprd1 | oprd2};
          4'b0011: t.RES = {1'b0, ~(oprd1 | oprd2)};
          4'b0100: t.RES = {1'b0, oprd1 ^ oprd2};
          4'b0101: t.RES = {1'b0, ~(oprd1 ^ oprd2)};
          4'b0110: t.RES = {1'b0, ~oprd1};
          4'b0111: t.RES = {1'b0, ~oprd2};
          4'b1000: t.RES = {1'b0, oprd1 >> 1};
          4'b1001: t.RES = {1'b0, oprd1 << 1};
          4'b1010: t.RES = {1'b0, oprd2 >> 1};
          4'b1011: t.RES = {1'b0, oprd2 << 1};
          4'b1100: begin
            if(oprd2[0])
              OPA_1 = {oprd1[6:0], oprd1[7]};
            else
              OPA_1 = oprd1;
 
            if(oprd2[1])
              OPB_1 = {OPA_1[5:0], OPA_1[7:6]};
            else
              OPB_1 = OPA_1;
 
            if(oprd2[2])
              t.RES = {OPB_1[3:0], OPB_1[7:4]};
            else
              t.RES = OPB_1;
 
            if(oprd2[4] | oprd2[5] | oprd2[6] | oprd2[7])
              t.ERR = 1'b1;
          end
          4'b1101: begin
            if(oprd2[0])
              OPA_1 = {oprd1[0], oprd1[7:1]};
            else
              OPA_1 = oprd1;
 
            if(oprd2[1])
              OPB_1 = {OPA_1[1:0], OPA_1[7:2]};
            else
              OPB_1 = OPA_1;
 
            if(oprd2[2])
              t.RES = {OPB_1[3:0], OPB_1[7:4]};
            else
              t.RES = OPB_1;
 
            if(oprd2[4] | oprd2[5] | oprd2[6] | oprd2[7])
              t.ERR = 1'b1;
          end
          default: begin
            t.RES = 16'b0;
            t.COUT = 1'b0;
            t.OFLOW = 1'b0;
            t.G = 1'b0;
            t.E = 1'b0;
            t.L = 1'b0;
            t.ERR = 1'b0;
          end
        endcase
      end
    end
  endtask
endclass
        
