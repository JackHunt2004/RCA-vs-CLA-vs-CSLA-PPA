module csla_8bit_shared (
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] sum0,
    output       cout0,
    output [7:0] sum1,
    output       cout1
);

    wire [8:0] base;
    wire [8:0] inc;

    // Compute A+B once.
    assign base = {1'b0, a} + {1'b0, b};

    // Derive the carry-in=1 result by incrementing the base result.
    assign inc = base + 9'd1;

    assign sum0  = base[7:0];
    assign cout0 = base[8];

    assign sum1  = inc[7:0];
    assign cout1 = inc[8];

endmodule


module csla_32_opt2 (
    input  [31:0] a,
    input  [31:0] b,
    input         cin,
    output [31:0] sum,
    output        cout
);

    wire [7:0] sum0;
    wire       c8;

    wire [7:0] sum1_0, sum1_1;
    wire       c16_0, c16_1;

    wire [7:0] sum2_0, sum2_1;
    wire       c24_0, c24_1;

    wire [7:0] sum3_0, sum3_1;
    wire       c32_0, c32_1;

    wire c16;
    wire c24;

    // Block 0: actual input carry.
    assign {c8, sum0} = {1'b0, a[7:0]} + {1'b0, b[7:0]} + cin;

    // Blocks 1-3: shared A+B computation, then derive A+B+1.
    csla_8bit_shared add1 (
        .a(a[15:8]),
        .b(b[15:8]),
        .sum0(sum1_0),
        .cout0(c16_0),
        .sum1(sum1_1),
        .cout1(c16_1)
    );

    csla_8bit_shared add2 (
        .a(a[23:16]),
        .b(b[23:16]),
        .sum0(sum2_0),
        .cout0(c24_0),
        .sum1(sum2_1),
        .cout1(c24_1)
    );

    csla_8bit_shared add3 (
        .a(a[31:24]),
        .b(b[31:24]),
        .sum0(sum3_0),
        .cout0(c32_0),
        .sum1(sum3_1),
        .cout1(c32_1)
    );

    // Preserve the original 4x8 carry-select structure.
    assign sum[7:0]   = sum0;

    assign sum[15:8]  = c8  ? sum1_1 : sum1_0;
    assign c16        = c8  ? c16_1 : c16_0;

    assign sum[23:16] = c16 ? sum2_1 : sum2_0;
    assign c24        = c16 ? c24_1 : c24_0;

    assign sum[31:24] = c24 ? sum3_1 : sum3_0;
    assign cout       = c24 ? c32_1 : c32_0;

endmodule
