`timescale 1ns / 1ps
module CSA_test();

reg clk;
reg nreset;
reg [47:0] product [0:11];

wire [47:0] s9_final;
wire [47:0] c9_final;
wire carry_out;

logic [47:0] original_sum;

CSA_module uut (
    .clk(clk),
    .nreset(nreset),
    .product(product),
    .s9_final(s9_final),
    .c9_final(c9_final),
    .carry_out(carry_out)
);

initial begin
    clk = 0;
    forever #5 clk = ~clk; // Clock generation with a period of 10 ns

    if ($time > 2000) begin
        $display("Simulation time exceeded 2000 ns, stopping simulation.");
        $stop;
    end
end

task test_case;
input [47:0] acc [0:11];
input [47:0] s9_final;
input [47:0] c9_final;
input [48:0] s0;
input [48:0] s1;
input [48:0] s2;
input [49:0] s3;
input [48:0] c0;
input [48:0] c1;
input [48:0] c2;
input [49:0] c3;
input [49:0] s4;
input [49:0] c4;
input [49:0] s5;
input [49:0] c5;
input [50:0] s6;
input [50:0] c6;
input [50:0] s7;
input [51:0] c7;
input [51:0] s8;
input [51:0] c8;
input [52:0] s9;
input [52:0] c9;
input integer test_num;
begin
    logic [47:0] expected_sum;
    logic [47:0] sum; // Final sum output
    logic [63:0] original_sum;
    logic [63:0] obtained_original_sum;

    sum = s9_final + c9_final;


    original_sum = 0;
    for (int i = 0; i < 12; i++) begin
        original_sum += acc[i];
    end
    obtained_original_sum = s9 + c9;

    expected_sum = obtained_original_sum[47:0]; // Truncate to 48 bits

    $display("Test Case %0d\n", test_num);

    $display("Vector hex values for test case %0d:", test_num);
    $display("0x%h, 0x%h, 0x%h, 0x%h, 0x%h, 0x%h,", acc[0], acc[1], acc[2], acc[3], acc[4], acc[5]);
    $display("0x%h, 0x%h, 0x%h, 0x%h, 0x%h, 0x%h.\n", acc[6], acc[7], acc[8], acc[9], acc[10], acc[11]);

    $display("Vector decimal values for test case %0d:", test_num);
    $display("%d, %d, %d, %d, %d, %d,", acc[0], acc[1], acc[2], acc[3], acc[4], acc[5]);
    $display("%d, %d, %d, %d, %d, %d.\n", acc[6], acc[7], acc[8], acc[9], acc[10], acc[11]);

    $display("Obtained hex s9: 0x%h, hex c9: 0x%h", s9, c9);
    $display("Obtained decimal s9: 0x%d, decimal c9: 0x%d", s9, c9);
    $display("Expected originl sum in hex: 0x%h, Expected originl sum in decimal: %d", original_sum, original_sum);
    $display("Obtained originl sum in hex: 0x%h, Obtained originl sum in decimal: %d", obtained_original_sum, obtained_original_sum);

    $display("Obtained s9_final: 0x%h, c9_final: 0x%h", s9_final, c9_final);
    $display("Expected sum: 0x%h, Obtained sum: 0x%h\n", expected_sum, sum);

    $display("Binary acc inputs:");
    for (int i = 0; i < 12; i ++) begin
            $display("Acc number %d: %b", i, acc[i]);
    end

    $display("s0: %b", s0);
    $display("c0: %b", c0);
    $display("s1: %b", s1);
    $display("c1: %b", c1);
    $display("s2: %b", s2);
    $display("c2: %b", c2);
    $display("s3: %b", s3);
    $display("c3: %b\n", c3);

    $display("s4: %b", s4);
    $display("c4: %b", c4);
    $display("s5: %b", s5);
    $display("c5: %b\n", c5);

    $display("s6: %b", s6);
    $display("c6: %b", c6);
    $display("s7: %b", s7);
    $display("c7: %b\n", c7);

    $display("s8: %b", s8);
    $display("c8: %b\n", c8);

    $display("s9: %b", s9);
    $display("c9: %b\n", c9);


    if (sum !== expected_sum) begin
        $display("At time %0t, Error: Sum mismatch! Expected: %h, Got: %h\n", $time, expected_sum, sum);
    end else begin
        $display("At time %0t, Sum matches expected value.\n", $time);
    end

end
endtask

initial begin

    for (int i = 0; i < 12; i++) begin
        product[i] = '0; // Initialize products with random values
    end

    nreset = 0;
    #10 nreset = 1; // Release reset after 10 ns

    for (int i = 0; i < 10; i++) begin
        for (int j = 0; j < 12; j++) begin
            product[j] = $random; // Assign random values to products
        end
        for (int i = 0; i < 12; i++) begin
        original_sum += product[i];
        end


        #10; // Wait for a clock cycle

        test_case(product, s9_final, c9_final, uut.s0, uut.s1, uut.s2, uut.s3, uut.c0, uut.c1, uut.c2, uut.c3, uut.s4, uut.c4, uut.s5, uut.c5, uut.s6, uut.c6, uut.s7, uut.c7, uut.s8, uut.c8, uut.s9, uut.c9, i + 1);
    end

end


endmodule