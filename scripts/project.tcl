# script to automatically create a project and build it
#

# expecting to be run from build_bit.tcl which is called from the implementation dir

proc print_help {} {
  variable script_file
  puts "\nDescription:"
  puts "Automated generation of project or project and bitstream
  puts "Syntax:"
  puts "$script_file"
  puts "$script_file -tclargs \[--generate_bit\]"
  puts "$script_file -tclargs \[--help\]\n"
  puts "Usage:"
  puts "Name                   Description"
  puts "-------------------------------------------------------------------------"
  puts "\[--generate_bit\]       Generate the bit stream in addition to creating the project.\n"
  puts "\[--help\]               Print help information for this script"
  puts "-------------------------------------------------------------------------\n"
  exit 0
}

# this code allow you to add some command line options after -tclargs
set generate_bit 0
if { $::argc > 0 } {
for {set i 0} {$i < $::argc} {incr i} {
    set option [string trim [lindex $::argv $i]]
    switch -regexp -- $option {
      "--generate_bit" { set generate_bit 1 }
      "--help"         { print_help }
      default {
        if { [regexp {^-} $option] } {
          puts "ERROR: Unknown option '$option' specified, please type '$script_file -tclargs --help' for usage info.\n"
          return 1
        }
      }
    }
  }
}

set_param board.repoPaths ../boards
create_project zynq_gpio_leds zynq_gpio_leds -part xc7z020clg400-1
set_property board_part digilentinc.com:arty-z7-20:part0:1.1 [current_project]
import_files -norecurse ../source/verilog/zynq_gpio_leds_wrapper.v
update_compile_order -fileset sources_1
add_files -fileset constrs_1 -norecurse ../source/constraints/Arty-Z7-20-Master.xdc
import_files -fileset constrs_1 ../source/constraints/Arty-Z7-20-Master.xdc
create_bd_design "zynq_gpio_leds"
update_compile_order -fileset sources_1
create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 processing_system7_0
create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_0
update_compile_order -fileset sources_1
apply_bd_automation -rule xilinx.com:bd_rule:board -config { Manual_Source {Auto}}  [get_bd_pins proc_sys_reset_0/ext_reset_in]
apply_bd_automation -rule xilinx.com:bd_rule:clkrst -config { Clk {/processing_system7_0/FCLK_CLK0 (50 MHz)} Freq {100} Ref_Clk0 {} Ref_Clk1 {} Ref_Clk2 {}}  [get_bd_pins proc_sys_reset_0/slowest_sync_clk]
apply_bd_automation -rule xilinx.com:bd_rule:processing_system7 -config {make_external "FIXED_IO, DDR" apply_board_preset "1" Master "Disable" Slave "Disable" }  [get_bd_cells processing_system7_0]
connect_bd_net [get_bd_pins processing_system7_0/M_AXI_GP0_ACLK] [get_bd_pins processing_system7_0/FCLK_CLK0]
set_property -dict [list \
  CONFIG.PCW_GPIO_EMIO_GPIO_ENABLE {1} \
  CONFIG.PCW_GPIO_EMIO_GPIO_IO {4} \
  CONFIG.PCW_QSPI_GRP_SINGLE_SS_ENABLE {1} \
] [get_bd_cells processing_system7_0]
make_bd_pins_external  [get_bd_pins processing_system7_0/GPIO_O]
save_bd_design
set_property name led [get_bd_ports GPIO_O_0]
# default is to just generate the project but if you add -tclargs --generate_bit
# the lanch the implementation step al the way to bitstream generation
if {$generate_bit==1} {
  launch_runs impl_1 -to_step write_bitstream -jobs 4
  wait_on_run impl_1
  exit
}
