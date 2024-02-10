//simulation code 
module dff(
    input d,clk,reset,
    output reg q,qb
    );
    
    always @(negedge clk) begin
        if(reset==1) begin
            q<=0;
            qb<=1;
        end
        else
            q<=d;
            qb<=~d;
    end
endmodule

module siso_reg(
    input i,clk,rst,
    output [5:0]q
    );
    wire [5:0]qb;
    dff f1(i,clk,rst,q[5],qb[5]);
    dff f2(q[5],clk,rst,q[4],qb[4]);
    dff f3(q[4],clk,rst,q[3],qb[3]);
    dff f4(q[3],clk,rst,q[2],qb[2]);
    dff f5(q[2],clk,rst,q[1],qb[1]);
    dff f6(q[1],clk,rst,q[0],qb[0]);
endmodule  

module seq_gen(
    input i,clk,rst,
    output [5:0]a
    );
    wire [5:0]b;
    siso_reg r1(i,clk,rst,b);
    siso_reg r2(b[0],clk,rst,a);
    
endmodule

//Testbench code 
module tb;
reg i,clk,rst;
wire [5:0]a;

seq_gen s1(i,clk,rst,a);

always 
#5 clk=~clk;

initial begin
    clk=0;rst=1;i=0;#10
    rst=0;i=1;#10
    i=0;#10
    i=1;#10
    i=1;#10
    i=0;#10
    i=1;#10
    i=0;#60
    $stop();
end
endmodule
