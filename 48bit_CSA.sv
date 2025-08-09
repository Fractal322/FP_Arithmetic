
module 48bit_CSA
(
    input clk,
    input nreset,
    input [47:0] product [0:11], // Partial accumulators for stage 1

    output logic [47:0] s9_final,
    output logic [47:0] c9_final,
    output logic carry_out
);

logic [47:0] Acc [0:11]; // Partial accumulators

always_ff @(posedge clk, negedge nreset) begin
    if (!nreset) begin
        for (int i = 0; i < 12; i++) begin
            Acc[i] <= 48'b0; // Reset all accumulators
        end
    end else begin
        for (int i = 0; i < 12; i++) begin
            Acc[i] <= product[i]; // Load partial accumulators
        end
    end
end

logic [48:0] s0, s1, s2, s3; // Stage 1 sums
logic [48:0] c0, c1, c2, c3; // Stage 1 carries

logic [49:0] s4, s5; // Stage 2 sums
logic [49:0] c4, c5; // Stage 2 carries

logic [50:0] s6, s7; // Stage 3 sums
logic [50:0] c6, c7; // Stage 3 carries

logic [51:0] s8; // Stage 4 sums
logic [51:0] c8; // Stage 4 carries

logic [52:0] s9; // Stage 5 sums
logic [52:0] c9; // Stage 5 carries

always_comb begin
    // STAGE 1
    for (int i = 0; i < 49; i++) begin
        if (i == 0) begin
            // Initialize the first stage with carry_in = 0
            s0[i] = S_out(Acc[0][i], Acc[1][i], Acc[2][i]);
            s1[i] = S_out(Acc[3][i], Acc[4][i], Acc[5][i]);
            s2[i] = S_out(Acc[6][i], Acc[7][i], Acc[8][i]);
            s3[i] = S_out(Acc[9][i], Acc[10][i], Acc[11][i]);

            c0[i] = 0;
            c1[i] = 0;
            c2[i] = 0;
            c3[i] = 0;

            c0[i+1] = C_out(Acc[0][i], Acc[1][i], Acc[2][i]);
            c1[i+1] = C_out(Acc[3][i], Acc[4][i], Acc[5][i]);
            c2[i+1] = C_out(Acc[6][i], Acc[7][i], Acc[8][i]);
            c3[i+1] = C_out(Acc[9][i], Acc[10][i], Acc[11][i]);

        end
        else if (i < 48 && i > 0) begin

            s0[i] = S_out(Acc[0][i], Acc[1][i], Acc[2][i]);
            s1[i] = S_out(Acc[3][i], Acc[4][i], Acc[5][i]);
            s2[i] = S_out(Acc[6][i], Acc[7][i], Acc[8][i]);
            s3[i] = S_out(Acc[9][i], Acc[10][i], Acc[11][i]);

            c0[i+1] = C_out(Acc[0][i], Acc[1][i], Acc[2][i]);
            c1[i+1] = C_out(Acc[3][i], Acc[4][i], Acc[5][i]);
            c2[i+1] = C_out(Acc[6][i], Acc[7][i], Acc[8][i]);
            c3[i+1] = C_out(Acc[9][i], Acc[10][i], Acc[11][i]);

        end
        else if (i == 48) begin

            so[i] = 0;
            s1[i] = 0;
            s2[i] = 0;
            s3[i] = 0;
            
        end
    end
end

alaways_comb begin
    // STAGE 2
    for (int i = 0; i < 50; i++) begin
        if (i == 0) begin
            s4[i] = S_out(s0[i], s1[i], s2[i]);
            s5[i] = S_out(c0[i], c1[i], c2[i]);

            c4[0] = 0;
            c5[0] = 0;

            c4[i+1] = C_out(s0[i], s1[i], s2[i]);
            c5[i+1] = C_out(c0[i], c1[i], c2[i]);
        end
        else if (i < 49 && i > 0) begin
            s4[i] = S_out(s0[i], s1[i], s2[i]);
            s5[i] = S_out(c0[i], c1[i], c2[i]);

            c4[i+1] = C_out(s0[i], s1[i], s2[i]);
            c5[i+1] = C_out(c0[i], c1[i], c2[i]);
        end
        else if (i == 49) begin
            s4[49] = 0;
            s5[49] = 0;
        end
    end


end

always_comb begin
    // STAGE 3
    for (int i = 0; i < 51; i++) begin
        if (i == 0) begin
            s6[i] = S_out(s4[i], s5[i], s3[i]);
            s7[i] = S_out(c4[i], c5[i], c3[i]);

            c6[0] = 0;
            c7[0] = 0;

            c6[i+1] = C_out(s4[i], s5[i], s3[i]);
            c7[i+1] = C_out(c4[i], c5[i], c3[i]);
        end
        else if (i < 50 && i > 0) begin
            s6[i] = S_out(s4[i], s5[i], s3[i]);
            s7[i] = S_out(c4[i], c5[i], c3[i]);

            c6[i+1] = C_out(s4[i], s5[i], s3[i]);
            c7[i+1] = C_out(c4[i], c5[i], c3[i]);
        end
        else if (i == 50) begin
            s6[50] = 0;
            s7[50] = 0;
        end
    end
end

always_comb begin
    // STAGE 4
    for (int i = 0; i < 52; i++) begin
        if (i == 0) begin
            s8[i] = S_out(s6[i], s7[i], c6[i]);

            c8[0] = 0;

            c8[i+1] = C_out(s6[i], s7[i], c6[i]);
        end
        else if (i < 51 && i > 0) begin
            s8[i] = S_out(s6[i], s7[i], c6[i]);
            c8[i+1] = C_out(s6[i], s7[i], c6[i]);
        end
        else if (i == 51) begin
            s8[51] = 0;
        end
    end

end

always_comb begin
    for (int i = 0; i < 53; i++) begin
        if (i == 0) begin
            s9[i] = S_out(s8[i], c8[i], c7[i]);

            c9[0] = 0;

            c9[i+1] = C_out(s8[i], c8[i], c7[i]);
        end
        else if (i < 52 && i > 0) begin
            s9[i] = S_out(s8[i], c8[i], c7[i]);
            c9[i+1] = C_out(s8[i], c8[i], c7[i]);
        end
        else if (i == 52) begin
            s9[52] = 0;
        end
    end
end
    
assign s9_final = s9[47:0]; // Final sum output
assign c9_final = c9[47:0]; // Final carry output

function automatic logic S_out (
    input logic A,
    input logic B,
    input logic carry_in
)

    return (A ^ B ^ carry_in);

endfunction

function automatic logic C_out (
    input logic A,
    input logic B,
    input logic carry_in
)
    return (A & B) | (carry_in & (A ^ B));

endfunction

endmodule