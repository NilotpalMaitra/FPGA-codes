//simulation code
module bm(p,a,b,clk);
  input [15:0]a,b;
  input clk;
  output reg [31:0]p;
  
  reg [31:0]ans;
  integer i,lookup,operate;
  initial begin
    p=31'b0;
    ans=31'b0;
  end
  always @(negedge clk)
    begin
      for(i=1;i<=15;i=i+2)
        begin
          if(i==0)
            lookup=0;
          else
            lookup=b[i-2];
          lookup=lookup+b[i]+2*b[i-1];
          if(lookup==0||lookup==7)
            operate=0;
          else if (lookup==3||lookup==4)
            operate=2;
          else
            operate=1;
          if(b[i]==1)
            operate=(-1)*operate;
          case(operate)
            1:begin
              ans=a;ans=ans<<(i-1);
              p=p+ans;
            end
            2:begin
              ans=a+1;
              ans=ans<<(i-1);
              p=p+ans;
            end
            -1:begin
              ans=(~a)+1;
              ans=ans<<(i-1);
              p=p+ans;
            end
            -2:begin
              ans=a<<1;
              ans=(~ans)+1;
              ans=ans<<(i-1);
              p=p+ans;
            end
          endcase
end
end
          endmodule
//testbench
module tb;
  reg [15:0]a,b;
  reg clk;
  wire [31:0]q;
  parameter st=400;
  bm dut(q,a,b,clk);
  
    always #5 clk=~clk;
  end
  initial begin
  
    a=16'd128,b=-16'd234;
    #10 a=-16'd1268;b=16'd234;
    #10 a=16'd587;b=16'd720;
    #10 a=-16'd128;b=-16'd671;
$stop();
  end
endmodule
