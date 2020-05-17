//Class consists of a handle of the model interface

`ifndef model_config //Pre-Processor commands. 
`define model_config //They are being used to insure that the given header file doesn't get included more than once, to prevent multiple definition errors.
 

import uvm_pkg::*;
`include "uvm_macros.svh"

class model_config extends uvm_object;

`uvm_object_utils(model_config) //Register the class

virtual model_if model_vi; //Handle to the virtual interface

function new(string name = "model_config"); //Constructor
  super.new(name);
endfunction

endclass:model_config

`endif
