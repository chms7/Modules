/*
 * @Design: rptr_empty 
 * @Author: chms 
 * @Email: cheems@foxmail.com
 * @Description: Generate read-ptr, synchronize asynchronized empty flag
 */

module rptr_empty #(
  parameter ASIZE = 4
)(
  output             rempty,
  output [ASIZE-1:0] rptr,
  input              aempty_n,
  input              rinc, rclk, rrst_n
);
  reg  rempty, rempty2;
  reg  [ASIZE-1:0] rbin,      rgray;
  wire [ASIZE-1:0] rbin_next, rgray_next;

  // * binary & gray pointer counter
  always @ (posedge rclk or negedge rrst_n) begin
    if (!rrst_n) {rbin, rgray} <= 0;
    else         {rbin, rgray} <= {rbin_next, rgray_next};
  end
  assign rbin_next  = rinc & ~rempty ? rbin + 1 : rbin;
  assign rgray_next = (rbin_next >> 1 ) ^ rbin_next;

  // * rempty: asyncronized empty
  always @ (posedge rclk or negedge aempty_n) begin
    if (!aempty_n) {rempty, rempty2} <= 2'b11; // rrst_n -> rempty
    else           {rempty, rempty2} <= {rempty2, ~aempty_n};
  end

endmodule