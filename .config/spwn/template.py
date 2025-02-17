from pwn import *

binary_name = "{binary}"
exe  = ELF(binary_name, checksec=True)
libc = ELF("{libc}", checksec=False)
context.binary = exe

ru  = lambda *x, **y: r.recvuntil(*x, **y)
rl  = lambda *x, **y: r.recvline(*x, **y)
rc  = lambda *x, **y: r.recv(*x, **y)
rcn = lambda *x, **y: r.recvn(*x, **y)
sla = lambda *x, **y: r.sendlineafter(*x, **y)
sa  = lambda *x, **y: r.sendafter(*x, **y)
sl  = lambda *x, **y: r.sendline(*x, **y)
sn  = lambda *x, **y: r.send(*x, **y)

if args.REMOTE:
	r = connect("")
elif args.GDB:
	r = gdb.debug(f"{debug_dir}/{{binary_name}}", """
		c
	""", aslr=False)
else:
	r = process(f"{debug_dir}/{{binary_name}}")

{interactions}



r.interactive()
