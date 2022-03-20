//global
`define zero 32'b0

//alu-control
`define addu_alu 4'b0000
`define subu_alu 4'b0001
`define and_alu 4'b0010
`define or_alu 4'b0011
`define shift16 4'b0100

//alu-control-judge
`define equal 4'b1111

//dm

//ext
`define sign_ext 4'b0000
`define zero_ext 4'b0001


//npc-control
`define pc4_npc 4'b0000
`define beq_npc 4'b0001
`define j_npc 4'b0010
`define jal_npc 4'b0011
`define jr_npc 4'b0100

//mux_control
`define mux_grf_alu 4'b0000
`define mux_grf_dm 4'b0001
`define mux_grf_pc 4'b0010

`define mux_grf_rt 4'b0000
`define mux_grf_rd 4'b0001

`define mux_alu_grf 4'b0000
`define mux_alu_imme32 4'b0001

//control
`define r_format 6'b000000
`define addu 6'b100001
`define subu 6'b100011
`define jr 6'b001000

`define ori 6'b001101
`define lui 6'b001111
`define lw 6'b100011
`define sw 6'b101011
`define beq 6'b000100
`define j 6'b000010
`define jal 6'b000011
