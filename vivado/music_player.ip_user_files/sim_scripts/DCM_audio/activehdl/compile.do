transcript off
onbreak {quit -force}
onerror {quit -force}
transcript on

vlib work
vmap -link {D:/constructing_projects/FPGA_projects/FPGA_design_course/lab19_MusicPlayer/vivado/music_player.cache/compile_simlib/activehdl}
vlib activehdl/xil_defaultlib

vlog -work xil_defaultlib  -v2k5 "+incdir+../../../ipstatic" -l xil_defaultlib \
"../../../../music_player.gen/sources_1/ip/DCM_audio/DCM_audio_clk_wiz.v" \
"../../../../music_player.gen/sources_1/ip/DCM_audio/DCM_audio.v" \


vlog -work xil_defaultlib \
"glbl.v"

