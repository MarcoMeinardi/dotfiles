return {
	s("pwnpwn", {
		t({"from pwn import *", "", ""}),

		t({"binary_name = \""}), i(1, "binary"), t({"\"", ""}),
		t({"exe  = ELF(binary_name, checksec=True)", ""}),
		t({"context.binary = exe", "", ""}),

		t({"ru  = lambda *x, **y: r.recvuntil(*x, **y)", ""}),
		t({"rl  = lambda *x, **y: r.recvline(*x, **y)", ""}),
		t({"rc  = lambda *x, **y: r.recv(*x, **y)", ""}),
		t({"sla = lambda *x, **y: r.sendlineafter(*x, **y)", ""}),
		t({"sa  = lambda *x, **y: r.sendafter(*x, **y)", ""}),
		t({"sl  = lambda *x, **y: r.sendline(*x, **y)", ""}),
		t({"sn  = lambda *x, **y: r.send(*x, **y)", "", ""}),

		t({"if args.REMOTE:", ""}),
		t({"	r = connect(\"\")", ""}),
		t({"elif args.GDB:", ""}),
		t({"	r = gdb.debug(f\"./{binary_name}\", \"\"\"", ""}),
		t({"		c", ""}),
		t({"	\"\"\", aslr=False)", ""}),
		t({"else:", ""}),
		t({"	r = process(f\"./{binary_name}\")", ""}),
		t({"", "" , ""}),
		i(2),
		t({"", "", "", ""}),
		t({"r.interactive()"}),
	}),

	s("angrangr", {
		t({"import angr", ""}),
		t({"import claripy", "", ""}),

		t({"find = []", ""}),
		t({"avoid = []", "", ""}),

		t({"filename = \""}), i(1, "binary"), t({"\"", ""}),
		t({"proj = angr.Project(filename, auto_load_libs=False)", "", ""}),

		t({"# chars = [claripy.BVS(f\"c{i}\", 8) for i in range(20)]", ""}),
		t({"# input_str = claripy.Concat(*chars, claripy.BVV(b\"\\n\"))", ""}),
		t({"# stdin_simfile = angr.SimFileStream(name=\"stdin\", content=input_str, has_end=True)", "", ""}),

		t({"# args = [filename]", "", ""}),

		t({"initial_state = proj.factory.entry_state(", ""}),
		t({"	# stdin=stdin_simfile,", ""}),
		t({"	# args=args,", ""}),
		t({"	# add_options={", ""}),
		t({"	# 	angr.options.ZERO_FILL_UNCONSTRAINED_REGISTERS,", ""}),
		t({"	# 	angr.options.ZERO_FILL_UNCONSTRAINED_MEMORY,", ""}),
		t({"	# }", ""}),
		t({")", "", ""}),

		t({"# for c in chars:", ""}),
		t({"# 	initial_state.solver.add(claripy.Or(c == 0x0, claripy.And(c >= 0x20, c <= 0x7e)))", "", "", ""}),


		t({"sim = proj.factory.simgr(initial_state)", ""}),
		t({"# sim.use_technique(angr.exploration_techniques.DFS())", "", "", ""}),


		t({"def success(state):", ""}),
		t({"	current_output = state.posix.dumps(1)", ""}),
		t({"	return b\"Good Job\" in current_output", "", "", ""}),


		t({"def failure(state):", ""}),
		t({"	current_output = state.posix.dumps(1)", ""}),
		t({"	return b\"Try again\" in current_output", "", "", ""}),


		t({"while sim.active:", ""}),
		t({"	# sim.explore(find=find, avoid=avoid, n=1)", ""}),
		t({"	sim.explore(find=success, avoid=failure, n=1)", ""}),
		t({"	print(sim)", "", ""}),

		t({"	if sim.found:", ""}),
		t({"		break", "", ""}),

		t({"assert sim.found, \"Cannot find\"", "", ""}),

		t({"print(\"-\" * 30)", ""}),
		t({"print(sim.found[0].posix.dumps(0))", ""}),
		t({"# for arg in args:", ""}),
		t({"# 	if not isinstance(arg, claripy.ast.bv.BV):", ""}),
		t({"# 		print(arg)", ""}),
		t({"# 	else:", ""}),
		t({"# 		val = sim.found[0].solver.eval(arg)", ""}),
		t({"# 		byte_len = (val.bit_length() + 7) // 8", ""}),
		t({"# 		print(val.to_bytes(byte_len, \"big\"))"})
	})
}
