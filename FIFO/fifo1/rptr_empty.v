/*
 * @Design: rptr_empty 
 * @Author: chms 
 * @Email: cheems@foxmail.com
 * @Description: Generate read-ptr and empty flag
 */

module rptr_empty #(
  parameter ASIZE = 4
)(
  output             rempty,
  output [ASIZE-1:0] raddr,
  output [ASIZE  :0] rptr,
  input  [ASIZE  :0] rq2_wptr,
  input              rinc, rclk, rrst_n
);
  reg  rempty;
  reg  [ASIZE:0] rbin, rgray;
  wire [ASIZE:0] rbin_next, rgray_next;

  // * Binary & Gray Pointer Counter
  always @ (posedge rclk or negedge rrst_n) begin
    if (!rrst_n) {rbin, rgray} <= '0;
    else         {rbin, rgray} <= {rbin_next, rgray_next};
  end
  assign rbin_next  = rinc & ~rempty ? rbin + 1 : rbin;
  assign rgray_next = (rbin_next >> 1 ) ^ rbin_next;
  
  // n-1 bits binary code to address
  assign raddr = rbin[ASIZE-1:0];
  // n   bits gray   code to synchronize
  assign rptr  = rgray[ASIZE:0];

  // * rempty
  assign rempty_cond = rgray_next == rq2_wptr;
  always @ (posedge rclk or negedge rrst_n) begin
    if (!rrst_n) rempty <= 1'b0;
    else         rempty <= rempty_cond;
  end

endmodule