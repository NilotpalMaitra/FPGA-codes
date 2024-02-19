//better simulation code 


module ArrayMultiplier(
  input [7:0] A,
  input [7:0] B,
  output [15:0] P
);

  // Declare partial products and final product
  reg [7:0] pp [7:0];
  reg [15:0] P;

  // Generate partial products for each bit of A
  generate
    genvar i;
    for (i = 0; i < 8; i = i + 1) begin
      pp[i] = A[i] * B;
    end
  endgenerate

  // Add partial products with appropriate shifts
  always @(posedge clk) begin
    P = 0;
    for (i = 0; i < 8; i = i + 1) begin
      P = P + (pp[i] << i);
    end
  end

endmodule


// simulation code

module half_adder(input a, b, output s0, c0);
  assign s0 = a ^ b;
  assign c0 = a & b;
endmodule

module full_adder(input a, b, cin, output s0, c0);
  assign s0 = a ^ b ^ cin;
  assign c0 = (a & b) | (b & cin) | (a & cin);
endmodule

module array_multiply(A,B,Z);
        input    [3:0] A,B;
        output [7:0] Z;
        
        wire [5:0] sum;
        wire [10:0] carry;
        wire p[3:0][3:0];
        genvar i;
        
        generate
            for(i=0;i<4;i=i+1) begin
                and a1(p[i][0],A[i],B[0]);
                and a2(p[i][1],A[i],B[1]);
                and a3(p[i][2],A[i],B[2]);
                and a4(p[i][3],A[i],B[3]);
            end
       endgenerate
        
        assign Z[0] = p[0][0];
        
        //starting row
        half_adder h1(p[0][1],p[1][0],Z[1],carry[0]);
        half_adder h2(p[1][1],p[2][0],sum[0],carry[1]);
        half_adder h3(p[2][1],p[3][0],sum[1],carry[2]);        
        
        //second row
        full_adder fa1(sum[0],p[0][2],carry[0],Z[2],carry[3]);
        full_adder fa2(sum[1],p[1][2],carry[1],sum[2],carry[4]);
        full_adder fa3(p[3][1],p[2][2],carry[2],sum[3],carry[5]);
        
        //third row
        full_adder fa4(sum[2],p[0][3],carry[3],Z[3],carry[6]);
        full_adder fa5(sum[3],p[1][3],carry[4],sum[4],carry[7]);
        full_adder fa6(p[3][2],p[2][3],carry[5],sum[5],carry[8]);
        
        //fourth row
         half_adder h4(sum[4],carry[6],Z[4],carry[9]);
         full_adder fa7(sum[5],carry[9],carry[7],Z[5],carry[10]);
         full_adder fa9(p[3][3],carry[8],carry[10],Z[6],Z[7]);       
        
endmodule

//testbench code 

module TB;
  reg [3:0] A, B;
  wire [7:0] P;
  
  array_multiply am(A,B,P);
  
  initial begin
    A = 1; B = 0; #3;
    A = 7; B = 5; #3;
    A = 8; B = 9; #3;
    A = 4'hf; B = 4'hf;
    $stop();
  end
endmodule

