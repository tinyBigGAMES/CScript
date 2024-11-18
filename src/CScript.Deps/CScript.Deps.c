/****************************************************************************
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
****************************************************************************/

__attribute__((section(".rdata"), used)) char* ID_CSCRIPT = "d76c88466074468b9111762b9833a502";

#define LIBTCCAPI __attribute__((visibility("default")))
#define TCC_TARGET_X86_64
#define TCC_TARGET_PE
#include "..\vendor\tcc\libtcc.c"








