module FP_Multiplier 
(   input clk,
    input nreset,
    input wire [31:0] A,
    input wire [31:0] B,
    output logic [7:0] A_exponent, 
    output logic [7:0] B_exponent,
    output logic [23:0] A_mantissa, 
    output logic [23:0] B_mantissa,
    output logic [31:0] mul_result);
    
    logic [31:0] A_reg, B_reg;

    logic A_sign, B_sign;
    

    logic [31:0] mul_result_reg;

    logic result_sign;
    logic [7:0] result_exponent;
    logic [22:0] result_mantissa;
    
    logic [47:0] mantissa_mul;
    logic [7:0] exponent_diff;

    // Input of numbers used for the FP operation
    always_ff @(posedge clk, negedge nreset)
    begin
        if (nreset) 
        begin
            A_reg <= '0;
            B_reg <= '0;
            mul_result_reg <= '0;
        end
        else
        begin
            A_reg <= A;
            B_reg <= B;
            mul_result_reg <=  {result_sign, result_exponent, result_mantissa};
        end
    end

    assign A_sign = A_reg[31];
    assign B_sign = B_reg[31];
    assign A_exponent = A_reg[30:23];
    assign B_exponent = B_reg[30:23];
    assign A_mantissa = {1'b1, A_reg[22:0]};
    assign B_mantissa = {1'b1, B_reg[22:0]};
    
    // Combinational logic of the arithmetic operation
    always_comb
    begin

        // Sign of the result
        result_sign = (A_sign ^ B_sign); 

        // Exponent calculation
        exponent_diff = A_exponent + B_exponent - 8'd127;

        mantissa_mul = A_mantissa * B_mantissa;

        if (mantissa_mul[47]) begin
            // If the result is too large, we need to normalize it
            result_mantissa = mantissa_mul[46:24]; // Shift right by 1
            result_exponent = exponent_diff + 1; // Increase exponent
        end
        else begin
            // If the result is not too large, we can use it directly
            result_mantissa = mantissa_mul[45:23]; // Keep the 24 bits
            result_exponent = exponent_diff; // Use the exponent as is
        end


    end

    assign mul_result = mul_result_reg;

endmodule
