class seq extends uvm_sequence #(seq_item);
	`uvm_object_utils(seq) 

 function new(string name="seq");
	super.new(name);
 endfunction

 task body();
       req=seq_item::type_id::create("req");
	begin
		   start_item(req);
      assert(req.randomize() with {MODE==1'b1;CMD==4'b0000;OPA=='d3;OPB=='d3;});
		   finish_item(req);
	end
 endtask

 endclass

class seq_1 extends uvm_sequence #(seq_item);
	`uvm_object_utils(seq_1) 

 function new(string name="seq_1");
	super.new(name);
 endfunction

 task body();
       req=seq_item::type_id::create("req");
	begin
		   start_item(req);
      assert(req.randomize() with {MODE==1'b1;CMD==4'b0001;OPA=='d10;OPB=='d5;});
		   finish_item(req);
	end
 endtask

 endclass

class cycle_seq extends uvm_sequence #(seq_item);
    `uvm_object_utils(cycle_seq)
 function new(string name="cycle_seq");
    super.new(name);
 endfunction

 task body();
   req=seq_item::type_id::create("req");
    begin
     start_item(req);
     assert(req.randomize() with {MODE==1'b1;CMD==4'b1001;OPA=='d10;OPB=='d5;});
     finish_item(req);
    end
 endtask
endclass

class err_seq extends uvm_sequence #(seq_item);
	`uvm_object_utils(err_seq) 

 function new(string name="err_seq");
	super.new(name);
 endfunction

 task body();
       req=seq_item::type_id::create("req");
	begin
		   start_item(req);
		   assert(req.randomize() with {MODE==1'b0;CMD==4'b1100;OPA=='d100;OPB=='b10000001;});
		   finish_item(req);
	end
 endtask

 endclass

class err_seq1 extends uvm_sequence #(seq_item);
 `uvm_object_utils(err_seq1) 

 function new(string name="err_seq1");
   super.new(name);
 endfunction

 task body();
  repeat (5)
  begin

   // ROTATE LEFT
    req = seq_item::type_id::create("req");
    start_item(req);
    assert(req.randomize() with {
      MODE==0;
      CMD==4'b1100;
      INP_VALID==2'b11;
      CE==1;
      OPB[7:4]!=4'b0000;   // error case
    });
    finish_item(req);

   // ROTATE RIGHT
    req = seq_item::type_id::create("req");
    start_item(req);
    assert(req.randomize() with {
      MODE==0;
      CMD==4'b1101;
      INP_VALID==2'b11;
      CE==1;
      OPB[7:4]!=4'b0000;   // error case
    });
    finish_item(req);

  end
 endtask

endclass

//=============================================================================================================
//ARITHMETIC OPERATIONS
//=============================================================================================================
class arithmetic_seq extends uvm_sequence #(seq_item);
  `uvm_object_utils(arithmetic_seq)

  function new(string name="arithmetic_seq");
    super.new(name);
  endfunction

  task body();
    repeat(50)
    begin
     for (int i = 0; i <= 10; i++) begin
      req = seq_item::type_id::create($sformatf("req_%0d", i));
      start_item(req);
      assert(req.randomize() with {
        MODE == 1;
        CE   == 1;
        CMD  == i;
      });
      finish_item(req);
     end
    end
  endtask

endclass


