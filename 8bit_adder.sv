module  8bit_adder
(
    input [7:0] A_exponent,
    input [7:0] B_exponent,
    input carry_in,
    output [7:0] sum,
    output carry_out
);

logic s_0 [0:1]; 
logic s_1 [0:1]; 
logic s_2 [0:1]; 
logic s_3 [0:1]; 

logic c_0 [0:1];
logic c_1 [0:1];       
logic c_2 [0:1];
logic c_3 [0:1];

logic c_4 [0:1]; // carry bits for partial sums

logic g_0 [0:1];
logic g_1 [0:1];       
logic g_2 [0:1];
logic g_3 [0:1];

logic p_0 [0:1];
logic p_1 [0:1];
logic p_2 [0:1];
logic p_3 [0:1];
endmodule
