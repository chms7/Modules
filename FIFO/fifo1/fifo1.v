/*
 * @Design: fifo1 
 * @Author: chms 
 * @Email:  cheems@foxmail.com
 * @Description: Top wrapper of FIFO
 */
module fifo1 #(
  parameter DSIZE = 8,
  parameter ASIZE = 4
)(
  output [DSIZE-1:0]  rdata,
  output              rempty,
  output              wfull,
  input  [DSIZE-1:0]  wdata,
  input               winc,
  input               wclk,
  input               wrst_n,
  input               rinc,
  input               rclk,
  input               rrst_n
);
  wire [ASIZE-1:0] raddr, waddr;
  wire [ASIZE  :0] rptr, wptr, rq2_wptr, wq2_rptr;
  wire rempty, wfull;

  fifomem #(DSIZE, ASIZE) u_fifomem(
    .rdata    ( rdata ),
    .wdata    ( wdata ),
    .raddr    ( raddr ),
    .waddr    ( waddr ),
    .wclken   ( winc  ),
    .wfull    ( wfull ),
    .wclk     ( wclk  )
  );

  rptr_empty #(ASIZE) u_rptr_empty(
    .rempty   ( rempty   ),
    .rptr     ( rptr     ),
    .raddr    ( raddr    ),
    .rq2_wptr ( rq2_wptr ),
    .rinc     ( rinc     ),
    .rclk     ( rclk     ),
    .rrst_n   ( rrst_n   )
  );

  wptr_full #(ASIZE) u_wptr_full(
    .wfull    ( wfull    ),
    .wptr     ( wptr     ),
    .waddr    ( waddr    ),
    .wq2_rptr ( wq2_rptr ),
    .winc     ( winc     ),
    .wclk     ( wclk     ),
    .wrst_n   ( wrst_n   )
  );

  sync_r2w #(ASIZE) u_sync_r2w(
    .wq2_rptr ( wq2_rptr ),
    .rptr     ( rptr     ),
    .wclk     ( wclk     ),
    .wrst_n   ( wrst_n   )
  );

  sync_w2r #(ASIZE) u_sync_w2r(
    .rq2_wptr ( rq2_wptr ),
    .wptr     ( wptr     ),
    .rclk     ( rclk     ),
    .rrst_n   ( rrst_n   )
  );

endmodule