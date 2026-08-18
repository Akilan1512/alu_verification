class seq_item extends uvm_sequence_item;
  rand bit[`DW-1:0]OPA;
  rand bit[`DW-1:0]OPB;
  rand bit[1:0]INP_VALID;
  rand bit[`CW-1:0]CMD;
  rand bit CIN,CE,MODE;
  logic[`DW*2-1:0]RES;
  logic RST,ERR,OFLOW,G,E,L,COUT;

 `uvm_object_utils_begin(seq_item)
    `uvm_field_int(OPA, UVM_ALL_ON)
    `uvm_field_int(OPB, UVM_ALL_ON)
    `uvm_field_int(CMD, UVM_ALL_ON)
    `uvm_field_int(MODE, UVM_ALL_ON)
    `uvm_field_int(CE, UVM_ALL_ON)
    `uvm_field_int(CIN, UVM_ALL_ON)
    `uvm_field_int(INP_VALID, UVM_ALL_ON)
  `uvm_object_utils_end
  
  constraint c0{CE dist{1:=90};}
  constraint c3{INP_VALID dist {2'b00 :=5, 2'b01 :=5, 2'b10 :=5, 2'b11 :=500};}
  constraint c4{MODE dist{1'b1:=5,1'b0:=5};}
  constraint c5{if(MODE==1)
		CMD<11;
		else
		CMD<14;}
  constraint c6{CIN dist{1:=5,0:=5};}
  
  function new(string name="seq_item");
    super.new(name);
  endfunction
  
endclass

