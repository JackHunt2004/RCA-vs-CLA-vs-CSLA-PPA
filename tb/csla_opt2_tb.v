`timescale 1ns/1ps

module csla_opt2_tb;

    reg  [31:0] a;
    reg  [31:0] b;
    reg         cin;
    wire [31:0] sum;
    wire        cout;

    reg  [32:0] expected;
    integer i;
    integer workload;

    csla_32_opt2 dut (
        .a(a),
        .b(b),
        .cin(cin),
        .sum(sum),
        .cout(cout)
    );

    task check;
        begin
            #1;
            expected = {1'b0, a} + {1'b0, b} + cin;

            if ({cout, sum} !== expected) begin
                $display("FAIL: a=%h b=%h cin=%b got=%h expected=%h",
                         a, b, cin, {cout, sum}, expected);
                $finish;
            end
        end
    endtask

    initial begin
        workload = 1;

        if (!$value$plusargs("WORKLOAD=%d", workload))
            workload = 1;

        if (workload == 0)
            $dumpfile("results/power/csla_opt2_gate_low.vcd");
        else if (workload == 1)
            $dumpfile("results/power/csla_opt2_gate_random.vcd");
        else
            $dumpfile("results/power/csla_opt2_gate_high.vcd");

        $dumpvars(0, csla_opt2_tb);

        // Directed functional tests.
        a = 32'h00000000; b = 32'h00000000; cin = 1'b0; check;
        a = 32'hFFFFFFFF; b = 32'h00000000; cin = 1'b0; check;
        a = 32'hFFFFFFFF; b = 32'h00000001; cin = 1'b0; check;
        a = 32'hAAAAAAAA; b = 32'h55555555; cin = 1'b0; check;
        a = 32'hAAAAAAAA; b = 32'h55555555; cin = 1'b1; check;
        a = 32'h12345678; b = 32'h87654321; cin = 1'b0; check;
        a = 32'h12345678; b = 32'h87654321; cin = 1'b1; check;
        a = 32'h80000000; b = 32'h80000000; cin = 1'b0; check;
        a = 32'h0000FFFF; b = 32'h00000001; cin = 1'b0; check;
        a = 32'h7FFFFFFF; b = 32'h00000001; cin = 1'b0; check;

        // Controlled switching workload.
        if (workload == 0) begin
            // Low activity.
            a = 32'h00000000;
            b = 32'h00000000;
            cin = 1'b0;

            repeat (100) begin
                #10;
                if ($time % 50 == 0) begin
                    a = a + 32'h00000001;
                    b = b + 32'h00000001;
                end
                check;
            end

        end else if (workload == 2) begin
            // High activity.
            for (i = 0; i < 100; i = i + 1) begin
                #10;
                a = ~a;
                b = ~b;
                cin = ~cin;
                check;
            end

        end else begin
            // Deterministic random activity.
            integer seed;
            seed = 32'h12345678;

            for (i = 0; i < 100; i = i + 1) begin
                #10;
                a = $random(seed);
                b = $random(seed);
                cin = $random(seed) & 1;
                check;
            end
        end

        $display("PASS: CSLA OPT2 workload %0d", workload);
        $finish;
    end

endmodule
