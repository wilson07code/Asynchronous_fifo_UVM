`ifndef fifo_test //Preprocessor commands
`define fifo_test 
 

import uvm_pkg::*; //Import the UVM BCL
`include "uvm_macros.svh" //Include the macros

`include "fifo_env.sv"
`include "dut_config.sv"
`include "model_config.sv"

`include "fifo_seq.sv"

class fifo_test extends uvm_test; 
`uvm_component_utils(fifo_test) //Register the class

dut_config d_cfg; //Handle of the DUT configuration class.
model_config m_cfg; //Handle of the MODEL configuration class.
fifo_env env; //Handle to the environment which is the child component of test.

function new(string name = "fifo_test", uvm_component parent = null); //Constructor
  super.new(name, parent);
endfunction

function void build_phase(uvm_phase phase);
   //Propagate the fifo interface.
    d_cfg = dut_config::type_id::create("d_cfg");
    uvm_config_db #(dut_config)::set(this, "*", "config", d_cfg); //Setting interface
        
   //Propagate the model interface
    m_cfg = model_config::type_id::create("m_cfg");
    uvm_config_db #(model_config)::set(this, "*", "config", m_cfg); //Setting interface

    env = fifo_env::type_id::create("env", this); //Create MODEL agent
    
endfunction: build_phase

task run_phase(uvm_phase phase);
  fifo_seq seq = fifo_seq::type_id::create("seq"); //Create a sequence

      seq.start(env.d_agent.a_sequencer); //Call the sequence through the sequencer. Indicate the path to the sequencer.
      seq.start(env.m_agent.a_sequencer); 
endtask: run_phase

endclass:fifo_test

`endif


