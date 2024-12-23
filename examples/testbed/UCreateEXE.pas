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

unit UCreateEXE;

interface

/// <summary>
/// Demonstrates creating an executable using the script engine by compiling multiple source files,
/// including object files, and saving the output as an executable.
/// </summary>
procedure CreateEXE();

implementation

uses
  System.SysUtils,
  CScript;

/// <summary>
/// Error handling procedure for the script engine, logging error messages to the console
/// for tracking any issues encountered during the compilation or execution process.
/// </summary>
/// <param name="ASender">
/// Pointer to the object that raised the error event, typically the script engine instance.
/// </param>
/// <param name="AText">
/// The error message text generated by the script engine.
/// </param>
procedure CScriptErrorEvent(const ASender: Pointer; const AText: string);
begin
  WriteLn(AText);
end;

/// <summary>
/// Creates an executable by configuring paths, adding required object and source files,
/// and compiling them within the script engine. Saves the output as an executable file.
/// </summary>
procedure CreateEXE();
var
  /// <summary>
  /// Instance of <c>TCScript</c>, representing the script engine responsible for compiling
  /// and linking files into an executable output.
  /// </summary>
  LCScript: TCScript;
begin
  // Instantiate the script engine.
  LCScript := TCScript.Create();
  try
    /// <summary>
    /// Sets the error handler for the script engine, assigning CScriptErrorEvent to handle
    /// any errors that occur during compilation and outputting them to the console.
    /// </summary>
    LCScript.SetErrorHandler(nil, CScriptErrorEvent);

    /// <summary>
    /// Configures the output type of the script engine to csEXE, indicating the output
    /// should be an executable file.
    /// </summary>
    LCScript.SetOutputType(csEXE);

    /// <summary>
    /// Adds an include path ('res/include') to the script engine, enabling it to locate
    /// any necessary header files required during the compilation.
    /// </summary>
    LCScript.AddIncludePath('res/include');

    /// <summary>
    /// Adds a library path ('res/lib') to the script engine, specifying where to find
    /// any library files needed during the linking process.
    /// </summary>
    LCScript.AddLibraryPath('res/lib');

    /// <summary>
    /// Adds an object file ('../tools/resource.o') to the script engine to include precompiled
    /// resources or binary data within the final executable.
    /// </summary>
    LCScript.AddFile('../tools/resource.o');

    /// <summary>
    /// Adds the main source file ('res/src/raylib_basic_window.c') to the script engine.
    /// This source file contains the primary application code to be compiled.
    /// </summary>
    Writeln('Compiling "raylib_basic_window.c"...');
    LCScript.AddFile('res/src/raylib_basic_window.c');

    /// <summary>
    /// Attempts to save the compiled output as 'raylib_basic_window.exe'.
    /// </summary>
    /// <remarks>
    /// A success message is printed if the executable is created successfully,
    /// otherwise an error message is displayed.
    /// </remarks>
    if LCScript.SaveOutputFile('raylib_basic_window.exe') then
    begin
      Writeln('Created "raylib_basic_window.exe"');
      Writeln('Success!');
    end
    else
    begin
      Writeln('Failed!');
    end;
  finally
    /// <summary>
    /// Releases the TCScript instance, ensuring any resources allocated by the script engine
    /// are freed after execution completes.
    /// </summary>
    LCScript.Free();
  end;
end;

end.
