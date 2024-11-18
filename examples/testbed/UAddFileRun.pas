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

unit UAddFileRun;

interface

/// <summary>
/// Demonstrates adding an external file to the script engine and executing it.
/// This method illustrates setting up the script environment, configuring paths,
/// and running a source file directly within the script engine.
/// </summary>
procedure AddFileRun();

implementation

uses
  System.SysUtils,
  CScript;

/// <summary>
/// Event handler for capturing script error messages. This procedure logs
/// error messages that occur during script execution, allowing for debugging and error tracking.
/// </summary>
/// <param name="ASender">
/// A pointer to the instance that triggered the event, typically the script engine.
/// </param>
/// <param name="AText">
/// The error message text as a string, containing details of the error encountered.
/// </param>
procedure CScriptErrorEvent(const ASender: Pointer; const AText: string);
begin
  WriteLn(AText);
end;

/// <summary>
/// Adds a file to the script engine for execution. Configures the engine by setting error handling,
/// defining output type, and specifying include and library paths. The function then runs the
/// specified source file.
/// </summary>
procedure AddFileRun();
var
  /// <summary>
  /// Instance of TCScript, representing the script engine. Used to compile and
  /// execute code loaded from external files.
/// </summary>
  LCScript: TCScript;
begin
  // Instantiate the script engine.
  LCScript := TCScript.Create();
  try
    /// <summary>
    /// Sets the error handler for the script engine, directing any errors to the
    /// CScriptErrorEvent procedure for logging or troubleshooting purposes.
    /// </summary>
    LCScript.SetErrorHandler(nil, CScriptErrorEvent);

    /// <summary>
    /// Configures the output type of the script engine to csMEMORY, specifying
    /// that all generated output is stored in memory for efficient management.
    /// </summary>
    LCScript.SetOutputType(csMEMORY);

    /// <summary>
    /// Adds an include path ('res/include') to the script engine. This path is used for locating
    /// any header files that may be required during compilation.
    /// </summary>
    LCScript.AddIncludePath('res/include');

    /// <summary>
    /// Adds a library path ('res/lib') to the script engine, enabling it to locate required
    /// library files during the execution process.
    /// </summary>
    LCScript.AddLibraryPath('res/lib');

    /// <summary>
    /// Adds a source file ('res/src/test01.c') to the script engine for execution. This source file
    /// will be compiled and run within the script engine environment.
    /// </summary>
    LCScript.AddFile('res/src/test01.c');

    /// <summary>
    /// Executes the script engine, running the added file ('test01.c') and
    /// performing any actions defined within the file.
    /// </summary>
    LCScript.Run();
  finally
    /// <summary>
    /// Releases resources used by the TCScript instance, ensuring that any memory allocated
    /// for the script engine is freed once the execution completes.
    /// </summary>
    LCScript.Free();
  end;
end;

end.

