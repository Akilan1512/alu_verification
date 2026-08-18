class output_monitor extends uvm_monitor;
	`uvm_component_utils(output_monitor)
	uvm_analysis_port#(seq_item) out_monitor_port;

	virtual alu_if.OUT_MON vif;
	alu_config m_cfg;
	seq_item rd_data;

 function new(string name="output_monitor",uvm_component parent);
	super.new(name,parent);
 endfunction

 function void build_phase(uvm_phase phase);
	super.build_phase(phase);
   if(!uvm_config_db#(alu_config)::get(this,"","alu_config",m_cfg))
	`uvm_fatal(get_type_name(),"Output_Monitor Getting Failed")
	//new
	out_monitor_port=new("out_monitor_port",this);
 endfunction

 function void connect_phase(uvm_phase phase);
	super.connect_phase(phase);
 	vif=m_cfg.vif;
 endfunction

 task run_phase(uvm_phase phase);
     forever begin
	@(vif.omon_cb);
	rd_data=seq_item::type_id::create("rd_data");
		
	    	collect_data();
	   	`uvm_info("OUTPUT_MONITOR",$sformatf("OUTPUT MONITOR\n%s",rd_data.sprint()),UVM_NONE)
		end

 endtask

	  
virtual task collect_data();
     begin
          begin
	  rd_data.RES=vif.omon_cb.RES;
	  rd_data.ERR=vif.omon_cb.ERR;
	  rd_data.COUT=vif.omon_cb.COUT;
	  rd_data.OFLOW=vif.omon_cb.OFLOW;
	  rd_data.G = vif.omon_cb.G;
	  rd_data.L = vif.omon_cb.L;
	  rd_data.E = vif.omon_cb.E;

	  rd_data.CE        =   vif.omon_cb.CE; 
	  rd_data.INP_VALID =   vif.omon_cb.INP_VALID;
	  rd_data.OPA        =   vif.omon_cb.OPA;
	  rd_data.OPB        =   vif.omon_cb.OPB;
          rd_data.MODE      =   vif.omon_cb.MODE;
	  rd_data.CMD       =   vif.omon_cb.CMD;
          
	if((rd_data.MODE==1) && ((rd_data.CMD=4'b1001) || (rd_data.CMD=4'b1010)))
	  begin
	    	@(vif.omon_cb);
		rd_data.RES=vif.omon_cb.RES;
	  end

   	end
	out_monitor_port.write(rd_data);
    end

 endtask


 endclass

