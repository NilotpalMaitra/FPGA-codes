//Simulation code 
module sequence_detector(
  input bit,clk,
  output reg,op,
  output reg[100]
);

  initial begin 

    r=2'b00;
  end 
  always@(posedge clk)begin 
    op=0
    case({S,bit})
      3'b01:S=2'b01;
      3'b01:
