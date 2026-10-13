module comparator_top_tb;

    reg key_a_n;
    reg key_b_n;

    wire led_lt_n;
    wire led_eq_n;
    wire led_gt_n;

    integer errors;
    integer csv;

    comparator_top dut (
        .key_a_n(key_a_n),
        .key_b_n(key_b_n),
        .led_lt_n(led_lt_n),
        .led_eq_n(led_eq_n),
        .led_gt_n(led_gt_n)
    );

    initial begin

        errors = 0;

        csv = $fopen("comparator_top_results.csv", "w");
        $fdisplay(csv, "input,expected,actual");

        $dumpfile("comparator_top.vcd");
        $dumpvars(0, comparator_top_tb);

        {key_a_n, key_b_n} = 2'b11;
        #10;
        $fdisplay(csv, "00,010,%b",
                  {~led_lt_n, ~led_eq_n, ~led_gt_n});

        if ({led_lt_n, led_eq_n, led_gt_n} !== 3'b101)
            errors = errors + 1;

        {key_a_n, key_b_n} = 2'b10;
        #10;
        $fdisplay(csv, "01,100,%b",
                  {~led_lt_n, ~led_eq_n, ~led_gt_n});

        if ({led_lt_n, led_eq_n, led_gt_n} !== 3'b011)
            errors = errors + 1;

        {key_a_n, key_b_n} = 2'b01;
        #10;
        $fdisplay(csv, "10,001,%b",
                  {~led_lt_n, ~led_eq_n, ~led_gt_n});

        if ({led_lt_n, led_eq_n, led_gt_n} !== 3'b110)
            errors = errors + 1;

        {key_a_n, key_b_n} = 2'b00;
        #10;
        $fdisplay(csv, "11,010,%b",
                  {~led_lt_n, ~led_eq_n, ~led_gt_n});

        if ({led_lt_n, led_eq_n, led_gt_n} !== 3'b101)
            errors = errors + 1;

        $fclose(csv);

        if (errors == 0)
            $display("PASS: 4 cases");
        else
            $display("FAIL: %0d cases", errors);

        $finish;

    end

endmodule
