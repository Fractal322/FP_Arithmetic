// Description: 48-bit Carry Lookahead Adder (CLA) module

module CLA_module
(
    input clk,
    input nreset,
    input logic [47:0] s9_final,
    input logic [47:0] c9_final,

    output logic [47:0] mantissa_mul,
    output logic carry_out
);

logic [47:0] s9_reg;
logic [47:0]c9_reg;
logic [47:0] mantissa_mul_reg;


logic s_0 [0:11]; 
logic s_1 [0:11]; 
logic s_2 [0:11]; 
logic s_3 [0:11]; 

logic c_1 [0:11];       
logic c_2 [0:11];
logic c_3 [0:11];
logic c_4 [0:11]; // carry bits for partial sums

logic g_0 [0:11];
logic g_1 [0:11];       
logic g_2 [0:11];
logic g_3 [0:11];

logic p_0 [0:11];
logic p_1 [0:11];
logic p_2 [0:11];
logic p_3 [0:11];

always_ff @(posedge clk, negedge nreset) begin
    if (!nreset) begin
        mantissa_mul <= 48'b0;
        carry_out <= 1'b0;
        s9_reg <= 48'b0;
        c9_reg <= 48'b0;
        mantissa_mul_reg <= 48'b0;
    end else begin
        s9_reg <= s9_final;
        c9_reg <= c9_final;
        mantissa_mul <= mantissa_mul_reg;
        carry_out <= c_4[11]; // Final carry out is the last carry bit
    end
end

// Combinational logic for CLA
always_comb begin

    for (int i = 0; i < 12; i++) begin
        int j = i * 4; // Calculate index for 4-bit groups
        // Generate and propagate signals
        g_0[i] = G_out(s9_reg[j + 0], c9_reg[j + 0]);
        p_0[i] = P_out(s9_reg[j + 0], c9_reg[j + 0]);
        g_1[i] = G_out(s9_reg[j + 1], c9_reg[j + 1]);
        p_1[i] = P_out(s9_reg[j + 1], c9_reg[j + 1]);
        g_2[i] = G_out(s9_reg[j + 2], c9_reg[j + 2]);
        p_2[i] = P_out(s9_reg[j + 2], c9_reg[j + 2]);
        g_3[i] = G_out(s9_reg[j + 3], c9_reg[j + 3]);
        p_3[i] = P_out(s9_reg[j + 3], c9_reg[j + 3]);

        // Calculate carry bits
        if (i == 0) begin
            c_1[0] = C_1_out(g_0[i], p_0[i], 0);
            c_2[0] = C_2_out(g_1[i], g_0[i], p_1[i], 0, p_0[i]);
            c_3[0] = C_3_out(g_2[i], g_1[i], g_0[i], p_2[i], 0, p_0[i], p_1[i]);
            c_4[0] = C_4_out(g_3[i], g_2[i], g_1[i], g_0[i], p_3[i], p_2[i], p_1[i], p_0[i], 0);
        end else begin
            c_1[i] = C_1_out(g_0[i], p_0[i], c_4[i-1]);
            c_2[i] = C_2_out(g_1[i], g_0[i], p_1[i], c_4[i-1], p_0[i]);
            c_3[i] = C_3_out(g_2[i], g_1[i], g_0[i], p_2[i], c_4[i-1], p_0[i], p_1[i]);
            c_4[i] = C_4_out(g_3[i], g_2[i], g_1[i], g_0[i], p_3[i], p_2[i], p_1[i], p_0[i], c_4[i-1]);
        end


        // Calculate sum bits
        if (i == 0) begin
            s_0[i] = S_out(s9_reg[j + 0], c9_reg[j + 0], 0);
            s_1[i] = S_out(s9_reg[j + 1], c9_reg[j + 1], c_1[i]);
            s_2[i] = S_out(s9_reg[j + 2], c9_reg[j + 2], c_2[i]);
            s_3[i] = S_out(s9_reg[j + 3], c9_reg[j + 3], c_3[i]);
        end else begin
            s_0[i] = S_out(s9_reg[j + 0], c9_reg[j + 0], c_4[i-1]);
            s_1[i] = S_out(s9_reg[j + 1], c9_reg[j + 1], c_1[i]);
            s_2[i] = S_out(s9_reg[j + 2], c9_reg[j + 2], c_2[i]);
            s_3[i] = S_out(s9_reg[j + 3], c9_reg[j + 3], c_3[i]);
        end


    end
end


always_comb begin
    // Assign final outputs
    for (int i = 0; i < 12; i++) begin
        mantissa_mul_reg[i * 4 + 0] = s_0[i];
        mantissa_mul_reg[i * 4 + 1] = s_1[i];
        mantissa_mul_reg[i * 4 + 2] = s_2[i];
        mantissa_mul_reg[i * 4 + 3] = s_3[i];
    end

end


function automatic logic S_out (
    input logic A,
    input logic B,
    input logic C
);
    return A ^ B ^ C; // Sum output 
endfunction

function automatic logic G_out (
    input logic A,
    input logic B
);
    return A & B; // Generate output for stage 0    
endfunction

function automatic logic P_out (
    input logic A,
    input logic B
);
    return A ^ B; // Propagate output for stage 0
endfunction

function automatic logic C_1_out (
    input logic G_0,
    input logic P_0,
    input logic C_0
);

    return (G_0 | (P_0 & C_0)); // Carry 1 output 
endfunction

function automatic logic C_2_out (
    input logic G_1,
    input logic G_0,
    input logic P_1,
    input logic C_0,
    input logic P_0
);
    return (G_1 | (P_1 & G_0) | (P_1 & P_0 & C_0)); // Carry 2 output
endfunction

function automatic logic C_3_out (
    input logic G_2,
    input logic G_1,
    input logic G_0,
    input logic P_2,
    input logic C_0,
    input logic P_0,
    input logic P_1
);
    return (G_2 | (P_2 & G_1) | (P_2 & P_1 & G_0) | (P_2 & P_1 & P_0 & C_0)); // Carry 3 output
endfunction

function automatic logic C_4_out (
    input logic G_3,
    input logic G_2,
    input logic G_1,    
    input logic G_0,
    input logic P_3,
    input logic P_2,
    input logic P_1,
    input logic P_0,
    input logic C_0
);
    return (G_3 | (P_3 & G_2) | (P_3 & P_2 & G_1) | (P_3 & P_2 & P_1 & G_0) | (P_3 & P_2 & P_1 & P_0 & C_0)); // Carry 4 output
endfunction

endmodule