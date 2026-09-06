`timescale 1ns/1ps

module adder_tb;

    reg  [31:0] a;
    reg  [31:0] b;
    reg         cin;

    wire [31:0] rca_sum;
    wire        rca_cout;

    wire [31:0] cla_sum;
    wire        cla_cout;

    wire [31:0] csla_sum;
    wire        csla_cout;

    reg  [32:0] expected;

    integer errors;
    integer i;
    integer seed;
    string  workload;

    rca_32 rca_dut (
        .a    (a),
        .b    (b),
        .cin  (cin),
        .sum  (rca_sum),
        .cout (rca_cout)
    );

    cla_32 cla_dut (
        .a    (a),
        .b    (b),
        .cin  (cin),
        .sum  (cla_sum),
        .cout (cla_cout)
    );

    csla_32 csla_dut (
        .a    (a),
        .b    (b),
        .cin  (cin),
        .sum  (csla_sum),
        .cout (csla_cout)
    );

    task check_result;
        begin
            expected = {1'b0, a} + {1'b0, b} + cin;

            #1;

            if ({rca_cout, rca_sum} !== expected) begin
                $display("ERROR: RCA  a=%h b=%h cin=%b got=%h expected=%h",
                         a, b, cin, {rca_cout, rca_sum}, expected);
                errors = errors + 1;
            end

            if ({cla_cout, cla_sum} !== expected) begin
                $display("ERROR: CLA  a=%h b=%h cin=%b got=%h expected=%h",
                         a, b, cin, {cla_cout, cla_sum}, expected);
                errors = errors + 1;
            end

            if ({csla_cout, csla_sum} !== expected) begin
                $display("ERROR: CSLA a=%h b=%h cin=%b got=%h expected=%h",
                         a, b, cin, {csla_cout, csla_sum}, expected);
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

        $dumpfile({"results/power/adder_tb_", workload, ".vcd"});
        $dumpvars(0, adder_tb);

        // ----------------------------------------------------
        // Directed functional verification
        // ----------------------------------------------------

        a = 32'h00000000;
        b = 32'h00000000;
        cin = 1'b0;
        check_result;

        a = 32'h00000001;
        b = 32'h00000001;
        cin = 1'b0;
        check_result;

        a = 32'h00000000;
        b = 32'h00000000;
        cin = 1'b1;
        check_result;

        a = 32'hFFFFFFFF;
        b = 32'h00000001;
        cin = 1'b0;
        check_result;

        a = 32'hFFFFFFFF;
        b = 32'hFFFFFFFF;
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

        a = 32'h0000FFFF;
        b = 32'h00000001;
        cin = 1'b0;
        check_result;

        a = 32'hFFFF0000;
        b = 32'h00000001;
        cin = 1'b0;
        check_result;

        a = 32'h12345678;
        b = 32'h87654321;
        cin = 1'b0;
        check_result;

        // ----------------------------------------------------
        // Controlled switching workload
        // ----------------------------------------------------

        if (workload == "low") begin

            // Low switching:
            // Hold inputs constant for several cycles and
            // change them only occasionally.

            a = 32'h12345678;
            b = 32'h87654321;
            cin = 1'b0;
            check_result;

            for (i = 0; i < 200; i = i + 1) begin
                #4;
            end

            a = 32'h12345679;
            b = 32'h87654321;
            cin = 1'b0;
            check_result;

            for (i = 0; i < 200; i = i + 1) begin
                #4;
            end

            a = 32'h12345679;
            b = 32'h87654320;
            cin = 1'b1;
            check_result;

            for (i = 0; i < 200; i = i + 1) begin
                #4;
            end

            a = 32'h12345678;
            b = 32'h87654320;
            cin = 1'b0;
            check_result;

            for (i = 0; i < 200; i = i + 1) begin
                #4;
            end

        end
        else if (workload == "high") begin

            // High switching:
            // Alternate between complementary patterns every cycle.

            for (i = 0; i < 1000; i = i + 1) begin
                if (i % 2 == 0) begin
                    a = 32'hAAAAAAAA;
                    b = 32'h55555555;
                    cin = 1'b0;
                end
                else begin
                    a = 32'h55555555;
                    b = 32'hAAAAAAAA;
                    cin = 1'b1;
                end

                check_result;
            end

        end
        else begin

            // Random switching:
            // Deterministic pseudo-random sequence using a fixed seed.

            for (i = 0; i < 1000; i = i + 1) begin
                a = $random(seed);
                b = $random(seed);
                cin = $random(seed);
                check_result;
            end

        end

        #1;

        if (errors == 0)
            $display("PASS: RCA, CLA, and CSLA functional verification completed successfully.");
        else
            $display("FAIL: %0d functional verification errors detected.", errors);

        $finish;
    end

endmodule
