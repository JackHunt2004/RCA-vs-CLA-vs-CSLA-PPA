module csla_4bit (
    input  [3:0] a,
    input  [3:0] b,
    input        cin,
    output [3:0] sum,
    output       cout
);

    assign {cout, sum} = a + b + cin;

endmodule


module csla_32_opt1 (
    input  [31:0] a,
    input  [31:0] b,
    input         cin,
    output [31:0] sum,
    output        cout
);

    wire [3:0] sum0;

    wire [3:0] sum1_0, sum1_1;
    wire [3:0] sum2_0, sum2_1;
    wire [3:0] sum3_0, sum3_1;
    wire [3:0] sum4_0, sum4_1;
    wire [3:0] sum5_0, sum5_1;
    wire [3:0] sum6_0, sum6_1;
    wire [3:0] sum7_0, sum7_1;

    wire c4;
    wire c8_0,  c8_1;
    wire c12_0, c12_1;
    wire c16_0, c16_1;
    wire c20_0, c20_1;
    wire c24_0, c24_1;
    wire c28_0, c28_1;
    wire c32_0, c32_1;

    wire c8, c12, c16, c20, c24, c28;

    // Block 0: actual input carry
    csla_4bit add0 (
        .a(a[3:0]),
        .b(b[3:0]),
        .cin(cin),
        .sum(sum0),
        .cout(c4)
    );

    // Block 1
    csla_4bit add1_c0 (.a(a[7:4]),   .b(b[7:4]),   .cin(1'b0), .sum(sum1_0), .cout(c8_0));
    csla_4bit add1_c1 (.a(a[7:4]),   .b(b[7:4]),   .cin(1'b1), .sum(sum1_1), .cout(c8_1));

    // Block 2
    csla_4bit add2_c0 (.a(a[11:8]),  .b(b[11:8]),  .cin(1'b0), .sum(sum2_0), .cout(c12_0));
    csla_4bit add2_c1 (.a(a[11:8]),  .b(b[11:8]),  .cin(1'b1), .sum(sum2_1), .cout(c12_1));

    // Block 3
    csla_4bit add3_c0 (.a(a[15:12]), .b(b[15:12]), .cin(1'b0), .sum(sum3_0), .cout(c16_0));
    csla_4bit add3_c1 (.a(a[15:12]), .b(b[15:12]), .cin(1'b1), .sum(sum3_1), .cout(c16_1));

    // Block 4
    csla_4bit add4_c0 (.a(a[19:16]), .b(b[19:16]), .cin(1'b0), .sum(sum4_0), .cout(c20_0));
    csla_4bit add4_c1 (.a(a[19:16]), .b(b[19:16]), .cin(1'b1), .sum(sum4_1), .cout(c20_1));

    // Block 5
    csla_4bit add5_c0 (.a(a[23:20]), .b(b[23:20]), .cin(1'b0), .sum(sum5_0), .cout(c24_0));
    csla_4bit add5_c1 (.a(a[23:20]), .b(b[23:20]), .cin(1'b1), .sum(sum5_1), .cout(c24_1));

    // Block 6
    csla_4bit add6_c0 (.a(a[27:24]), .b(b[27:24]), .cin(1'b0), .sum(sum6_0), .cout(c28_0));
    csla_4bit add6_c1 (.a(a[27:24]), .b(b[27:24]), .cin(1'b1), .sum(sum6_1), .cout(c28_1));

    // Block 7
    csla_4bit add7_c0 (.a(a[31:28]), .b(b[31:28]), .cin(1'b0), .sum(sum7_0), .cout(c32_0));
    csla_4bit add7_c1 (.a(a[31:28]), .b(b[31:28]), .cin(1'b1), .sum(sum7_1), .cout(c32_1));

    // Carry-select logic
    assign sum[3:0] = sum0;

    assign sum[7:4]   = c4  ? sum1_1 : sum1_0;
    assign c8         = c4  ? c8_1  : c8_0;

    assign sum[11:8]  = c8  ? sum2_1 : sum2_0;
    assign c12        = c8  ? c12_1 : c12_0;

    assign sum[15:12] = c12 ? sum3_1 : sum3_0;
    assign c16        = c12 ? c16_1 : c16_0;

    assign sum[19:16] = c16 ? sum4_1 : sum4_0;
    assign c20        = c16 ? c20_1 : c20_0;

    assign sum[23:20] = c20 ? sum5_1 : sum5_0;
    assign c24        = c20 ? c24_1 : c24_0;

    assign sum[27:24] = c24 ? sum6_1 : sum6_0;
    assign c28        = c24 ? c28_1 : c28_0;

    assign sum[31:28] = c28 ? sum7_1 : sum7_0;
    assign cout       = c28 ? c32_1 : c32_0;

endmodule
