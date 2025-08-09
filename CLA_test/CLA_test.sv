`timescale 1ns/1ps
module CLA_test ();

reg clk;
reg nreset;
reg [47:0] s9_final;
reg [47:0] c9_final;
wire [47:0] mantissa_mul;
wire carry_out;

CLA_module uut (
    .clk(clk),
    .nreset(nreset),
    .s9_final(s9_final),
    .c9_final(c9_final),
    .mantissa_mul(mantissa_mul),
    .carry_out(carry_out)
);

// Timing control for simulation
initial begin
    clk = 0;
    forever #5 clk = ~clk; // Clock generation with a period of 10 ns

    if ($time > 2000) begin
        $display("Simulation time exceeded 2000 ns, stopping simulation.");
        $stop;
    end
end

task g_array;
input [47:0] s9;
input [47:0] c9;
begin
    logic [47:0] g_array;
    logic [47:0] g_array_module;
    integer i;
    i = 0;
    g_array_module = 0;
    g_array = s9 & c9;

    
    for (i = 12; i > 0; i = i - 1) 
    begin
        g_array_module[((i * 4) - 1) -: 4] = {uut.g_3[i - 1], uut.g_2[i - 1], uut.g_1[i - 1], uut.g_0[i - 1]};
    end

    if (g_array !== g_array_module) begin
        $display("At the %0t, Error: g_array does not match expected value! Expected: %h, Got: %h", $time, g_array, g_array_module);
    end else begin
        $display("At the %0t, g_array matches expected value.", $time);
    end
end
endtask

task p_array;
input [47:0] s9;    
input [47:0] c9;
begin
    logic [47:0] p_array;
    logic [47:0] p_array_module;
    integer i;
    i = 0;
    p_array = s9 ^ c9;
    p_array_module = 0;
    

    for (i = 12; i > 0; i = i - 1) 
    begin
        p_array_module[((i * 4) - 1) -: 4] = {uut.p_3[i - 1], uut.p_2[i - 1], uut.p_1[i - 1], uut.p_0[i - 1]};
    end

    if (p_array !== p_array_module) begin
        $display("At time %0t, Error: p_array does not match expected value! Expected: %h, Got: %h", $time, p_array, p_array_module);
    end else begin
        $display("At time %0t, p_array matches expected value.", $time);
    end
end
endtask

task test_case;
input [47:0] s9;
input [47:0] c9;
input [47:0] expected_mantissa_mul;
input integer test_case_num;
begin
    s9_final = s9;
    c9_final = c9;

    $display("Test case %d!, \n", test_case_num);

    #5;

    $display("At the time %0t, Testing with s9_final = %h, c9_final = %h", $time, s9_final, c9_final);
    g_array(s9, c9);
    p_array(s9, c9);
    // Check the result of the carry_out calculation

    #15;

    if (mantissa_mul !== (s9_final + c9_final)) begin
        $display("At the time %0t, Error: mantissa_mul does not match expected value! Expected: %h, Got: %h\n", $time, (s9_final + c9_final), mantissa_mul);
    end else begin
        $display("At the time %0t, mantissa_mul matches expected value.\n", $time);
    end
end
endtask

initial begin
    nreset = 0;
    s9_final = 0;
    c9_final = 0;
    #10
    // Wait for reset to be released
    nreset = 1;
    #15
    // Pair 1
    test_case(48'h123456789ABC, 48'hFEDCBA987654, 48'h111111111210, 1);
    #10;

    // Pair 2
    test_case(48'h0F0F0F0F0F0F, 48'hF0F0F0F0F0F0, 48'hFFFFFFFFFFFF, 2);
    #10;

    // Pair 3
    test_case(48'hAAAAAAAAAAAA, 48'h555555555555, 48'hFFFFFFFFFFFF, 3);
    #10;

    // Pair 4
    test_case(48'h0000FFFFFFFF, 48'hFFFF00000000, 48'hFFFFFFFFFFFF, 4);
    #10;

    // Pair 5
    test_case(48'hDEADBEEFCAFE, 48'h0123456789AB, 48'hDFCE13575349, 5);
    #10;
    // Add more test cases as needed

end
endmodule