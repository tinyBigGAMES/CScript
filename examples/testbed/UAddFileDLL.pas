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

unit UAddFileDLL;

interface

/// <summary>
/// Loads an external source file into the script engine for execution,
/// simulating a DLL (dynamic link library) scenario. This procedure configures the
/// script engine by setting up error handling, paths, and running the specified source file.
/// </summary>
procedure AddFileDLL();

implementation

uses
  System.SysUtils,
  CScript;

/// <summary>
/// Event handler for script errors. This procedure logs error messages that occur
/// during script execution, assisting with debugging and tracking issues.
/// </summary>
/// <param name="ASender">
/// Pointer to the object that raised the error event, usually the script engine instance.
/// </param>
/// <param name="AText">
/// The error message text as a string, providing details about the error encountered.
/// </param>
procedure CScriptErrorEvent(const ASender: Pointer; const AText: string);
begin
  WriteLn(AText);
end;

/// <summary>
/// Configures and runs the script engine to load and execute code from an external source file,
/// simulating DLL integration. This procedure sets up necessary paths, assigns error handling,
/// and executes the 'addfile_dll.c' source file.
/// </summary>
procedure AddFileDLL();
var
  /// <summary>
  /// Instance of TCScript, representing the script engine responsible for compiling and
  /// executing code loaded from external files in memory, simulating a DLL usage pattern.
/// </summary>
  LCScript: TCScript;
begin
  // Instantiate the script engine.
  LCScript := TCScript.Create();
  try
    /// <summary>
    /// Sets the error handler for the script engine, directing any errors to the
    /// CScriptErrorEvent procedure for logging or troubleshooting.
    /// </summary>
    LCScript.SetErrorHandler(nil, CScriptErrorEvent);

    /// <summary>
    /// Configures the script engine output type to csMEMORY, enabling in-memory management
    /// for efficient execution of compiled code.
    /// </summary>
    LCScript.SetOutputType(csMEMORY);

    /// <summary>
    /// Adds an include path ('res/include') to the script engine, allowing it to locate
    /// header files required during the compilation of the source file.
    /// </summary>
    LCScript.AddIncludePath('res/include');

    /// <summary>
    /// Adds a library path ('res/lib') to the script engine, enabling access to required
    /// library files that may be needed by the source file.
    /// </summary>
    LCScript.AddLibraryPath('res/lib');

    /// <summary>
    /// Loads a source file ('res/src/addfile_dll.c') into the script engine. This source file
    /// simulates a dynamic library that will be executed by the engine.
    /// </summary>
    LCScript.AddFile('res/src/addfile_dll.c');

    /// <summary>
    /// Executes the script engine, running the 'addfile_dll.c' file and performing
    /// any defined actions or functions within the source.
    /// </summary>
    LCScript.Run();
  finally
    /// <summary>
    /// Releases resources allocated for the TCScript instance, ensuring proper memory
    /// management after script execution is complete.
    /// </summary>
    LCScript.Free();
  end;
end;

end.

