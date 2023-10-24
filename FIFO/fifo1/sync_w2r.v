/*
 * @Design: sync_w2r 
 * @Author: chms 
 * @Email: cheems@foxmail.com
 * @Description: Synchronize wptr to read clock domain
 */

module sync_w2r #(
  parameter ASIZE = 4
)(
  output [ASIZE:0] rq2_wptr,
  input  [ASIZE:0] wptr,
  input  rclk, rrst_n
);
  reg [ASIZE:0] rq1_wptr, rq2_wptr;

  // * Shift Reg
  always @ (posedge rclk or negedge rrst_n) begin
    if (!rrst_n) {rq2_wptr, rq1_wptr} <= '0;
    else         {rq2_wptr, rq1_wptr} <= {rq1_wptr, wptr};
  end

endmodule