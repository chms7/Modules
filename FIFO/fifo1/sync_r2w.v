/*
 * @Design: sync_r2w 
 * @Author: chms 
 * @Email: cheems@foxmail.com
 * @Description: Synchronize rptr to write clock domain
 */

module sync_r2w #(
  parameter ASIZE = 4
)(
  output [ASIZE:0] wq2_rptr,
  input  [ASIZE:0] rptr,
  input  wclk, wrst_n
);
  reg [ASIZE:0] wq1_rptr, wq2_rptr;

  // * Shift Reg
  always @ (posedge wclk or negedge wrst_n) begin
    if (!wrst_n) {wq2_rptr, wq1_rptr} <= '0;
    else         {wq2_rptr, wq1_rptr} <= {wq1_rptr, rptr};
  end

endmodule