import angr
# import claripy

find = []
avoid = []

filename = "{binary}"
proj = angr.Project(filename, auto_load_libs=False)

# chars = [claripy.BVS(f"c{{i}}", 8) for i in range(20)]
# input_str = claripy.Concat(*chars, claripy.BVV(b"\n"))
# stdin_simfile = angr.SimFileStream(name="stdin", content=input_str, has_end=True)

# args = [filename]

initial_state = proj.factory.entry_state(
	# stdin=stdin_simfile,
	# args=args,
	# add_options={{
	# 	angr.options.ZERO_FILL_UNCONSTRAINED_REGISTERS,
	# 	angr.options.ZERO_FILL_UNCONSTRAINED_MEMORY,
	# }}
)

# for c in chars:
# 	initial_state.solver.add(claripy.Or(c == 0x0, claripy.And(c >= 0x20, c <= 0x7e)))


sim = proj.factory.simgr(initial_state)
# sim.use_technique(angr.exploration_techniques.DFS())


def success(state):
	current_output = state.posix.dumps(1)
	return b"Good Job" in current_output


def failure(state):
	current_output = state.posix.dumps(1)
	return b"Try again" in current_output


while sim.active:
	# sim.explore(find=find, avoid=avoid, n=1)
	sim.explore(find=success, avoid=failure, n=1)
	print(sim)

	if sim.found:
		break

assert sim.found, "Cannot find"

print("-" * 30)
print(sim.found[0].posix.dumps(0))
# for arg in args:
# 	if not isinstance(arg, claripy.ast.bv.BV):
# 		print(arg)
# 	else:
# 		val = sim.found[0].solver.eval(arg)
# 		byte_len = (val.bit_length() + 7) // 8
# 		print(val.to_bytes(byte_len, "big"))
