add wave -position insertpoint  \
sim:/processor/clk \
sim:/processor/control_unit_signals_out_ex \
sim:/processor/data_memory \
sim:/processor/input_port \
sim:/processor/instruction \
sim:/processor/mem_res_me \
sim:/processor/mem_wb_result \
sim:/processor/mem_write_back \
sim:/processor/memory_src \
sim:/processor/out_port \
sim:/processor/pc_write \
sim:/processor/write_back_data_wb \
sim:/processor/write_back_me \
sim:/processor/write_back_out_wb \
sim:/processor/write_instruction
add wave -position insertpoint  \
sim:/processor/Rs \
sim:/processor/Rs_out_ex \
sim:/processor/alu_result_me \
sim:/processor/clk \
sim:/processor/control_unit_signals_out_ex \
sim:/processor/data_memory \
sim:/processor/de_input \
sim:/processor/de_out \
sim:/processor/decode_Rd_address_write_back \
sim:/processor/ex_mem_Rd \
sim:/processor/ex_mem_result \
sim:/processor/hlt \
sim:/processor/input_port \
sim:/processor/instruction \
sim:/processor/out_port \
sim:/processor/pc_write
mem load -i E:/arch/RISC_PROCESSOR/memory.mem /processor/m1/u0/ram
mem load -filltype value -filldata 0000000000000000 -fillradix symbolic /processor/m2/u0/ram(0)
mem load -filltype value -filldata 1111111111111111 -fillradix symbolic /processor/m2/u0/ram(1)
mem load -filltype value -filldata 1111111111100000 -fillradix symbolic /processor/m2/u0/ram(2)
force -freeze sim:/processor/clk 1 0, 0 {50 ps} -r 100
add wave -position insertpoint  \
sim:/processor/reset_signal
force -freeze sim:/processor/reset_signal 1 0
run
# ** Warning: NUMERIC_STD.">": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 0  Instance: /processor/ex
# ** Warning: NUMERIC_STD.">": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 0  Instance: /processor/ex
# ** Warning: NUMERIC_STD.">": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 0  Instance: /processor/ex
# ** Warning: NUMERIC_STD.">": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 0  Instance: /processor/ex
# ** Warning: NUMERIC_STD."=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 0  Instance: /processor/ex/u4/u4
# ** Warning: NUMERIC_STD."=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 0  Instance: /processor/ex/u4/u3
# ** Warning: NUMERIC_STD."=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 0  Instance: /processor/ex/u4/u2
# ** Warning: NUMERIC_STD."=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 0  Instance: /processor/ex/u4/u1
# ** Warning: NUMERIC_STD."=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 0  Instance: /processor/ex/u4/u0
# ** Warning: NUMERIC_STD.TO_INTEGER: metavalue detected, returning 0
#    Time: 0 ps  Iteration: 0  Instance: /processor/m2/u0
# ** Warning: NUMERIC_STD.TO_INTEGER: metavalue detected, returning 0
#    Time: 0 ps  Iteration: 0  Instance: /processor/m2/u0
# ** Warning: NUMERIC_STD.TO_INTEGER: metavalue detected, returning 0
#    Time: 0 ps  Iteration: 0  Instance: /processor/m1/u0
# ** Warning: NUMERIC_STD."=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 1  Instance: /processor/ex/u4/u4
# ** Warning: NUMERIC_STD."=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 1  Instance: /processor/ex/u4/u3
# ** Warning: NUMERIC_STD."=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 1  Instance: /processor/ex/u4/u0
# ** Warning: NUMERIC_STD."=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 2  Instance: /processor/ex/u4/u1
# ** Warning: NUMERIC_STD."=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 3  Instance: /processor/ex/u4/u1
run
# ** Warning: NUMERIC_STD.">": metavalue detected, returning FALSE
#    Time: 200 ps  Iteration: 1  Instance: /processor/ex
# ** Warning: NUMERIC_STD.">": metavalue detected, returning FALSE
#    Time: 200 ps  Iteration: 1  Instance: /processor/ex
# ** Warning: NUMERIC_STD.">": metavalue detected, returning FALSE
#    Time: 200 ps  Iteration: 1  Instance: /processor/ex
# ** Warning: NUMERIC_STD.">": metavalue detected, returning FALSE
#    Time: 200 ps  Iteration: 1  Instance: /processor/ex
# ** Warning: NUMERIC_STD.">": metavalue detected, returning FALSE
#    Time: 200 ps  Iteration: 3  Instance: /processor/ex
# ** Warning: NUMERIC_STD.">": metavalue detected, returning FALSE
#    Time: 200 ps  Iteration: 3  Instance: /processor/ex
# ** Warning: NUMERIC_STD.">": metavalue detected, returning FALSE
#    Time: 200 ps  Iteration: 3  Instance: /processor/ex
# ** Warning: NUMERIC_STD.">": metavalue detected, returning FALSE
#    Time: 200 ps  Iteration: 3  Instance: /processor/ex
# ** Warning: NUMERIC_STD.">": metavalue detected, returning FALSE
#    Time: 200 ps  Iteration: 5  Instance: /processor/ex
# ** Warning: NUMERIC_STD.">": metavalue detected, returning FALSE
#    Time: 200 ps  Iteration: 5  Instance: /processor/ex
force -freeze sim:/processor/input_port 1111111111111111 0
force -freeze sim:/processor/reset_signal 0 0
run