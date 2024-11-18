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

#include <windows.h>

void hello_func (void);
__declspec(dllimport) extern const char *hello_data;

int WINAPI WinMain(
    HINSTANCE hInstance,
    HINSTANCE hPrevInstance,
    LPSTR     lpCmdLine,
    int       nCmdShow)
{
    hello_data = "Hello World!";
    hello_func();
    return 0;
}
