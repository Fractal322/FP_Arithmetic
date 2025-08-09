# Simulation running commands

# Wave configuration for FP_Multiplier_tb
proc setup_waves {} {

    remove_wave [get_waves *];

    add_wave /FP_Multiplier_tb/clk -radix bin
    add_wave /FP_Multiplier_tb/nreset -radix bin
    add_wave /FP_Multiplier_tb/A -radix bin
    add_wave /FP_Multiplier_tb/B -radix bin
    add_wave /FP_Multiplier_tb/mul_result -radix bin

    add_wave /FP_Multiplier_tb/uut/A_reg -radix bin
    add_wave /FP_Multiplier_tb/uut/B_reg -radix bin

    add_wave /FP_Multiplier_tb/uut/A_sign -radix bin
    add_wave /FP_Multiplier_tb/uut/B_sign -radix bin
    add_wave /FP_Multiplier_tb/uut/A_exponent -radix bin
    add_wave /FP_Multiplier_tb/uut/B_exponent -radix bin
    add_wave /FP_Multiplier_tb/uut/A_mantissa -radix bin
    add_wave /FP_Multiplier_tb/uut/B_mantissa -radix bin
    add_wave /FP_Multiplier_tb/uut/result_sign -radix bin
    add_wave /FP_Multiplier_tb/uut/result_exponent -radix bin
    add_wave /FP_Multiplier_tb/uut/result_mantissa -radix bin

    add_wave /FP_Multiplier_tb/A -radix hex
    add_wave /FP_Multiplier_tb/B -radix hex
    add_wave /FP_Multiplier_tb/mul_result -radix hex
    add_wave /FP_Multiplier_tb/uut/mantissa_mul -radix bin
}

# Open and reset simulation
if {[current_sim] == ""}  {
    puts "No simulation is currently open. Opening customed simulation.";
    launch_simulation;
    setup_waves;
    run 10us;
} else {
    puts "Simulation is already open: {current_sim}";
    setup_waves;
    restart;
    run 10us;
}

group_byname -group {Inputs} /FP_Multiplier_tb/A /FP_Multiplier_tb/B
group_byname -group {Control} /FP_Multiplier_tb/clk /FP_Multiplier_tb/nreset
