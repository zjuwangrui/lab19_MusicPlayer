vlib questa_lib/work
vlib questa_lib/msim

vlib questa_lib/msim/xil_defaultlib

vmap xil_defaultlib questa_lib/msim/xil_defaultlib

vlog -work xil_defaultlib  -incr -mfcu  "+incdir+../../../ipstatic" \
"../../../../music_player.gen/sources_1/ip/DCM_audio/DCM_audio_clk_wiz.v" \
"../../../../music_player.gen/sources_1/ip/DCM_audio/DCM_audio.v" \


vlog -work xil_defaultlib \
"glbl.v"

