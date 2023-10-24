/*
 * @Design: wptr_full 
 * @Author: chms 
 * @Email: cheems@foxmail.com
 * @Description: Generate write-ptr and full flag
 */

module wptr_full #(
  parameter ASIZE = 4
)(
  output [ASIZE-1:0] waddr,
  output [ASIZE  :0] wptr,
  output             wfull,
  input  [ASIZE  :0] wq2_rptr,
  input              winc, wclk, wrst_n
);
  reg  wfull;
  reg  [ASIZE:0] wbin, wgray;
  wire [ASIZE:0] wbin_next, wgray_next;

  // * Binary & Gray Pointer Counter
  always @ (posedge wclk or negedge wrst_n) begin
    if (!wrst_n) {wbin, wgray} <= '0;
    else         {wbin, wgray} <= {wbin_next, wgray_next};
  end
  assign rbin_next  = winc & ~wfull ? wbin + 1 : wbin;
  assign rgray_next = (wbin_next >> 1 ) ^ wbin_next;
  
  // n-1 bits binary code to address
  assign waddr = wbin[ASIZE-1:0];
  // n   bits gray   code to synchronize
  assign wptr  = wgray[ASIZE:0];

  // * wfull
  assign wfull_cond = (wgray_next[ASIZE    ] != wq2_rptr[ASIZE    ]) &&
                      (wgray_next[ASIZE-1  ] != wq2_rptr[ASIZE-1  ]) &&
                      (wgray_next[ASIZE-2:0] != wq2_rptr[ASIZE-2:0]);
  always @ (posedge wclk or negedge wrst_n) begin
    if (!wrst_n) wfull <= 1'b0;
    else         wfull <= wfull_cond;
  end

endmodule