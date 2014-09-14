
//`#start header` -- edit after this line, do not edit this line
// ========================================
//
// Copyright noritan.org, 2014
// All Rights Reserved
// UNPUBLISHED, LICENSED SOFTWARE.
//
// CONFIDENTIAL AND PROPRIETARY INFORMATION
// WHICH IS THE PROPERTY OF NORITAN.ORG.
//
// ========================================
`include "cypress.v"
//`#end` -- edit above this line, do not edit this line
// Generated on 09/13/2014 at 14:22
// Component: Fifo4Ntan02
module Fifo4Ntan02 (
	output  empty,
	output  full,
	input   clock,
	input   reset
);

//`#start body` -- edit after this line, do not edit this line

// State code declaration
localparam      ST_STORE = 4'b0000;
localparam      ST_GET0  = 4'b1000;
localparam      ST_PUT0  = 4'b1001;
localparam      ST_GET1  = 4'b1010;
localparam      ST_PUT1  = 4'b1011;
localparam      ST_GET2  = 4'b1100;
localparam      ST_PUT2  = 4'b1101;
localparam      ST_GET3  = 4'b1110;
localparam      ST_PUT3  = 4'b1111;
localparam      ST_LOAD  = 4'b0100;

// Datapath function declaration
localparam      CS_IDLE = 3'b000;
localparam      CS_PULL = 3'b001;
localparam      CS_PUSH = 3'b010;

// Wire declaration
wire[3:0]       state;          // State code
wire            f0_not_empty;   // !Empty from datapath
wire            f0_empty;       // F0 is EMPTY
wire            f0_full;        // F0 is FULL

// Pseudo register
reg[2:0]        addr;           // Datapath function
reg             d0_load;        // FIFO access type
reg             f0_load;        // FIFO push

// State machine behavior
reg [3:0]       state_reg;
always @(posedge reset or posedge clock) begin
    if (reset) begin
                            state_reg <= ST_STORE;
    end else casez (state)
        ST_STORE:
            if (f0_full)    state_reg <= ST_GET0;
        ST_GET0:            state_reg <= ST_PUT0;
        ST_PUT0:            state_reg <= ST_GET1;
        ST_GET1:            state_reg <= ST_PUT1;
        ST_PUT1:            state_reg <= ST_GET2;
        ST_GET2:            state_reg <= ST_PUT2;
        ST_PUT2:            state_reg <= ST_GET3;
        ST_GET3:            state_reg <= ST_PUT3;
        ST_PUT3:            state_reg <= ST_LOAD;
        ST_LOAD:
            if (!f0_full)   state_reg <= ST_STORE;
        default:            state_reg <= ST_STORE;
    endcase
end
assign      state = state_reg;

// Internal control signals
always @(state) begin
    casez (state)
        ST_STORE: begin
            addr    = CS_IDLE;
            d0_load = 1'b1;     // external
            f0_load = 1'b0;
        end
        ST_GET0, ST_GET1, ST_GET2, ST_GET3: begin
            addr    = CS_PULL;
            d0_load = 1'b0;     // internal
            f0_load = 1'b0;
        end
        ST_PUT0, ST_PUT1, ST_PUT2, ST_PUT3: begin
            addr    = CS_PUSH;
            d0_load = 1'b0;     // internal
            f0_load = 1'b1;
        end
        ST_LOAD: begin
            addr    = CS_IDLE;
            d0_load = 1'b1;     // external
            f0_load = 1'b0;
        end
        /*ST_LOAD*/ default: begin
            addr    = CS_IDLE;
            d0_load = 1'b1;     // external
            f0_load = 1'b0;
        end
    endcase
end

