`timescale 1ns/1ps
module FP_Multiplier_tb ();

    // Input signals
    reg clk;
    reg nreset;
    reg [31:0] A;
    reg [31:0] B;

    // Output signal
    wire [31:0] mul_result;

    FP_Multiplier uut (
        .clk(clk),
        .nreset(nreset),
        .A(A),
        .B(B),
        .mul_result(mul_result)
    );

    // Dump signals for waveform analysis
    // This will create a VCD file for waveform analysis
    initial begin
        $dumpfile("wave.vcd");  // Output VCD file
        $dumpvars(0, FP_Multiplier_tb);       // Dump all signals in the testbench
    end

    // Clock generation for the with an 100 MHz     
    initial begin
        clk = 0;
        forever #5 clk = ~clk;

        if ($time > 2000) begin
            $display("Simulation time exceeded 2000 ns, stopping simulation.");
            $stop;
        end

    end

    task test_case;

        input [31:0] a;
        input [31:0] b;
        input [31:0] expected;

        begin
            A = a;
            B = b;

            $display("Test: %h * %h  = %h (Expected output: %h)", a, b, mul_result, expected);
            $display($time, " ns: A = %h, B = %h, Result = %h", A, B, mul_result);
            if (mul_result != expected) $display("Error: you are dolboeb!");
        end

    endtask

    initial begin

        nreset = 1;
        A = 0;
        B = 0;

        #10 nreset = 0;
        #15;

        $display ("Start the simulation with testing");

        // Test cases
        test_case(32'h3FC00000, 32'h3FC00000, 32'h40100000); // 1.5 * 1.5 = 2.25
        #10;
        test_case(32'h40000000, 32'h3FC00000, 32'h40400000); // 2.0 * 1.5 = 3.0
        #10;
        test_case(32'h40490FD0, 32'h402DF84D, 32'h4108A2B3); // 3.14159 * 2.71828 = 1.0
        #10;
        test_case(32'h3F9E0651, 32'h33D6BF95, 32'h33F142B1); // 1.2345678 * 0.0000001 = 1.0
        #10;
        test_case(32'h425C7E6B, 32'h4207F35C, 32'h44EA308B); // 55.123456 * 33.987654 = 1.0
        #10;
        test_case(32'h414B94E2, 32'h443EF4BC, 32'h4617DB1F); // 12.723848 * 763.824 = 9714
        #40;

        $display ("Simulation is finished");
        $stop;


    end



endmodule