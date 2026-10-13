`timescale 1ns/1ps

module full_adder_top_tb;

    reg key_a_n;
    reg key_b_n;
    reg key_cin_n;

    wire led_s_n;
    wire led_cout_n;

    integer errors;
    integer csv;

    full_adder_top dut (
        .key_a_n(key_a_n),
        .key_b_n(key_b_n),
        .key_cin_n(key_cin_n),
        .led_s_n(led_s_n),
        .led_cout_n(led_cout_n)
    );

    initial begin

        errors = 0;

        csv = $fopen("full_adder_top_results.csv", "w");
        $fdisplay(csv, "input,expected,actual");

        $dumpfile("full_adder_top.vcd");
        $dumpvars(0, full_adder_top_tb);

        {key_a_n, key_b_n, key_cin_n} = 3'b111;
        #10;
        $fdisplay(csv, "000,00,%b", {~led_s_n, ~led_cout_n});
        if ({led_s_n, led_cout_n} !== 2'b11)
            errors = errors + 1;

        {key_a_n, key_b_n, key_cin_n} = 3'b110;
        #10;
        $fdisplay(csv, "001,10,%b", {~led_s_n, ~led_cout_n});
        if ({led_s_n, led_cout_n} !== 2'b01)
            errors = errors + 1;

        {key_a_n, key_b_n, key_cin_n} = 3'b101;
        #10;
        $fdisplay(csv, "010,10,%b", {~led_s_n, ~led_cout_n});
        if ({led_s_n, led_cout_n} !== 2'b01)
            errors = errors + 1;

        {key_a_n, key_b_n, key_cin_n} = 3'b100;
        #10;
        $fdisplay(csv, "011,01,%b", {~led_s_n, ~led_cout_n});
        if ({led_s_n, led_cout_n} !== 2'b10)
            errors = errors + 1;

        {key_a_n, key_b_n, key_cin_n} = 3'b011;
        #10;
        $fdisplay(csv, "100,10,%b", {~led_s_n, ~led_cout_n});
        if ({led_s_n, led_cout_n} !== 2'b01)
            errors = errors + 1;

        {key_a_n, key_b_n, key_cin_n} = 3'b010;
        #10;
        $fdisplay(csv, "101,01,%b", {~led_s_n, ~led_cout_n});
        if ({led_s_n, led_cout_n} !== 2'b10)
            errors = errors + 1;

        {key_a_n, key_b_n, key_cin_n} = 3'b001;
        #10;
        $fdisplay(csv, "110,01,%b", {~led_s_n, ~led_cout_n});
        if ({led_s_n, led_cout_n} !== 2'b10)
            errors = errors + 1;

        {key_a_n, key_b_n, key_cin_n} = 3'b000;
        #10;
        $fdisplay(csv, "111,11,%b", {~led_s_n, ~led_cout_n});
        if ({led_s_n, led_cout_n} !== 2'b00)
            errors = errors + 1;

        $fclose(csv);

        if (errors == 0)
            $display("PASS: 8 cases");
        else
            $display("FAIL: %0d cases", errors);

        $finish;

    end

endmodule
