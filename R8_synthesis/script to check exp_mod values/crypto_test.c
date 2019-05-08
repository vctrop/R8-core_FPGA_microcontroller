#include <stdio.h>
#include <math.h>

long long calc_exp(int a, int q, int b)
{
    long long f = 1;
    int mask = 128;
    for(int i = 7; i >= 0; i--)
    {
        f = (f * f) % q;
		printf(": f = %d\n", f);
        if((b & mask) != 0)
        {
            f = (f * a) % q;
			
        }
        mask >>= 1;
		printf("f = %d\n", f);
    }
    printf("%d\t%d\n", b, f);
}





int main()
{
    int a = 6, q = 251;
	printf("Usando a = %d e q = %d\n", a, q);

	calc_exp(a, q, 250);
		
	for(int i = -7; i < 0; i++)
	{
		printf("%d mod 3 = %d\n", i, (i % -3));
	}

}
