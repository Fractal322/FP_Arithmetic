proc setup_waves {} {
remove_wave [get_waves *];

add_wave /CLA_test/clk -radix bin
add_wave /CLA_test/nreset -radix bin


add_wave /CLA_test/s9_final -radix hex
add_wave /CLA_test/c9_final -radix hex
add_wave /CLA_test/uut/s9_reg -radix hex
add_wave /CLA_test/uut/c9_reg -radix hex

add_wave /CLA_test/uut/mantissa_mul_reg -radix hex
add_wave /CLA_test/uut/mantissa_mul -radix hex


add_wave /CLA_test/uut/p_0 -radix bin
add_wave /CLA_test/uut/p_1 -radix bin
add_wave /CLA_test/uut/p_2 -radix bin
add_wave /CLA_test/uut/p_3 -radix bin
add_wave /CLA_test/uut/g_0 -radix bin
add_wave /CLA_test/uut/g_1 -radix bin
add_wave /CLA_test/uut/g_2 -radix bin
add_wave /CLA_test/uut/g_3 -radix bin



}

if {[current_sim] == ""} {
    puts "No simulation is currently open. Opening customed simulation.";
    launch_simulation;
    setup_waves;
    run 170ns;
    puts "Simulation is finished.";
} else {
    puts "Simulation is already open: {current_sim}";
    puts "Simulation is restarted.";
    close_sim -force;
    launch_simulation;
    puts "Simulation is launched.";
    setup_waves;
    restart;
    run 170ns;
    puts "Simulation is finished.";
}