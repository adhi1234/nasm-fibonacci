build:
	nasm -f elf64 fib.asm
	gcc -o fib fib.o
test:
	echo Test Placeholder
	false
clean:
	rm fib.o fib
