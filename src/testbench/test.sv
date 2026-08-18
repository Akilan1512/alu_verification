 class test extends uvm_test;
  `uvm_component_utils(test)
  env env1;
  alu_config m_cfg;
  function new(string name="test", uvm_component parent);
    super.new(name,parent);
  endfunction
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env1=env::type_id::create("env1",this);
    m_cfg=alu_config::type_id::create("m_cfg");
    if(!uvm_config_db#(alu_config)::get(this,"","alu_config",m_cfg)) begin
      `uvm_fatal(get_type_name(),"Could not get the interface") end
    else begin
      `uvm_info(get_type_name(),"Got the interface",UVM_MEDIUM) end
    m_cfg.input_agent_is_active=UVM_ACTIVE;
    m_cfg.output_agent_is_active=UVM_PASSIVE;
       uvm_config_db#(alu_config)::set(this,"*","alu_config",m_cfg);
       endfunction
       function void end_of_elaboration_phase(uvm_phase phase);
         super.end_of_elaboration_phase(phase);
         uvm_top.print_topology();
       endfunction
       endclass
       
    class test1 extends test;
	`uvm_component_utils(test1)

	seq s1;
	seq_1 s2;
	cycle_seq s3;
	err_seq e1;
        err_seq1 e2;
        arithmetic_seq s4;
        logical_seq s5;
        direct_test_case_arth s6;
        direct_test_case_logic s7;
        corner_case_seq s8;
        reset_seq s9;

 function new(string name="test1",uvm_component parent);
	super.new(name,parent);
 endfunction


 function void build_phase(uvm_phase phase);
	super.build_phase(phase);
 endfunction


 task run_phase(uvm_phase phase);

	phase.raise_objection(this);
	s1=seq::type_id::create("s1");
	s2=seq_1::type_id::create("s2");
	s3=cycle_seq::type_id::create("s3");
	e1=err_seq::type_id::create("e1");
        e2=err_seq1::type_id::create("e2");
        s4=arithmetic_seq::type_id::create("s4");
        s5=logical_seq::type_id::create("s5");
        s6=direct_test_case_arth::type_id::create("s6");
        s7=direct_test_case_logic::type_id::create("s7");
        s8=corner_case_seq::type_id::create("s8");
        s9=reset_seq::type_id::create("s9");



	//s1.start(env_h.inp_agt_h.seqr_h);
         fork
      //	begin
        s1.start(env1.inp_agt.seqr);
        #10;
	s2.start(env1.inp_agt.seqr);
        #10;
	s3.start(env1.inp_agt.seqr);
        #10;
	e1.start(env1.inp_agt.seqr);
        #10;
        e2.start(env1.inp_agt.seqr);
        #10;
        s4.start(env1.inp_agt.seqr);
        #10;
        s5.start(env1.inp_agt.seqr);
        #10;
        s6.start(env1.inp_agt.seqr);
        #10;
        s7.start(env1.inp_agt.seqr);
        #10;
        s8.start(env1.inp_agt.seqr);
        #10;
        s9.start(env1.inp_agt.seqr);

      //	end
         join
	#50;
	phase.drop_objection(this);


 endtask

endclass

       
