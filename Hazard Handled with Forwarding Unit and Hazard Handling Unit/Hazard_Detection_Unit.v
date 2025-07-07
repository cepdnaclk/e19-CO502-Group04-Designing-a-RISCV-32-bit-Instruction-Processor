module Hazard_Detection_Unit (
    input  [4:0] Rs1D2HDU,     // Source reg 1 from Decode stage
    input  [4:0] Rs2D2HDU,     // Source reg 2 from Decode stage
    input  [4:0] RdE2HDU,      // Destination reg from Execute stage
    input        MemReadE2HDU,     // Is Execute stage a load?

    output       StallF,       // Stall Fetch stage
    output       StallD,       // Stall Decode stage
    output       FlushE        // Flush Execute stage
);

    wire hazard_detected;

    assign hazard_detected = MemReadE2HDU &&
                             ((RdE2HDU != 5'd0) &&
                              (RdE2HDU == Rs1D2HDU || RdE2HDU == Rs2D2HDU));

    assign StallF = hazard_detected;
    assign StallD = hazard_detected;
    assign FlushE = hazard_detected;

endmodule
