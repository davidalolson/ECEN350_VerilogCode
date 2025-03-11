module btn_debounce(
  input clk,
  input btn_in,
  output wire brn_status
  );

  reg [19:0] btn_shift;

  always@(posedge clk)
    btn_shift <= {btn_shift[18:0], btn_in};

  assign btn_status = &btn_shift;

endmodule
