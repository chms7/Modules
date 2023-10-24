/*
 * @Design: async_cmp 
 * @Author: chms 
 * @Email: cheems@foxmail.com
 * @Description: Asynchronized compare rptr & wptr, generate asynchronized empty & full flag
 */

module async_cmp #(
  parameter ASIZE = 4
)(
  output aempty_n, afull_n,
  input  [ASIZE-1:0] rptr, wptr,
  input  wrst_n
);
  reg direction;

  wire dirset_n = ~((wptr[ASIZE-1]^rptr[ASIZE-2]) & wptr[ASIZE-2]^rptr[ASIZE-1]);
  wire dirclr_n = ~((~(wptr[ASIZE-1]^rptr[ASIZE-2]) & (wptr[ASIZE-2]^rptr[ASIZE-1])) |
                  ~wrst_n);
  always @ (negedge dirset_n or negedge dirclr_n) begin
    if (!dirclr_n) direction = 1'b0;
    else           direction = 1'b1;
  end

  assign aempty_n = ~(~direction && (rptr == wptr));
  assign afull_n  = ~( direction && (rptr == wptr));

endmodule