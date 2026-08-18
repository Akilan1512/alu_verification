`include "defines.sv"
 interface alu_if(input bit clk);
  logic[`DW-1:0]OPA;
  logic[`DW-1:0]OPB;
  logic RST,CE,MODE,CIN,ERR,OFLOW,COUT,G,E,L;
  logic[1:0]INP_VALID;
  logic[`CW-1:0]CMD;
  logic[`DW*2-1:0]RES;
  
  clocking drv_cb@(posedge clk);
    default input#1 output#1;
    output RST,OPA,OPB,CE,MODE,CMD,CIN,INP_VALID;
    input RES,COUT,OFLOW,G,E,L,ERR;
  endclocking
  
  clocking imon_cb@(posedge clk);
    default input#1 output#1;
    input OPA,OPB,CE,MODE,CMD,CIN,INP_VALID;
  endclocking
  
  clocking omon_cb@(posedge clk);
    default input#1 output#1;
    input OPA,OPB,CE,MODE,CMD,CIN,INP_VALID;
    input ERR,OFLOW,COUT,G,E,L,RES;
  endclocking
  
  modport drv(input clk,clocking drv_cb);
    modport imon(input clk,clocking imon_cb);
      modport omon(input clk,clocking omon_cb);
        
        endinterface
        
 
