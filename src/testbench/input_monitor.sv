class input_monitor extends uvm_monitor;
	`uvm_component_utils(input_monitor)
	
	uvm_analysis_port#(seq_item) inp_monitor_port;

	virtual alu_if.INP_MON vif;
	alu_config m_cfg;
	seq_item drv2mon;
	//analysis_port

 function new(string name="input_monitor",uvm_component parent);
	super.new(name,parent);
 endfunction

 function void build_phase(uvm_phase phase);
	super.build_phase(phase);
   if(!uvm_config_db#(alu_config)::get(this,"","alu_config",m_cfg))
	`uvm_fatal(get_type_name(),"Input_Monitor Getting Failed")
	inp_monitor_port=new("inp_monitor_port",this);
	//new
 endfunction

 function void connect_phase(uvm_phase phase);
	super.connect_phase(phase);
 	vif=m_cfg.vif;
 endfunction

 task run_phase(uvm_phase phase);
       forever begin
        	@(vif.imon_cb);
   
	drv2mon=seq_item::type_id::create("drv2mon");
	
	    collect_input_monitor();
		`uvm_info("INPUT_MONITOR",$sformatf("Input MONITOR\n%s",drv2mon.sprint()),UVM_NONE)
	end
		    
 endtask

 virtual task collect_input_monitor();
	begin

	    drv2mon.CE        =   vif.imon_cb.CE; 
	    drv2mon.INP_VALID =   vif.imon_cb.INP_VALID;
	    drv2mon.OPA        =   vif.imon_cb.OPA;
	    drv2mon.OPB        =   vif.imon_cb.OPB;
            drv2mon.MODE      =   vif.imon_cb.MODE;
	    drv2mon.CMD       =   vif.imon_cb.CMD;
       	    

	   if((drv2mon.MODE==1) && ((drv2mon.CMD==4'b0010) || (drv2mon.CMD==4'b0011)))
	    begin
		drv2mon.CIN       =   vif.imon_cb.CIN;
	     end
		inp_monitor_port.write(drv2mon);
	    end
 endtask

endclass

