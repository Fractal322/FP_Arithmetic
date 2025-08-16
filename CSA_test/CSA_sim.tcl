proc setup_waves {} {
    remove_wave [get_waves *];
    add_wave /CSA_test/clk -radix bin
    add_wave /CSA_test/nreset -radix bin
    add_wave /CSA_test/product -radix hex
    add_wave /CSA_test/uut/Acc -radix hex
    add_wave /CSA_test/s9_final -radix hex
    add_wave /CSA_test/c9_final -radix hex

    add_wave /CSA_test/uut/s9 -radix hex
    add_wave /CSA_test/uut/c9 -radix hex
    add_wave /CSA_test/uut/s8 -radix hex
    add_wave /CSA_test/uut/c8 -radix hex
    add_wave /CSA_test/uut/s7 -radix hex
    add_wave /CSA_test/uut/c7 -radix hex
    add_wave /CSA_test/uut/s6 -radix hex
    add_wave /CSA_test/uut/c6 -radix hex
    add_wave /CSA_test/uut/s5 -radix hex
    add_wave /CSA_test/uut/c5 -radix hex
    add_wave /CSA_test/uut/s4 -radix hex
    add_wave /CSA_test/uut/c4 -radix hex
    add_wave /CSA_test/uut/s3 -radix hex
    add_wave /CSA_test/uut/c3 -radix hex
    add_wave /CSA_test/uut/s2 -radix hex
    add_wave /CSA_test/uut/c2 -radix hex
    add_wave /CSA_test/uut/s1 -radix hex
    add_wave /CSA_test/uut/c1 -radix hex
    add_wave /CSA_test/uut/s0 -radix hex
    add_wave /CSA_test/uut/c0 -radix hex

    add_wave /CSA_test/original_sum -radix hex
}

# Open and reset simulation
if {[current_sim] == ""} {
    puts "No simulation is currently open. Opening customed simulation.";
    launch_simulation;
    setup_waves;
    run 500ns;
    puts "Simulation is finished.";
} else {
    puts "Simulation is already open: {current_sim}";
    close_sim -force;
    puts "Simulation is restarted.";
    launch_simulation;
    setup_waves;
    restart;
    run 500ns;
    puts "Simulation is finished.";
}