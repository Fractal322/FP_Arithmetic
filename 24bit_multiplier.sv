module multiplier_24bit (
    input        clk,
    input        nreset,
    input [23:0] A_mantissa,
    input [23:0] B_mantissa,
    output [47:0] product [0:11]
);

    // Internal registers
    logic [23:0] Q, M;       // Q = Multiplier (A), M = Multiplicand (B)
    logic [47:0] P;          // Product accumulator

    // 2's complement of M (for subtraction)
    logic [23:0] M_2s;
    assign M_2s = ~M + 1'b1;

    // Booth encoding signals (for 12 stages: 24 bits / 2 bits per iteration)
    logic [47:0] Acc [0:11]; // Partial accumulators
    logic r_2 [0:11];        // r_2 = Q[2i+1]
    logic r_1 [0:11];        // r_1 = Q[2i]
    logic r_0 [0:11];        // r_0 = Q[2i-1] (or 0 for i=0)

    // Clocked process (reset and register updates)
    always_ff @(posedge clk, negedge nreset) begin
        if (!nreset) begin
            P <= 48'b0;
            Q <= '0;
            M <= '0;
        end else begin
            Q <= A_mantissa;         // Load multiplier (A)
            M <= B_mantissa;         // Load multiplicand (B)
            P <= product;  // Update product register (optional)
        end
    end

    // Combinational Booth logic
    always_comb begin
        // Generate Booth encoding signals
        for (int i = 0; i < 12; i++) begin
            r_2[i] = (2*i+1 < 24) ? Q[2*i+1] : 1'b0;  // Handle out-of-bounds
            r_1[i] = Q[2*i];
            r_0[i] = (i == 0) ? 1'b0 : Q[2*i-1];
        end

        // Compute partial accumulations
        for (int i = 0; i < 12; i++) begin
            Acc[i] = acc_func(r_2[i], r_1[i], r_0[i], M, M_2s);
        end

        // Sum all partial accumulations (final product)
        for (int i = 0; i < 48; i++) begin
            product[i] = 0; // Initialize product
        end

        for (int i = 0; i < 12; i++) begin
            product[i] = (Acc[i] << (2*i));  // Shift and add
        end
    end

    // Booth accumulator function
    function automatic logic [47:0] acc_func(
        input logic       r_2,
        input logic       r_1,
        input logic       r_0,
        input logic [23:0] M,
        input logic [23:0] M_2s
    );
        case ({r_2, r_1, r_0})
            3'b000: acc_func = 48'b0;           // No operation
            3'b001: acc_func = {24'b0, M};      // +M
            3'b010: acc_func = {24'b0, M};      // +M
            3'b011: acc_func = {23'b0, M, 1'b0}; // +2M (M << 1)
            3'b100: acc_func = {23'b1, M_2s, 1'b0}; // -2M (M_2s << 1)
            3'b101: acc_func = {24'b1, M_2s};   // -M
            3'b110: acc_func = {24'b1, M_2s};   // -M
            3'b111: acc_func = 48'b0;           // No operation
            default: acc_func = 48'bx;          // Undefined (simulation)
        endcase
    endfunction

endmodule