class env extends uvm_env;
  `uvm_component_utils(env)
  input_agent inp_agt;
  output_agent out_agt;
  scoreboard sb;
  alu_config m_cfg;
  function new(string name="env",uvm_component parent);
	super.new(name,parent);
   endfunction

 function void build_phase(uvm_phase phase);
	super.build_phase(phase);

 if(!uvm_config_db#(alu_config)::get(this,"","alu_config",m_cfg))
	`uvm_fatal(get_type_name(),"Output_agt Getting Failed")

  inp_agt=input_agent::type_id::create("inp_agt",this);
  out_agt=output_agent::type_id::create("out_agt",this);
  sb=scoreboard::type_id::create("sb",this);
 endfunction

 function void connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	inp_agt.mon.inp_monitor_port.connect(sb.inp_mon_fifo.analysis_export);
	out_agt.mon.out_monitor_port.connect(sb.out_mon_fifo.analysis_export);
 endfunction

endclass

