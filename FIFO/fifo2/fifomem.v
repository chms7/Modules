/*
 * @Design: fifomem 
 * @Author: chms 
 * @Email: cheems@foxmail.com
 * @Description: Memory Block of FIFO
 */

module fifomem #(
  parameter DSIZE = 8,
  parameter ASIZE = 4,
  parameter DEPTH = 1<<ASIZE
)(
  output [DSIZE-1:0] rdata,
  input  [DSIZE-1:0] wdata,
  input  [ASIZE-1:0] raddr,
  input  [ASIZE-1:0] waddr,
  input  wclken, wclk
);
  `ifdef VENDOR_RAM
    // * VENDOR_RAM
    vendor_ram u_mem(
      .dout     ( rdata  ),
      .din      ( wdata  ),
      .waddr    ( waddr  ),
      .raddr    ( raddr  ),
      .wclken   ( wclken ),
      .clk      ( wclk   )
    )
  `else
    // * VERILOG_RAM
    // reg
    reg [DSIZE-1:0] u_mem [0:DEPTH-1];
    // read
    assign rdata = u_mem[raddr];
    // write
    always @ (posedge wclk) begin
      if (wclken) u_mem[waddr] <= wdata;
    end
  `endif

endmodule