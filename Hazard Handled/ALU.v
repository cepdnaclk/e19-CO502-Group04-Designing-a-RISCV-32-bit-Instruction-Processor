module ALU (
    input  [31:0] rs1,             // First source register (32-bit)
    input  [31:0] rs2,             // Second source register (32-bit)
    input  [5:0] aluSelect,        // ALU control signal (6-bit)
    output reg [31:0] result,      // ALU result (32-bit)
    output branch_taken            // Branch decision (1 bit)
);

    // Internal wires for outputs from other modules
    wire [31:0] utype_result;      // From Utype
    wire [31:0] rtype_result;      // From RItype
    wire [31:0] muldiv_result;     // From muldiv
    wire [31:0] loadstore_result;  // From LoadStoreUnit
    wire [31:0] jtype_result;      // From Jtype

    // Module instances
    Utype utype (
        .pc(rs1),          // Pass pc (rs1) as program counter to Utype
        .imm_u(rs2),       // Pass immediate value to Utype
        .aluSelect(aluSelect), // ALU control signal for Utype
        .result(utype_result)  // Output of Utype
    );

    RItype rtype (
        .a(rs1),            // rs1 for R-type and I-type
        .b(rs2),            // rs2 for R-type and I-type
        .aluSelect(aluSelect), // ALU control signal for RItype
        .result(rtype_result)  // Output of RItype
    );

    muldiv muldiv_inst (
        .rs1(rs1),           // rs1 for multiplication/division
        .rs2(rs2),           // rs2 for multiplication/division
        .aluSelect(aluSelect), // ALU control signal for multiplication/division
        .result(muldiv_result)  // Output of muldiv
    );

    LoadStoreUnit loadstore (
        .rs1(rs1),           // Base address register (rs1)
        .imm(rs2),           // Immediate value (for offset)
        .aluSelect(aluSelect), // ALU select signal for load/store
        .address(loadstore_result) // Result of load/store operation (address)
    );

    Jtype jtype_inst (
        .pc(rs1),           // rs1 for JALR (source register)
        .imm(rs2),           // Immediate value
        .aluSelect(aluSelect), // ALU control signal for Jtype
        .next_pc(jtype_result) // Output for next program counter
    );

    Btype btype_inst (
        .aluSelect(aluSelect), // Branch control signal (from control unit)
        .rs1(rs1),                // rs1 for branch comparison
        .rs2(rs2),                // rs2 for branch comparison
        .branch_taken(branch_taken) // Branch taken decision
    );

    // Compute the final result by ORing outputs from all modules
    always @(*) begin
        result = utype_result | rtype_result | muldiv_result |
                 loadstore_result | jtype_result;
    end

endmodule
