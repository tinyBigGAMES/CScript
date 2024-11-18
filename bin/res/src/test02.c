/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
                      ___  ___           _        _ ™
                     / __|/ __| __  _ _ (_) _ __ | |_
                    | (__ \__ \/ _|| '_|| || '_ \|  _|
                     \___||___/\__||_|  |_|| .__/ \__|
                                           |_|
                                           
                 Copyright © 2024-present tinyBigGAMES™ LLC
                          All Rights Reserved.

                    Website: https://tinybiggames.com
                    Email  : support@tinybiggames.com

                 See LICENSE file for license information
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

#include <stdio.h>

extern int add(int a, int b);

/* dynamically linked data needs 'dllimport' */
 //__attribute__((dllimport))
//extern const char hello[];

DLL_IMPORT_DATA const char hello[];

int fib(int n)
{
  if (n <= 2)
    return 1;
  else
    return fib(n-1) + fib(n-2);
}

int foo(int n)
{
  printf("%s\n", hello);
  printf("fib(%d) = %d\n", n, fib(n));
  printf("add(%d, %d) = %d\n", n, 2 * n, add(n, 2 * n));
  return 0;
}