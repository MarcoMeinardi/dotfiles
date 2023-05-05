import angr
# import claripy

find = []
avoid = []

filename = "{binary}"
proj = angr.Project(filename, auto_load_libs=False)

# input_str = claripy.BVS("input", 8 * 0x20)
# chars = input_str.chop(8)
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


def drop_useless(state):
	state.drop(stash="avoid")
	state.drop(stash="deadended")


def success(state):
	current_output = state.posix.dumps(1)
	return b"Good job" in current_output


def failure(state):
	current_output = state.posix.dumps(1)
	return b"Try again" in current_output


while sim.active:
	# sim.explore(find=find, avoid=avoid, n=1)  # , step_func=drop_useless)
	sim.explore(find=success, avoid=failure, n=1)  # , step_func=drop_useless)
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
# 		print(sim.found[0].solver.eval(arg, cast_to=bytes))
