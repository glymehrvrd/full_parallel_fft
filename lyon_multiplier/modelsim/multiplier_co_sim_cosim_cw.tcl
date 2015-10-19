proc openClient {} {
  set find_spare 0
  set port 1302
  set cid [socket localhost $port]
  echo Connected to Xilinx System Generator Block {ModelSim}
  fileevent $cid readable "event_handler $cid"
  fconfigure $cid -buffering line
  return $cid
}

proc openWave {} {
  global vsim_version
  destroy .wave
  onerror {resume}
  quietly WaveActivateNextPane {} 0
  add wave -noupdate -height 30 -divider {  Block : "Black Box"  }
  add wave -label "  rst" sim:/multiplier_co_sim_cosim_cw/black_box_rst
  add wave -label "  ctrl" sim:/multiplier_co_sim_cosim_cw/black_box_ctrl
  add wave -label "  d1_in" sim:/multiplier_co_sim_cosim_cw/black_box_d1_in
  add wave -noupdate -height 11 -divider { }
  add wave -label "  product_out" sim:/multiplier_co_sim_cosim_cw/black_box_product_out
  add wave -noupdate -height 50 -divider {Clock Signals}
  add wave -label "  ce_1" sim:/multiplier_co_sim_cosim_cw/hdlcosim_clk_driver/ce_1
  add wave -label "  clk" sim:/multiplier_co_sim_cosim_cw/hdlcosim_clk_driver/clk
  TreeUpdate [SetDefaultTree]
  WaveRestoreCursors {3.000000000000 sec}
  WaveRestoreZoom {0 sec} {10.000000000000 sec}
  configure wave -justifyvalue right
  if [expr $vsim_version>2002.11] then {view wave -title {System Generator Co-Simulation   (from block "ModelSim")} -x {76} -width {1382}} else {view wave -x {76} -width {1382}}
}

proc event_handler {cid} {
  set request ""
  if {[eof $cid]} {
      # If the socket is closed for any reason, the
      # handler will get called with eof.
    echo System Generator has closed its connection.
    close $cid
  } else {
    gets $cid message
    scan $message "%s" request
    switch -- $request {
      f {
        scan $message "%s %s %s %s" request black_box_rst black_box_ctrl black_box_d1_in 
        onerror { puts $cid 9 ; flush $cid}
        force black_box_rst $black_box_rst
        force black_box_ctrl $black_box_ctrl
        force black_box_d1_in $black_box_d1_in
        if [llength [find signal black_box_rst]] {puts $cid 2} else {puts $cid 9}
        flush $cid
      }
      r {
        scan $message "%s %s" request delta_t
        onerror { puts $cid 9 ; flush $cid }
        run $delta_t sec
        if [llength [find signal black_box_rst]] {puts $cid 3} else {puts $cid 9}
        flush $cid
      }
      e {
        set valMsg [examine black_box_product_out]
        puts $cid $valMsg
        flush $cid
      }
      quit {
        quit -sim
        echo simstats:
        simstats
      }
      die {
        close $cid
        quit -f
      }
      detach {
        echo simstats:
        simstats
        close $cid
      }
      offerExit {
        _add_menu main controls right SystemMenu SystemWindowFrame {Exit this Sysgen Co-Simulation Engine} {quit -force}
      }
    }
  }
}

set cid [openClient]

global xlcosim_stat
global xlcosim_is_mxe
global vsim_version
set xlcosim_stat 0
set xlcosim_is_mxe 1

if ([info exists vsim_version]==0) {
  set xlcosim_is_mxe 1
  set vsim_version 2003.3
}
puts $cid $xlcosim_is_mxe
flush $cid
set UserTimeUnit sec
.main clear

onerror { global xlcosim_stat ; set xlcosim_stat 9 ; resume }
vlib work
if {$xlcosim_stat==0} { 
  onerror { global xlcosim_stat ; set xlcosim_stat 9; resume }
  vcom -93 multiplier_co_sim_cosim.vhd
  update
  puts $cid 3
  flush $cid
}

if {$xlcosim_stat==0} { 
  onerror { global xlcosim_stat ; set xlcosim_stat 9;  resume }
  if {$xlcosim_is_mxe==1} { 
    vcom -93 multiplier_co_sim_cosim_cw.vhd
  } else {
    vcom -93 multiplier_co_sim_cosim_cwf.vhd
  }
}
if {$xlcosim_stat==0} {
  onerror { global xlcosim_stat ; set xlcosim_stat 9; resume }
  onElabError { global xlcosim_stat ; set xlcosim_stat 9; resume }
  vsim -t ps work.multiplier_co_sim_cosim_cw -title {System Generator Co-Simulation   (from block "ModelSim")}
  update
  if {$xlcosim_stat==0} {
    onerror { global xlcosim_stat ; set xlcosim_stat 9; resume }
    if [llength [find signal black_box_rst]] {} else {global xlcosim_stat ; set xlcosim_stat 9  }
}
  if {$xlcosim_stat==0} {
    openWave
  }
  if {$xlcosim_stat==0} {
    do {d:/dell/Documents/ISE Projects/fft/lyon_multiplier/before.do}
  }
}

puts $cid $xlcosim_stat
flush $cid
if {$xlcosim_stat!=0} {
  close $cid
}

if {($xlcosim_stat==0)&&($xlcosim_is_mxe==0)} {
  run -all
}
