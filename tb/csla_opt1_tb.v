`timescale 1ns/1ps

module csla_opt1_tb;

    reg [31:0] a, b;
    reg        cin;

    wire [31:0] sum;
    wire        cout;

    reg [32:0] expected;
    integer errors;
    integer i;
    integer seed;
    integer workload;

    csla_32_opt1 dut (
        .a    (a),
        .b    (b),
        .cin  (cin),
        .sum  (sum),
        .cout (cout)
    );

    task check_result;
        begin
            expected = {1'b0, a} + {1'b0, b} + cin;
            #1;

            if ({cout, sum} !== expected) begin
                $display(
                    "FAIL: a=%h b=%h cin=%b expected=%h got=%h",
                    a, b, cin, expected, {cout, sum}
                );
                errors = errors + 1;
            end
        end
    endtask

    initial begin
        errors   = 0;
        seed     = 32'h13579BDF;
        workload = 0;

        if (!$value$plusargs("WORKLOAD=%d", workload)) begin
            workload = 0;
        end

        // ------------------------------------------------------------
        // Directed functional tests
        // ------------------------------------------------------------

        a = 32'h00000000;
        b = 32'h00000000;
        cin = 1'b0;
        check_result;

        a = 32'hFFFFFFFF;
        b = 32'h00000000;
        cin = 1'b0;
        check_result;

        a = 32'hFFFFFFFF;
        b = 32'h00000000;
        cin = 1'b1;
        check_result;

        a = 32'hFFFFFFFF;
        b = 32'h00000001;
        cin = 1'b0;
        check_result;

        a = 32'hAAAAAAAA;
        b = 32'h55555555;
        cin = 1'b0;
        check_result;

        a = 32'hAAAAAAAA;
        b = 32'h55555555;
        cin = 1'b1;
        check_result;

        a = 32'h12345678;
        b = 32'h87654321;
        cin = 1'b0;
        check_result;

        a = 32'h12345678;
        b = 32'h87654321;
        cin = 1'b1;
        check_result;

        a = 32'h80000000;
        b = 32'h80000000;
        cin = 1'b0;
        check_result;

        a = 32'h7FFFFFFF;
        b = 32'h00000001;
        cin = 1'b0;
        check_result;

        // ------------------------------------------------------------
        // Workload characterization
        // ------------------------------------------------------------

        case (workload)

            // LOW ACTIVITY
            0: begin
                a   = 32'h13579BDF;
                b   = 32'h2468ACE0;
                cin = 1'b0;

                for (i = 0; i < 100; i = i + 1) begin
                    #10;

                    if (i % 10 == 0) begin
                        a   = ~a;
                        b   = ~b;
                        cin = ~cin;
                    end

                    check_result;
                end
            end

            // RANDOM ACTIVITY
            1: begin
                for (i = 0; i < 100; i = i + 1) begin
                    a   = $random(seed);
                    b   = $random(seed);
                    cin = $random(seed);

                    #10;
                    check_result;
                end
            end

            // HIGH ACTIVITY
            2: begin
                for (i = 0; i < 100; i = i + 1) begin

                    if (i % 2 == 0) begin
                        a   = 32'hAAAAAAAA;
                        b   = 32'h55555555;
                        cin = 1'b0;
                    end else begin
                        a   = 32'h55555555;
                        b   = 32'hAAAAAAAA;
                        cin = 1'b1;
                    end

                    #10;
                    check_result;
                end
            end

            default: begin
                $display("ERROR: Unknown WORKLOAD=%0d", workload);
                errors = errors + 1;
            end

        endcase

        // ------------------------------------------------------------
        // Final result
        // ------------------------------------------------------------

        if (errors == 0)
            $display("PASS: csla_32_opt1 workload=%0d", workload);
        else
            $display("FAIL: csla_32_opt1 errors=%0d", errors);

        $finish;
    end

endmodule
