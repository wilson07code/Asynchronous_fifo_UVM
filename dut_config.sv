//Class consists of a handle of the DUT interface

`ifndef dut_config //Pre-Processor commands. 
`define dut_config //They are being used to insure that the given header file doesn't get included more than once, to prevent multiple definition errors.
 

import uvm_pkg::*;
`include "uvm_macros.svh"

class dut_config extends uvm_object;

`uvm_object_utils(dut_config) //Register the class

virtual dut_if dut_vi; //Handle to the virtual interface

function new(string name = "dut_config"); //Constructor
  super.new(name);
endfunction

endclass:dut_config

`endif
