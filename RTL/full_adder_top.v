`timescale 1ns/1ps

module full_adder_top (
    input wire key_a_n,
    input wire key_b_n,
    input wire key_cin_n,
    output wire led_s_n,
    output wire led_cout_n
);

    wire a;
    wire b;
    wire cin;
    wire s;
    wire cout;

    
    assign a   = ~key_a_n;
    assign b   = ~key_b_n;
    assign cin = ~key_cin_n;

    
    assign s    = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);

    
    assign led_s_n    = ~s;
    assign led_cout_n = ~cout;

endmodule
