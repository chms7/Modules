/*
 * @Design: wptr_full 
 * @Author: chms 
 * @Email: cheems@foxmail.com
 * @Description: Generate write-ptr, synchronize asynchronized full flag
 */

module wptr_full #(
  parameter ASIZE = 4
)(
  output             wfull,
  output [ASIZE-1:0] wptr,
  input              afull_n,
  input              winc, wclk, wrst_n
);
  reg  wfull, wfull2;
  reg  [ASIZE-1:0] wbin,      wgray;
  wire [ASIZE-1:0] wbin_next, wgray_next;

  // * binary & gray pointer counter
  always @ (posedge wclk or negedge wrst_n) begin
    if (!wrst_n) {wbin, wgray} <= 0;
    else         {wbin, wgray} <= {wbin_next, wgray_next};
  end
  assign rbin_next  = winc & ~wfull ? wbin + 1 : wbin;
  assign rgray_next = (wbin_next >> 1 ) ^ wbin_next;
  
  // * wfull: asyncronized full
  always @ (posedge wclk or negedge wrst_n or negedge afull_n) begin
    if      (!wrst_n ) {wfull, wfull2} <= 2'b00;
    else if (!afull_n) {wfull, wfull2} <= 2'b11;
    else               {wfull, wfull2} <= {wfull2, ~afull_n};
  end

endmodule