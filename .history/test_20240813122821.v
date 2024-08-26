module top_module (
    input [4:0] a, b, c, d, e, f,
    output [7:0] w, x, y, z );//

    assign { a[4:0],b[4:0],c[4:0],d[4:0],e[4:0],f[4:0],2'b11} = { w[4:0],x[4:0],y[4:0],z[4:0] };

endmodule
