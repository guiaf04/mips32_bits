#!/bin/bash -f
# ****************************************************************************
# Vivado (TM) v2022.2 (64-bit)
#
# Filename    : simulate.sh
# Simulator   : Xilinx Vivado Simulator
# Description : Script for simulating the design by launching the simulator
#
# Generated by Vivado on Fri Sep 27 17:44:00 -03 2024
# SW Build 3671981 on Fri Oct 14 04:59:54 MDT 2022
#
# IP Build 3669848 on Fri Oct 14 08:30:02 MDT 2022
#
# usage: simulate.sh
#
# ****************************************************************************
set -Eeuo pipefail
# simulate design
echo "xsim testbench_behav -key {Behavioral:sim_1:Functional:testbench} -tclbatch testbench.tcl -view /home/guilherme/UFC/SD/ap2/mips/testbench_behav.wcfg -view /home/guilherme/UFC/SD/ap2/mips/ula_tb.wcfg -view /home/guilherme/UFC/SD/ap2/mips/datapath_tb.wcfg -log simulate.log"
xsim testbench_behav -key {Behavioral:sim_1:Functional:testbench} -tclbatch testbench.tcl -view /home/guilherme/UFC/SD/ap2/mips/testbench_behav.wcfg -view /home/guilherme/UFC/SD/ap2/mips/ula_tb.wcfg -view /home/guilherme/UFC/SD/ap2/mips/datapath_tb.wcfg -log simulate.log

