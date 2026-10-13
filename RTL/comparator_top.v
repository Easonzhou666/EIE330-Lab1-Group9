`timescale 1ns/1ps

module comparator_top (
    input wire key_a_n,
    input wire key_b_n,
    output wire led_lt_n,
    output wire led_eq_n,
    output wire led_gt_n
);

    wire a;
    wire b;
    wire lt;
    wire eq;
    wire gt;

    
    assign a = ~key_a_n;
    assign b = ~key_b_n;

    
    assign lt = (~a) & b;
    assign eq = ~(a ^ b);
    assign gt = a & (~b);

    
    assign led_lt_n = ~lt;
    assign led_eq_n = ~eq;
    assign led_gt_n = ~gt;

endmodule
