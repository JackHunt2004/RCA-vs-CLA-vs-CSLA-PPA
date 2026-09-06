`timescale 1ns/1ps

module cla_gate_tb;

    reg  [31:0] a;
    reg  [31:0] b;
    reg         cin;

    wire [31:0] sum;
    wire        cout;

    reg  [32:0] expected;

    integer errors;
    integer i;
    integer seed;
    string  workload;

    cla_32 dut (
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
                $display("ERROR: a=%h b=%h cin=%b got=%h expected=%h",
                         a, b, cin, {cout, sum}, expected);
                errors = errors + 1;
            end
        end
    endtask

    initial begin
        errors = 0;
        seed = 32'h13579BDF;
        workload = "random";

        if ($value$plusargs("WORKLOAD=%s", workload))
            $display("Selected workload: %s", workload);
        else
            $display("No workload specified. Defaulting to: random");

        $dumpfile({"results/power/cla_gate_", workload, ".vcd"});
        $dumpvars(0, cla_gate_tb);

        // Directed verification tests
        a = 32'h00000000; b = 32'h00000000; cin = 1'b0; check_result;
        a = 32'hFFFFFFFF; b = 32'h00000000; cin = 1'b0; check_result;
        a = 32'hFFFFFFFF; b = 32'h00000001; cin = 1'b0; check_result;
        a = 32'hAAAAAAAA; b = 32'h55555555; cin = 1'b0; check_result;
        a = 32'hAAAAAAAA; b = 32'h55555555; cin = 1'b1; check_result;
        a = 32'h12345678; b = 32'h87654321; cin = 1'b0; check_result;
        a = 32'h12345678; b = 32'h87654321; cin = 1'b1; check_result;
        a = 32'h80000000; b = 32'h80000000; cin = 1'b0; check_result;
        a = 32'h0000FFFF; b = 32'h00000001; cin = 1'b0; check_result;
        a = 32'h7FFFFFFF; b = 32'h00000001; cin = 1'b0; check_result;

        // Controlled switching workload
        if (workload == "low") begin
            a = 32'h00000000;
            b = 32'h00000000;
            cin = 1'b0;

            repeat (100) begin
                #10;
                if ($time % 50 == 0) begin
                    a = a + 32'h00000001;
                    b = b + 32'h00000001;
                end
                check_result;
            end

        end else if (workload == "high") begin
            for (i = 0; i < 100; i = i + 1) begin
                #10;
                a = ~a;
                b = ~b;
                cin = ~cin;
                check_result;
            end

        end else begin
            for (i = 0; i < 100; i = i + 1) begin
                #10;
                a = $random(seed);
                b = $random(seed);
                cin = $random(seed) & 1;
                check_result;
            end
        end

        if (errors == 0)
            $display("PASS: CLA gate-level simulation completed with no errors.");
        else
            $display("FAIL: CLA gate-level simulation found %0d errors.", errors);

        $finish;
    end

endmodule