cy_psoc3_dp8 #(.cy_dpconfig_a(
{
    `CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
    `CS_SHFT_OP_PASS, `CS_A0_SRC_NONE, `CS_A1_SRC_NONE,
    `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
    `CS_CMP_SEL_CFGA, /*CFGRAM0: IDLE*/
    `CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
    `CS_SHFT_OP_PASS, `CS_A0_SRC___F0, `CS_A1_SRC_NONE,
    `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
    `CS_CMP_SEL_CFGA, /*CFGRAM1: PULL*/
    `CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
    `CS_SHFT_OP___SL, `CS_A0_SRC_NONE, `CS_A1_SRC_NONE,
    `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
    `CS_CMP_SEL_CFGA, /*CFGRAM2: PUSH*/
    `CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
    `CS_SHFT_OP_PASS, `CS_A0_SRC_NONE, `CS_A1_SRC_NONE,
    `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
    `CS_CMP_SEL_CFGA, /*CFGRAM3:   Idle*/
    `CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
    `CS_SHFT_OP_PASS, `CS_A0_SRC_NONE, `CS_A1_SRC_NONE,
    `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
    `CS_CMP_SEL_CFGA, /*CFGRAM4:   Idle*/
    `CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
    `CS_SHFT_OP_PASS, `CS_A0_SRC_NONE, `CS_A1_SRC_NONE,
    `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
    `CS_CMP_SEL_CFGA, /*CFGRAM5:   Idle*/
    `CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
    `CS_SHFT_OP_PASS, `CS_A0_SRC_NONE, `CS_A1_SRC_NONE,
    `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
    `CS_CMP_SEL_CFGA, /*CFGRAM6:   Idle*/
    `CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
    `CS_SHFT_OP_PASS, `CS_A0_SRC_NONE, `CS_A1_SRC_NONE,
    `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
    `CS_CMP_SEL_CFGA, /*CFGRAM7:   Idle*/
    8'hFF, 8'hFF,  /*CFG9:  */
    8'hFF, 8'hFF,  /*CFG11-10:  */
    `SC_CMPB_A1_D1, `SC_CMPA_A1_D1, `SC_CI_B_ARITH,
    `SC_CI_A_ARITH, `SC_C1_MASK_DSBL, `SC_C0_MASK_DSBL,
    `SC_A_MASK_DSBL, `SC_DEF_SI_0, `SC_SI_B_DEFSI,
    `SC_SI_A_DEFSI, /*CFG13-12:  */
    `SC_A0_SRC_ACC, `SC_SHIFT_SL, 1'h0,
    1'h0, `SC_FIFO1_BUS, `SC_FIFO0_ALU,
    `SC_MSB_DSBL, `SC_MSB_BIT0, `SC_MSB_NOCHN,
    `SC_FB_NOCHN, `SC_CMP1_NOCHN,
    `SC_CMP0_NOCHN, /*CFG15-14:  */
    7'h00, `SC_FIFO0_DYN_ON,2'h00,
    `SC_FIFO_CLK__DP,`SC_FIFO_CAP_AX,`SC_FIFO_LEVEL,
    `SC_FIFO__SYNC /*CFG17-16:    */
,`SC_EXTCRC_DSBL,`SC_WRK16CAT_DSBL}
)) dp(
        /*  input                   */  .reset(reset),
        /*  input                   */  .clk(clock),
        /*  input   [02:00]         */  .cs_addr(addr),
        /*  input                   */  .route_si(1'b0),
        /*  input                   */  .route_ci(1'b0),
        /*  input                   */  .f0_load(f0_load),
        /*  input                   */  .f1_load(1'b0),
        /*  input                   */  .d0_load(d0_load),
        /*  input                   */  .d1_load(1'b0),
        /*  output                  */  .ce0(),
        /*  output                  */  .cl0(),
        /*  output                  */  .z0(),
        /*  output                  */  .ff0(),
        /*  output                  */  .ce1(),
        /*  output                  */  .cl1(),
        /*  output                  */  .z1(),
        /*  output                  */  .ff1(),
        /*  output                  */  .ov_msb(),
        /*  output                  */  .co_msb(),
        /*  output                  */  .cmsb(),
        /*  output                  */  .so(),
        /*  output                  */  .f0_bus_stat(f0_not_empty),
        /*  output                  */  .f0_blk_stat(f0_full),
        /*  output                  */  .f1_bus_stat(),
        /*  output                  */  .f1_blk_stat()
);

// Status flags from datapath
assign      f0_empty = !f0_not_empty;
assign      empty = f0_empty;
assign      full = f0_full;

//`#end` -- edit above this line, do not edit this line
endmodule
//`#start footer` -- edit after this line, do not edit this line
//`#end` -- edit above this line, do not edit this line



