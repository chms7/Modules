/*
 * @Design: fifo2 
 * @Author: chms 
 * @Email: cheems@foxmail.com
 * @Description: Top wrapper of FIFO
 */

module fifo2 #(
  parameter DSIZE = 8,
  parameter ASIZE = 4
)(
  output [DSIZE-1:0]  rdata,
  output              rempty, wfull,
  input  [DSIZE-1:0]  wdata,
  input winc, wclk, wrst_n,
  input rinc, rclk, rrst_n
);
  wire [ASIZE-1:0] raddr, waddr;
  wire [ASIZE-1:0] rptr, wptr;
  wire rempty, wfull, aempty_n, afull_n;

  fifomem #(DSIZE, ASIZE) u_fifomem(
    .rdata    ( rdata ),
    .wdata    ( wdata ),
    .raddr    ( rptr  ),
    .waddr    ( wptr  ),
    .wclken   ( winc  ),
    .wclk     ( wclk  )
  );

  rptr_empty #(ASIZE) u_rptr_empty(
    .rempty   ( rempty   ),
    .rptr     ( rptr     ),
    .aempty_n ( aempty_n ),
    .rinc     ( rinc     ),
    .rclk     ( rclk     ),
    .rrst_n   ( rrst_n   )
  );

  wptr_full #(ASIZE) u_wptr_full(
    .wfull    ( wfull    ),
    .wptr     ( wptr     ),
    .afull_n  ( afull_n  ),
    .winc     ( winc     ),
    .wclk     ( wclk     ),
    .wrst_n   ( wrst_n   )
  );
  
  async_cmp #(ASIZE) u_async_cmp(
    .aempty_n ( aempty_n ),
    .afull_n  ( afull_n  ),
    .wptr     ( wptr     ),
    .rptr     ( rptr     ),
    .wrst_n   ( wrst_n   )
  );

endmodule