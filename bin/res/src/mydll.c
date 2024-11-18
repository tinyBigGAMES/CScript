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

__declspec(dllexport) const char *hello_data = "(not set)";

__declspec(dllexport) void hello_func (void)
{
    MessageBox (0, hello_data, "From DLL", MB_ICONINFORMATION);
}
