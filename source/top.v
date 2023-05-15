module top(
    input             sys_clk       ,     // input system clock 50MHz
    output            rstn_out      ,

    output            iic_scl       ,
    inout             iic_sda       , 
    output            iic_tx_scl    ,
    inout             iic_tx_sda    , 
    input             pixclk_in     ,                            
    input             vs_in         , 
    input             hs_in         , 
    input             de_in         ,
    input     [7:0]   r_in          , 
    input     [7:0]   g_in          , 
    input     [7:0]   b_in          ,  

    output            pixclk_out    ,                            
    output            vs_out        , 
    output            hs_out        , 
    output            de_out        ,
    output    [7:0]   r_out         , 
    output    [7:0]   g_out         , 
    output    [7:0]   b_out         ,
    output            led_int       
);


wire  cfg_clk_10m               ;
wire  clk_locked                ; 
wire  clk_148m5                 ;

sys_pll the_instance_name (
  .clkin1(sys_clk),        // input
  .pll_lock(clk_locked),    // output
  .clkout0(clk_148m5),      // output
  .clkout1(cfg_clk_10m)       // output
);

hdmi_top hdmi_top_inst(
    .clk_148m5      (clk_148m5),
    .cfg_clk_10m    (cfg_clk_10m),
    .clk_locked     (clk_locked),
                    
    .rstn_out       (rstn_out),
                    
    .pixclk_out     (pixclk_out),                            
    .vs_out         (vs_out), 
    .hs_out         (hs_out), 
    .de_out         (de_out),
                    
    .r_out          (r_out), 
    .g_out          (g_out), 
    .b_out          (b_out),
                    
    .iic_scl        (iic_scl),
    .iic_sda        (iic_sda), 
    .iic_tx_scl     (iic_tx_scl),
    .iic_tx_sda     (iic_tx_sda), 
                    
    .led_int        (led_int)
);







endmodule