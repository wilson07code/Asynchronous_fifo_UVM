`ifndef fifo_seq //Preprocessor commands.
`define fifo_seq 


import uvm_pkg::*;
`include "uvm_macros.svh"
`include "fifo_seq_item.sv"
`include "dut_config.sv"
`include "model_config.sv"


class fifo_seq extends uvm_sequence #(fifo_seq_item); //Sequence class parameterized by the type of seq_item
`uvm_object_utils(fifo_seq) //Register the class using object_utils

fifo_seq_item tr; //Handle to the seq_item
dut_config d_cfg;
model_config m_cfg;


int limit = 50;

function new(string name = "fifo_seq"); //Constructor
  super.new(name);
endfunction   

task body;
  
  tr= fifo_seq_item::type_id::create("tr"); //Create a seq_item

//Propagate the interface.
  if(!uvm_config_db #(dut_config)::get(null,get_full_name(),"config",d_cfg))begin
	`uvm_error("body  dut","Unable to access agent configuration object in sequence") 
  end
if(!uvm_config_db #(model_config)::get(null,get_full_name(),"config",m_cfg))begin
	`uvm_error("body  model","Unable to access agent configuration object in sequence") 
  end

  
  repeat(limit)
   begin
     start_item(tr); //Request next item from the sequencer
     if(!tr.randomize()) begin
       `uvm_error("body", "Randomization of req failed")
  	tr.w_en=1'b1;
      tr.r_en=1'b0;
    end
    finish_item(tr); //seq_item given to driver
  
end
endtask:body
endclass:fifo_seq

`endif
