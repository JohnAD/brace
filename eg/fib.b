#!/lang/b
use b
int fib(int n)
	if n <= 1
		return 1
	 else
		return fib(n-1) + fib(n-2)
Main()
	Sayf("%d", fib(40))
