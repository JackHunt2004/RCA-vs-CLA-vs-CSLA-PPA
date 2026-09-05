module csla_8bit (
    input  [7:0] a,
    input  [7:0] b,
    input        cin,
    output [7:0] sum,
    output       cout
);

    assign {cout, sum} = a + b + cin;

endmodule


module csla_32 (
    input  [31:0] a,
    input  [31:0] b,
    input         cin,
    output [31:0] sum,
    output        cout
);

    wire [7:0] sum0;

    wire [7:0] sum1_0, sum1_1;
    wire [7:0] sum2_0, sum2_1;
    wire [7:0] sum3_0, sum3_1;

    wire c8;
    wire c16_0, c16_1;
    wire c24_0, c24_1;
    wire c32_0, c32_1;

    wire c16;
    wire c24;

    // Block 0: actual input carry
    csla_8bit add0 (
        .a(a[7:0]),
        .b(b[7:0]),
        .cin(cin),
        .sum(sum0),
        .cout(c8)
    );

    // Block 1: calculate for carry-in = 0 and 1
    csla_8bit add1_c0 (
        .a(a[15:8]),
        .b(b[15:8]),
        .cin(1'b0),
        .sum(sum1_0),
        .cout(c16_0)
    );

    csla_8bit add1_c1 (
        .a(a[15:8]),
        .b(b[15:8]),
        .cin(1'b1),
        .sum(sum1_1),
        .cout(c16_1)
    );

    // Block 2: calculate for carry-in = 0 and 1
    csla_8bit add2_c0 (
        .a(a[23:16]),
        .b(b[23:16]),
        .cin(1'b0),
        .sum(sum2_0),
        .cout(c24_0)
    );

    csla_8bit add2_c1 (
        .a(a[23:16]),
        .b(b[23:16]),
        .cin(1'b1),
        .sum(sum2_1),
        .cout(c24_1)
    );

    // Block 3: calculate for carry-in = 0 and 1
    csla_8bit add3_c0 (
        .a(a[31:24]),
        .b(b[31:24]),
        .cin(1'b0),
        .sum(sum3_0),
        .cout(c32_0)
    );

    csla_8bit add3_c1 (
        .a(a[31:24]),
        .b(b[31:24]),
        .cin(1'b1),
        .sum(sum3_1),
        .cout(c32_1)
    );

    // Carry-select logic
    assign sum[7:0] = sum0;

    assign sum[15:8] = c8 ? sum1_1 : sum1_0;
    assign c16       = c8 ? c16_1 : c16_0;

    assign sum[23:16] = c16 ? sum2_1 : sum2_0;
    assign c24        = c16 ? c24_1 : c24_0;

    assign sum[31:24] = c24 ? sum3_1 : sum3_0;
    assign cout       = c24 ? c32_1 : c32_0;

endmodule
