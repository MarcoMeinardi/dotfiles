import angr
import archinfo
# import claripy
# import ctypes
# import logging
# logging.getLogger("angr").setLevel(logging.DEBUG)
LE = archinfo.Endness.LE  # state.memory.store(addr, value, endness=LE)

find = []
avoid = []

filename = "{binary}"
proj = angr.Project(filename, auto_load_libs=False, main_opts={{"base_addr": 0}})

# input_str = claripy.BVS("input", 8 * 0x20)
# chars = input_str.chop(8)
# stdin_simfile = angr.SimFileStream(name="stdin", content=input_str, has_end=True)

# args = [filename]

initial_state = proj.factory.entry_state(
	# stdin=stdin_simfile,
	# args=args,
	add_options={{
		# angr.options.ZERO_FILL_UNCONSTRAINED_REGISTERS,
		# angr.options.ZERO_FILL_UNCONSTRAINED_MEMORY,
		angr.options.DOWNSIZE_Z3,
		angr.options.SIMPLIFY_CONSTRAINTS,
		angr.options.SIMPLIFY_EXPRS,
		# angr.options.LAZY_SOLVES,
		# angr.options.SUPPORT_FLOATING_POINT
	}}
)

# initial_state.memory.read_strategies = [angr.concretization_strategies.SimConcretizationStrategyRange(1 << 64)]
# initial_state.memory.write_strategies = [angr.concretization_strategies.SimConcretizationStrategyRange(1 << 64)]
# initial_state.solver._solver.timeout = 1 << 64

# for c in chars:
# 	initial_state.solver.add(claripy.Or(c == 0x0, claripy.And(c >= 0x20, c <= 0x7e)))
# 	initial_state.solver.add(c >= 0x20, c <= 0x7e)

# proj.hook(0x1337, angr.SIM_PROCEDURES["libc"]["puts"]())
# proj.hook_symbol("__isoc99_scanf", angr.SIM_PROCEDURES["stubs"]["Nop"]())
# proj.hook_symbol("atoi", angr.SIM_PROCEDURES["stubs"]["ReturnUnconstrained"]())
# for desc, v in state.solver.get_variables("api"): ...

# initial_state.globals["randind"] = 0
# class MyRand(angr.SimProcedure):
# 	def __init__(self, *args, **kwargs):
# 		super(MyRand, self).__init__(*args, **kwargs)
# 		self.glibc = ctypes.CDLL("libc.so.6")
# 		self.glibc.srand(0)
# 		self.rand_values = []

# 	def run(self):
# 		randind = self.state.globals["randind"]
# 		while len(self.rand_values) <= randind:
# 			self.rand_values.append(self.glibc.rand())
# 		self.state.globals["randind"] = randind + 1
# 		return self.rand_values[randind]

# class MyScanf(angr.SimProcedure):
# 	def run(self, fmt, val):
# 		bv = self.state.solver.BVS("inp", 8 * 0x8)
# 		self.state.globals["inp"] = bv
# 		self.state.memory.store(val, bv, endness=LE)
# 		return 1


sim = proj.factory.simgr(initial_state)
# sim.use_technique(angr.exploration_techniques.DFS())
# sim.use_technique(angr.exploration_techniques.manual_mergepoint.ManualMergepoint(0xdeadbeef))


def success(state):
	current_output = state.posix.dumps(1)
	return b"Good job" in current_output
	# state.solver.add(...)
	# return state.satisfiable()

def failure(state):
	current_output = state.posix.dumps(1)
	return b"Try again" in current_output

def drop_useless(state):
	state.drop(stash="avoid")
	state.drop(stash="deadended")
	state.drop(stash="unsat")


while sim.active:
	# sim.explore(find=find, avoid=avoid, n=1)  # , step_func=drop_useless)
	sim.explore(find=success, avoid=failure, n=1)  # , step_func=drop_useless)
	print(sim)
	# print(sim.active)

	if sim.found:
		break

# import IPython; IPython.embed()
assert sim.found, "Cannot find"

print("-" * 30)
print(sim.found[0].posix.dumps(0))
# for arg in args:
# 	if not isinstance(arg, claripy.ast.bv.BV):
# 		print(arg)
# 	else:
# 		print(sim.found[0].solver.eval(arg, cast_to=bytes))
