`ifndef shared_sequencer //Preprocessor commands
`define shared_sequencer 


import uvm_pkg::*;
`include "uvm_macros.svh"
`include "fifo_seq_item.sv"

//Sequencer class parameterized by the type of transaction.The sequencer is shared between the MODEL & DUT

class shared_sequencer extends uvm_sequencer#(fifo_seq_item); 
`uvm_component_utils(shared_sequencer) //Register the class

function new(string name = "shared_sequencer", uvm_component parent = null); //Constructor
  super.new(name,parent);
endfunction

endclass:shared_sequencer

`endif
