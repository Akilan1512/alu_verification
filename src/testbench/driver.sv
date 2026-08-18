class input_driver extends uvm_driver#(seq_item);
	`uvm_component_utils(input_driver)

	virtual alu_if.drv vif;
	alu_config m_cfg;
	seq_item data2duv;

 function new(string name="input_driver",uvm_component parent);
	super.new(name,parent);
 endfunction

 function void build_phase(uvm_phase phase);
	super.build_phase(phase);
   if(!uvm_config_db#(alu_config)::get(this,"","alu_config",m_cfg))
	`uvm_fatal(get_type_name(),"Input_Driver Getting Failed")
 endfunction

 function void connect_phase(uvm_phase phase);
	super.connect_phase(phase);
 	vif=m_cfg.vif;
 endfunction

 task run_phase(uvm_phase phase);
	begin	
		
       @(vif.drv_cb);
	 	 vif.drv_cb.RST<=1'b1;
       @(vif.drv_cb);
	     vif.drv_cb.RST<=1'b0;

	forever
		begin
		   seq_item_port.get_next_item(req);
		   drive(req);
		   seq_item_port.item_done();
		end
   	end

 endtask

  task drive(seq_item data2duv);
	begin
		`uvm_info("INPUT_DRIVER",$sformatf("Input Driver\n%s",data2duv.sprint()),UVM_NONE)
      @(vif.drv_cb);

	    vif.drv_cb.CE        <= data2duv.CE;
	    vif.drv_cb.INP_VALID <= data2duv.INP_VALID;
	    vif.drv_cb.OPA        <= data2duv.OPA;
	    vif.drv_cb.OPB        <= data2duv.OPB;
            vif.drv_cb.MODE      <= data2duv.MODE;
	    vif.drv_cb.CMD       <= data2duv.CMD;
	    vif.drv_cb.CIN       <= data2duv.CIN;


	   if((data2duv.MODE==1) && ((data2duv.CMD==4'b0010) || (data2duv.CMD==4'b0011)))
	    begin
	   vif.drv_cb.CIN        <= data2duv.CIN;
	    end

	    end
 endtask
	

endclass

