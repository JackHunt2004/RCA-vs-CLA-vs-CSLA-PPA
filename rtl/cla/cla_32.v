module cla_8bit (
    input  [7:0] a,
    input  [7:0] b,
    input        cin,
    output [7:0] sum,
    output       cout
);

    wire [7:0] p;
    wire [7:0] g;
    wire [8:0] c;

    assign p = a ^ b;
    assign g = a & b;

    assign c[0] = cin;

    assign c[1] = g[0] | (p[0] & c[0]);

    assign c[2] = g[1] |
                  (p[1] & g[0]) |
                  (p[1] & p[0] & c[0]);

    assign c[3] = g[2] |
                  (p[2] & g[1]) |
                  (p[2] & p[1] & g[0]) |
                  (p[2] & p[1] & p[0] & c[0]);

    assign c[4] = g[3] |
                  (p[3] & g[2]) |
                  (p[3] & p[2] & g[1]) |
                  (p[3] & p[2] & p[1] & g[0]) |
                  (p[3] & p[2] & p[1] & p[0] & c[0]);

    assign c[5] = g[4] |
                  (p[4] & g[3]) |
                  (p[4] & p[3] & g[2]) |
                  (p[4] & p[3] & p[2] & g[1]) |
                  (p[4] & p[3] & p[2] & p[1] & g[0]) |
                  (p[4] & p[3] & p[2] & p[1] & p[0] & c[0]);

    assign c[6] = g[5] |
                  (p[5] & g[4]) |
                  (p[5] & p[4] & g[3]) |
                  (p[5] & p[4] & p[3] & g[2]) |
                  (p[5] & p[4] & p[3] & p[2] & g[1]) |
                  (p[5] & p[4] & p[3] & p[2] & p[1] & g[0]) |
                  (p[5] & p[4] & p[3] & p[2] & p[1] & p[0] & c[0]);

    assign c[7] = g[6] |
                  (p[6] & g[5]) |
                  (p[6] & p[5] & g[4]) |
                  (p[6] & p[5] & p[4] & g[3]) |
                  (p[6] & p[5] & p[4] & p[3] & g[2]) |
                  (p[6] & p[5] & p[4] & p[3] & p[2] & g[1]) |
                  (p[6] & p[5] & p[4] & p[3] & p[2] & p[1] & g[0]) |
                  (p[6] & p[5] & p[4] & p[3] & p[2] & p[1] & p[0] & c[0]);

    assign c[8] = g[7] |
                  (p[7] & g[6]) |
                  (p[7] & p[6] & g[5]) |
                  (p[7] & p[6] & p[5] & g[4]) |
                  (p[7] & p[6] & p[5] & p[4] & g[3]) |
                  (p[7] & p[6] & p[5] & p[4] & p[3] & g[2]) |
                  (p[7] & p[6] & p[5] & p[4] & p[3] & p[2] & g[1]) |
                  (p[7] & p[6] & p[5] & p[4] & p[3] & p[2] & p[1] & g[0]) |
                  (p[7] & p[6] & p[5] & p[4] & p[3] & p[2] & p[1] & p[0] & c[0]);

    assign sum = p ^ c[7:0];
    assign cout = c[8];

endmodule


module cla_32 (
    input  [31:0] a,
    input  [31:0] b,
    input         cin,
    output [31:0] sum,
    output        cout
);

    wire [7:0] c_block;

    cla_8bit block0 (
        .a(a[7:0]),
        .b(b[7:0]),
        .cin(cin),
        .sum(sum[7:0]),
        .cout(c_block[0])
    );

    cla_8bit block1 (
        .a(a[15:8]),
        .b(b[15:8]),
        .cin(c_block[0]),
        .sum(sum[15:8]),
        .cout(c_block[1])
    );

    cla_8bit block2 (
        .a(a[23:16]),
        .b(b[23:16]),
        .cin(c_block[1]),
        .sum(sum[23:16]),
        .cout(c_block[2])
    );

    cla_8bit block3 (
        .a(a[31:24]),
        .b(b[31:24]),
        .cin(c_block[2]),
        .sum(sum[31:24]),
        .cout(c_block[3])
    );

    assign cout = c_block[3];

endmodule