//=============================================================================================================
//LOGICAL OPERATION
//=============================================================================================================
class logical_seq extends uvm_sequence #(seq_item);
  `uvm_object_utils(logical_seq)

  function new(string name="logical_seq");
    super.new(name);
  endfunction

  task body();
    repeat(50)
    begin
     for (int i = 0; i <= 13; i++) begin
      req = seq_item::type_id::create($sformatf("req_%0d", i));
      start_item(req);
      assert(req.randomize() with {
        MODE == 0;
        CE   == 1;
        CMD  == i;
      });
      finish_item(req);
     end
    end
  endtask

endclass

//=============================================================================================================
//DIRECT ARITHMETIC
//=============================================================================================================
class direct_test_case_arth extends uvm_sequence #(seq_item);
  `uvm_object_utils(direct_test_case_arth)
   
  function new(string name="direct_test_case_arth");
    super.new(name);
  endfunction

  task body();
   for (int k = 0; k <= 3; k++) begin 
    for (int j = 0; j <= 1; j++) begin
     for (int i = 0; i <= 10; i++) begin

      // 0,0
      req = seq_item::type_id::create($sformatf("req_i%0d_j%0d_k%0d ", i,j,k));
      start_item(req);
      assert(req.randomize() with {
        MODE==1;
        CMD==i;
        OPA=={`DW{1'b0}};
        OPB=={`DW{1'b0}};
        CE==1;
        INP_VALID==k;
        CIN==j;
      });
      finish_item(req);

      // 0,255
      req = seq_item::type_id::create($sformatf("req_i%0d_j%0d_k%0d ", i,j,k));
      start_item(req);
      assert(req.randomize() with {
        MODE==1;
        CMD==i;
        OPA=={`DW{1'b0}};
        OPB=={`DW{1'b1}};
        CE==1;
        INP_VALID==k;
        CIN==j;
      });
      finish_item(req);

      // 255,0
      req = seq_item::type_id::create($sformatf("req_i%0d_j%0d_k%0d ", i,j,k));
      start_item(req);
      assert(req.randomize() with {
        MODE==1;
        CMD==i;
        OPA=={`DW{1'b1}};
        OPB=={`DW{1'b0}};
        CE==1;
        INP_VALID==k;
        CIN==j;
      });
      finish_item(req);

      // 255,255
      req = seq_item::type_id::create($sformatf("req_i%0d_j%0d_k%0d ", i,j,k));
      start_item(req);
      assert(req.randomize() with {
        MODE==1;
        CMD==i;
        OPA=={`DW{1'b1}};
        OPB=={`DW{1'b1}};
        CE==1;
        INP_VALID==k;
        CIN==j;
      });
      finish_item(req);

     end
    end
   end
  endtask

endclass

//=============================================================================================================
//DIRECT LOGICAL
//=============================================================================================================
class direct_test_case_logic extends uvm_sequence #(seq_item);
  `uvm_object_utils(direct_test_case_logic)
   
  function new(string name="direct_test_case_logic");
    super.new(name);
  endfunction

  task body();
  for (int k = 0; k <= 3; k++) begin
   for (int j = 0; j <= 1; j++) begin
    for (int i = 0; i <= 10; i++) begin
      // 0,0
      req = seq_item::type_id::create($sformatf("req_i%0d_j%0d_k%0d ", i,j,k));
      start_item(req);
      assert(req.randomize() with {
        MODE==1;
        CMD==i;
        OPA=={`DW{1'b0}};
        OPB=={`DW{1'b0}};
        CE==1;
        INP_VALID==k;
        CIN==j;
      });
      finish_item(req);

      // 0,255
      req = seq_item::type_id::create($sformatf("req_i%0d_j%0d_k%0d ", i,j,k));
      start_item(req);
      assert(req.randomize() with {
        MODE==1;
        CMD==i;
        OPA=={`DW{1'b0}};
        OPB=={`DW{1'b1}};
        CE==1;
        INP_VALID==k;
        CIN==j;
      });
      finish_item(req);

      // 255,0
      req = seq_item::type_id::create($sformatf("req_i%0d_j%0d_k%0d ", i,j,k));
      start_item(req);
      assert(req.randomize() with {
        MODE==1;
        CMD==i;
        OPA=={`DW{1'b1}};
        OPB=={`DW{1'b0}};
        CE==1;
        INP_VALID==k;
        CIN==j;
      });
      finish_item(req);

      // 255,255
      req = seq_item::type_id::create($sformatf("req_i%0d_j%0d_k%0d ", i,j,k));
      start_item(req);
      assert(req.randomize() with {
        MODE==1;
        CMD==i;
        OPA=={`DW{1'b1}};
        OPB=={`DW{1'b1}};
        CE==1;
        INP_VALID==k;
        CIN==j;
      });
      finish_item(req);

     end
    end
   end
  endtask

endclass



//=============================================================================================================
//CORNER CASES
//=============================================================================================================
class corner_case_seq extends uvm_sequence #(seq_item);
  `uvm_object_utils(corner_case_seq)

  function new(string name="corner_case_seq");
    super.new(name);
  endfunction

  task body();

    //====================================================
    // CE = 0
    //====================================================
    repeat(50)
    begin
    req = seq_item::type_id::create("req");
    start_item(req);
    assert(req.randomize() with {
      CE == 0;
    });
    finish_item(req);
    end
    
    for (int l = 0; l <= 7; l++) begin
    //====================================================
    // Rotate Left Error
    //====================================================
    req = seq_item::type_id::create("req");
    start_item(req);
    assert(req.randomize() with {
      MODE      == 0;
      CMD       == 4'b1100;
      OPA        == 8'b1000_0001;
      OPB        == l;
      INP_VALID == 2'b11;
      CE        == 1;
    });
    finish_item(req);
    
    req = seq_item::type_id::create("req");
    start_item(req);
    assert(req.randomize() with {
      MODE      == 0;
      CMD       == 4'b1100;
      OPA        == 8'b1000_0000;
      OPB        == l;
      INP_VALID == 2'b11;
      CE        == 1;
    });
    finish_item(req);

    req = seq_item::type_id::create("req");
    start_item(req);
    assert(req.randomize() with {
      MODE      == 0;
      CMD       == 4'b1100;
      OPA        == 8'b0000_0001;
      OPB        == l;
      INP_VALID == 2'b11;
      CE        == 1;
    });
    finish_item(req);
    
    req = seq_item::type_id::create("req");
    start_item(req);
    assert(req.randomize() with {
      MODE      == 0;
      CMD       == 4'b1100;
      OPA        == 8'b0111_1110;
      OPB        == l;
      INP_VALID == 2'b11;
      CE        == 1;
    });
    finish_item(req);

    //====================================================
    // Rotate Right Error
    //====================================================
    req = seq_item::type_id::create("req");
    start_item(req);
    assert(req.randomize() with {
      MODE      == 0;
      CMD       == 4'b1101;
      OPA        == 8'b1000_0001;
      OPB        == l;
      INP_VALID == 2'b11;
      CE        == 1;
    });
    finish_item(req);
   
    req = seq_item::type_id::create("req");
    start_item(req);
    assert(req.randomize() with {
      MODE      == 0;
      CMD       == 4'b1101;
      OPA        == 8'b1000_0000;
      OPB        == l;
      INP_VALID == 2'b11;
      CE        == 1;
    });
    finish_item(req);
   
    req = seq_item::type_id::create("req");
    start_item(req);
    assert(req.randomize() with {
      MODE      == 0;
      CMD       == 4'b1101;
      OPA        == 8'b0000_0001;
      OPB        == l;
      INP_VALID == 2'b11;
      CE        == 1;
    });
    finish_item(req);
   
    req = seq_item::type_id::create("req");
    start_item(req);
    assert(req.randomize() with {
      MODE      == 0;
      CMD       == 4'b1101;
      OPA        == 8'b0111_1110;
      OPB        == l;
      INP_VALID == 2'b11;
      CE        == 1;
    });
    finish_item(req);
   end
  endtask

endclass

//=============================================================================================================
//RESET CASES
//=============================================================================================================
class reset_seq extends uvm_sequence #(seq_item);
  `uvm_object_utils(reset_seq)

  function new(string name="reset_seq");
    super.new(name);
  endfunction

  task body();
   
    repeat (5)begin

    req = seq_item::type_id::create("req");

    start_item(req);

    assert(req.randomize() with {
      CE == 1;
    });

    req.RST = 1'b1;

    finish_item(req);
    
    end
    // Hold reset for a few clock cycles if required
    
    req = seq_item::type_id::create("req");

    start_item(req);

    assert(req.randomize() with {
      CE == 1;
    });

    req.RST = 1'b0;

    finish_item(req);
    

  endtask
endclass

