# Copyright (C) 2023  AGH University of Science and Technology
# MTM UEC2
# Author: Piotr Kaczmarczyk
#
# Description:
# Project detiles required for generate_bitstream.tcl
# Make sure that project_name, top_module and target are correct.
# Provide paths to all the files required for synthesis and implementation.
# Depending on the file type, it should be added in the corresponding section.
# If the project does not use files of some type, leave the corresponding section commented out.

#-----------------------------------------------------#
#                   Project details                   #
#-----------------------------------------------------#
# Project name                                  -- EDIT
set project_name UEC2

# Top module name                               -- EDIT
set top_module top_basys3

# FPGA device
set target xc7a35tcpg236-1

#-----------------------------------------------------#
#                    Design sources                   #
#-----------------------------------------------------#
# Specify .xdc files location                   -- EDIT
set xdc_files {
    constraints/top_basys3.xdc
    constraints/clk_wiz_0_late.xdc
    constraints/clk_wiz_0.xdc
}

# Specify SystemVerilog design files location   -- EDIT
set sv_files {
    rtl/top_basys3.sv
    ../rtl/micro/commands_pkg.sv
    ../rtl/micro/decode.sv
    ../rtl/micro/microDebug.sv
    ../rtl/top.sv
}

# Specify Verilog design files location         -- EDIT
set verilog_files {
    ../rtl/7seg/disp_hex_mux.v
    ../rtl/utils/debounce.v
    ../rtl/micro/adder.v
    ../rtl/micro/alu.v
    ../rtl/micro/branch_ctl.v
    ../rtl/micro/control_unit.v
    ../rtl/micro/flopenr.v
    ../rtl/micro/flopr.v
    ../rtl/micro/imem.v
    ../rtl/micro/micro.v
    ../rtl/micro/mux2.v
    ../rtl/micro/regfile.v
    rtl/clk_wiz_0_clk_wiz.v
}

# Specify VHDL design files location            -- EDIT
 #set vhdl_files {
 #}

# Specify files for a memory initialization     -- EDIT
# set mem_files {
#    path/to/file.data
# }
