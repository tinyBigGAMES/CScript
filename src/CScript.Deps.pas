{==============================================================================
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
==============================================================================}

unit CScript.Deps;

{$I CScript.Defines.inc}

interface

const
  TCC_OUTPUT_MEMORY = 1;
  TCC_OUTPUT_EXE = 2;
  TCC_OUTPUT_DLL = 4;
  TCC_OUTPUT_OBJ = 3;
  TCC_OUTPUT_PREPROCESS = 5;

type
  // Forward declarations
  PPUTF8Char = ^PUTF8Char;

  PTCCReallocFunc = function(ptr: Pointer; size: Longword): Pointer; cdecl;
  PTCCState = Pointer;
  PPTCCState = ^PTCCState;

  PTCCErrorFunc = procedure(opaque: Pointer; const msg: PUTF8Char); cdecl;
  PTCCBtFunc = function(udata: Pointer; pc: Pointer; const &file: PUTF8Char; line: Integer; const func: PUTF8Char; const msg: PUTF8Char): Integer; cdecl;

procedure tcc_set_realloc(my_realloc: PTCCReallocFunc); cdecl; external;
function  tcc_new(): PTCCState; cdecl; external;
procedure tcc_delete(s: PTCCState); cdecl; external;
procedure tcc_set_lib_path(s: PTCCState; const path: PUTF8Char); cdecl; external;
procedure tcc_set_error_func(s: PTCCState; error_opaque: Pointer; error_func: PTCCErrorFunc); cdecl; external;
function  tcc_set_options(s: PTCCState; const str: PUTF8Char): Integer; cdecl; external;
function  tcc_add_include_path(s: PTCCState; const pathname: PUTF8Char): Integer; cdecl; external;
function  tcc_add_sysinclude_path(s: PTCCState; const pathname: PUTF8Char): Integer; cdecl; external;
procedure tcc_define_symbol(s: PTCCState; const sym: PUTF8Char; const value: PUTF8Char); cdecl; external;
procedure tcc_undefine_symbol(s: PTCCState; const sym: PUTF8Char); cdecl; external;
function  tcc_add_file(s: PTCCState; const filename: PUTF8Char): Integer; cdecl; external;
function  tcc_compile_string(s: PTCCState; const buf: PUTF8Char): Integer; cdecl; external;
function  tcc_set_output_type(s: PTCCState; output_type: Integer): Integer; cdecl; external;
function  tcc_add_library_path(s: PTCCState; const pathname: PUTF8Char): Integer; cdecl; external;
function  tcc_add_library(s: PTCCState; const libraryname: PUTF8Char): Integer; cdecl; external;
function  tcc_add_symbol(s: PTCCState; const name: PUTF8Char; const val: Pointer): Integer; cdecl; external;
function  tcc_output_file(s: PTCCState; const filename: PUTF8Char): Integer; cdecl; external;
function  tcc_run(s: PTCCState; argc: Integer; argv: PPUTF8Char): Integer; cdecl; external;
function  tcc_relocate(s1: PTCCState): Integer; cdecl; external;
function  tcc_get_symbol(s: PTCCState; const name: PUTF8Char): Pointer; cdecl; external;
type
  tcc_list_symbols_symbol_cb = procedure(ctx: Pointer; const name: PUTF8Char; const val: Pointer); cdecl;

procedure tcc_list_symbols(s: PTCCState; ctx: Pointer; symbol_cb: tcc_list_symbols_symbol_cb); cdecl; external;
function  _tcc_setjmp(s1: PTCCState; jmp_buf: Pointer; top_func: Pointer; longjmp: Pointer): Pointer; cdecl; external;
procedure tcc_set_backtrace_func(s1: PTCCState; userdata: Pointer; p3: PTCCBtFunc); cdecl; external;

implementation

uses
  WinApi.Windows,
  CScript.Deps.CRuntime;

procedure system; cdecl; external ucrt;

{$L CScript.Deps.o}
{$R CScript.Deps.res}

end.
