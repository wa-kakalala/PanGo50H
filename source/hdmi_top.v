module hdmi_top#(
    //MODE_1080p
    parameter V_TOTAL = 12'd1125                  ,
    parameter V_FP = 12'd4                        ,
    parameter V_BP = 12'd36                       ,
    parameter V_SYNC = 12'd5                      ,
    parameter V_ACT = 12'd1080                    ,
    parameter H_TOTAL = 12'd2200                  ,
    parameter H_FP = 12'd88                       ,
    parameter H_BP = 12'd148                      ,
    parameter H_SYNC = 12'd44                     ,
    parameter H_ACT = 12'd1920                    ,
    parameter HV_OFFSET = 12'd0                   ,
    parameter X_WIDTH = 4'd12                     ,
    parameter Y_WIDTH = 4'd12                       
)(
    input                clk_148m5      ,
    input                cfg_clk_10m    ,
    input                clk_locked     ,

    output               rstn_out       ,

    output               pixclk_out     ,                            
    output               vs_out         , 
    output               hs_out         , 
    output               de_out         ,

    output     [7:0]  r_out             , 
    output     [7:0]  g_out             , 
    output     [7:0]  b_out             ,

    output               iic_scl        ,
    inout                iic_sda        , 
    output               iic_tx_scl     ,
    inout                iic_tx_sda     , 

    output               led_int

);

   wire                        hs         ;
   wire                        vs         ;
   wire                        de         ;
   wire [X_WIDTH - 1'b1:0]     act_x      ;
   wire [Y_WIDTH - 1'b1:0]     act_y      ;  
   reg  [15:0]                 rstn_1ms   ;  

   assign   pixclk_out = clk_148m5;


   ms72xx_ctl ms72xx_ctl(
        .clk         (  cfg_clk_10m    ), //input       clk,
        .rst_n       (  rstn_out       ), //input       rstn,
                                
        .init_over   (  init_over  ),   //output      init_over,
        .iic_tx_scl  (  iic_tx_scl ),   //output      iic_scl,
        .iic_tx_sda  (  iic_tx_sda ),   //inout       iic_sda
        .iic_scl     (  iic_scl    ),   //output      iic_scl,
        .iic_sda     (  iic_sda    )    //inout       iic_sda
   );
    assign    led_int    =     init_over;
    
    always @(posedge cfg_clk_10m)
    begin
    	if(!clk_locked)
    	    rstn_1ms <= 16'd0;
    	else
    	begin
    		if(rstn_1ms == 16'h2710)
    		    rstn_1ms <= rstn_1ms;
    		else
    		    rstn_1ms <= rstn_1ms + 1'b1;
    	end
    end
    
    assign rstn_out = (rstn_1ms == 16'h2710);

    sync_vg #(
        .X_BITS               (  X_WIDTH              ), 
        .Y_BITS               (  Y_WIDTH              ),
        .V_TOTAL              (  V_TOTAL              ),//                        
        .V_FP                 (  V_FP                 ),//                        
        .V_BP                 (  V_BP                 ),//                        
        .V_SYNC               (  V_SYNC               ),//                        
        .V_ACT                (  V_ACT                ),//                        
        .H_TOTAL              (  H_TOTAL              ),//                        
        .H_FP                 (  H_FP                 ),//                        
        .H_BP                 (  H_BP                 ),//                        
        .H_SYNC               (  H_SYNC               ),//                        
        .H_ACT                (  H_ACT                ) //                        
 
    ) sync_vg                                         
    (                                                 
        .clk                  (  clk_148m5            ),//input                   clk,                                 
        .rstn                 (  rstn_out             ),//input                   rstn,                            
        .vs_out               (  vs                   ),//output reg              vs_out,                                                                                                                                      
        .hs_out               (  hs                   ),//output reg              hs_out,            
        .de_out               (  de                   ),//output reg              de_out,             
        .x_act                (  act_x                ),//output reg [X_BITS-1:0] x_out,             
        .y_act                (  act_y                ) //output reg [Y_BITS:0]   y_out,             
    );

     pattern_vg #(
        .COCLOR_DEPP          (  8                    ), // Bits per channel
        .X_BITS               (  X_WIDTH              ),
        .Y_BITS               (  Y_WIDTH              ),
        .H_ACT                (  H_ACT                ),
        .V_ACT                (  V_ACT                )
        ) // Number of fractional bits for ramp pattern
     pattern_vg (
        .rstn                 (  rstn_out             ),//input                         rstn,                                                     
        .pix_clk              (  clk_148m5            ),//input                         clk_in,  
        .act_x                (  act_x                ),//input      [X_BITS-1:0]       x,   
        // input video timing
        .vs_in                (  vs                   ),//input                         vn_in                        
        .hs_in                (  hs                   ),//input                         hn_in,                           
        .de_in                (  de                   ),//input                         dn_in,
        // test pattern image output                                                    
        .vs_out               (  vs_out               ),//output reg                    vn_out,                       
        .hs_out               (  hs_out               ),//output reg                    hn_out,                       
        .de_out               (  de_out               ),//output reg                    den_out,                      
        .r_out                (  r_out                ),//output reg [COCLOR_DEPP-1:0]  r_out,                      
        .g_out                (  g_out                ),//output reg [COCLOR_DEPP-1:0]  g_out,                       
        .b_out                (  b_out                ) //output reg [COCLOR_DEPP-1:0]  b_out   
    );

endmodule