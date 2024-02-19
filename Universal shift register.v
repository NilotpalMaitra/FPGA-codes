//Simulation code 
module UniversalShiftRegister(
  input clk,
  input reset,
  input [1:0] mode,
  input [3:0] data_in,
  output [3:0] data_out
);

  // Shift register
  reg [3:0] data;

  // Always block for state update
  always @(posedge clk) begin
    if (reset) begin
      // Reset on active high reset
      data <= 4'b0000;
    end else begin
      case (mode)
        2'b00: // Locked mode
          data <= data;
        2'b01: // Right Shift
          data <= {data_in[0], data[3:1]};
        2'b10: // Left Shift
          data <= {data[2:0], data_in[0]};
        2'b11: // Parallel In Parallel Out
          data <= data_in;
      endcase
    end
  end

  // Assign output
  assign data_out = data;

endmodule
//testbench code 
module UniversalShiftRegister_tb;

  // Clock and reset signals
  reg clk = 0;
  reg reset = 1;

  // Mode and data input
  reg [1:0] mode;
  reg [3:0] data_in;

  // Output from the shift register
  wire [3:0] data_out;

  // Instantiate the unit under test
  UniversalShiftRegister UUT (clk, reset, mode, data_in, data_out);

  // Clock generation
  always #5 clk = ~clk;

  // Test sequence
  initial begin
    // Reset
    reset <= 1; #10;
    reset <= 0;

    // Parallel load
    mode <= 2'b11;
    data_in <= 4'b1011; #10;

    // Right shift
    mode <= 2'b01; #10; #10; #10;

    // Left shift
    mode <= 2'b10; #10; #10; #10;

    // Locked mode
    mode <= 2'b00; #10; #10; #10;

    // Parallel load again
    mode <= 2'b11;
    data_in <= 4'b0101; #10;

    // Right shift 3 times
    mode <= 2'b01; #10; #10; #10;

    // Finished
    $finish;
  end
