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

unit UCompileString;

interface

/// <summary>
/// Compiles and executes a function defined in a string using the script engine.
/// Demonstrates loading necessary paths, setting up error handling, and compiling
/// source code provided as a string.
/// </summary>
procedure CompileString();

implementation

uses
  System.SysUtils,
  CScript;

/// <summary>
/// Event handler for handling script errors. This procedure captures and logs
/// error messages produced during script execution.
/// </summary>
/// <param name="ASender">
/// Pointer to the object that triggered the event, typically the script engine instance.
/// </param>
/// <param name="AText">
/// String containing the error message text associated with the error event.
/// </param>
procedure CScriptErrorEvent(const ASender: Pointer; const AText: string);
begin
  WriteLn(AText);
end;

/// <summary>
/// Compiles a function from a string in the script engine, allowing for dynamic compilation
/// and execution of source code defined directly within the code.
/// </summary>
procedure CompileString();
var
  /// <summary>
  /// Instance of TCScript, representing the script engine. Used to compile,
  /// link, and execute code from strings and external files.
/// </summary>
  LCScript: TCScript;

  /// <summary>
  /// Pointer to the 'mytest2' function, defined in the string. This procedure has no parameters
  /// and follows the cdecl calling convention.
/// </summary>
  LMyTest2: procedure; cdecl;
begin
  // Instantiate the script engine
  LCScript := TCScript.Create();
  try
    /// <summary>
    /// Sets the error handler for the script engine, directing any errors to the
    /// CScriptErrorEvent procedure for logging or debugging purposes.
    /// </summary>
    LCScript.SetErrorHandler(nil, CScriptErrorEvent);

    /// <summary>
    /// Configures the output type of the script engine to csMEMORY, which stores
    /// all output in memory, enabling efficient symbol retrieval and execution.
    /// </summary>
    LCScript.SetOutputType(csMEMORY);

    /// <summary>
    /// Adds an include path ('res/include') to the script engine for locating
    /// header or source files required during script compilation.
    /// </summary>
    LCScript.AddIncludePath('res/include');

    /// <summary>
    /// Adds a library path ('res/lib') to the script engine, allowing it to locate
    /// any libraries that may be required during compilation or execution.
    /// </summary>
    LCScript.AddLibraryPath('res/lib');

    /// <summary>
    /// Adds a source file ('res/src/test01.c') to the script engine for compilation.
    /// This allows the script engine to include additional code from external sources.
/// </summary>
    LCScript.AddFile('res/src/test01.c');

    /// <summary>
    /// Compiles a function from a string using the script engine. The function 'mytest2'
    /// is defined in the string and is subsequently available for execution if compilation is successful.
    /// </summary>
    LCScript.CompileString(
      '#include <stdio.h>' + sLineBreak +
      '' + sLineBreak +
      'void mytest2() {' + sLineBreak +
      '    printf("running mytest2 routine from a string\n");' + sLineBreak +
      '}'
    );

    /// <summary>
    /// Relocates the script engine, finalizing symbol addresses and preparing
    /// the compiled code for execution.
    /// </summary>
    LCScript.Relocate();

    /// <summary>
    /// Attempts to retrieve the function 'mytest2' from the script engine.
    /// If successfully retrieved, the function is executed, printing a message to the console.
    /// </summary>
    LMyTest2 := LCScript.GetSymbol('mytest2');
    if Assigned(LMyTest2) then
      LMyTest2();
  finally
    /// <summary>
    /// Releases the TCScript instance, freeing any resources associated
    /// with the script engine and ensuring proper memory management.
    /// </summary>
    LCScript.Free();
  end;
end;

end.
