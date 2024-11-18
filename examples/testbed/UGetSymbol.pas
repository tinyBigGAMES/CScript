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

unit UGetSymbol;

interface

/// <summary>
/// Retrieves symbols from the script engine, including both function and variable references.
/// This method demonstrates how to load a library, configure include paths, set up error handling,
/// and retrieve function and variable symbols for execution.
/// </summary>
procedure GetSymbol();

implementation

uses
  System.SysUtils,
  CScript;

/// <summary>
/// Event handler for script error messages. This procedure is called whenever an error occurs
/// during the execution of a script, allowing you to handle errors appropriately.
/// </summary>
/// <param name="ASender">
/// A pointer to the object that is raising the event, typically the script engine instance.
/// </param>
/// <param name="AText">
/// A string representing the error message text associated with the error.
/// </param>
procedure CScriptErrorEvent(const ASender: Pointer; const AText: string);
begin
  WriteLn(AText);
end;

/// <summary>
/// Retrieves symbols from the script engine, including both function and variable references.
/// This method demonstrates how to load a library, include paths, set up error handling,
/// and retrieve function and variable symbols.
/// </summary>
procedure GetSymbol();
var
  /// <summary>
  /// Instance of the TCScript class, used to compile, load, and retrieve symbols
  /// from a compiled script or library.
  /// </summary>
  LCScript: TCScript;

  /// <summary>
  /// Pointer to a function retrieved from the script, named 'mytest'.
  /// This function accepts a PAnsiChar argument and follows the cdecl calling convention.
  /// </summary>
  LMyTest: procedure(s: PAnsiChar); cdecl;

  /// <summary>
  /// Pointer to an integer variable retrieved from the script, named 'myvar'.
  /// </summary>
  LMyVar: PInteger;
begin
  // Instantiate the script engine
  LCScript := TCScript.Create();
  try
    /// <summary>
    /// Assigns an error handler to the script engine. Any errors occurring in the script
    /// execution are forwarded to the specified CScriptErrorEvent handler.
    /// </summary>
    /// <param name="nil">
    /// Pointer to the user context; nil is passed here as no specific context is required.
    /// </param>
    /// <param name="CScriptErrorEvent">
    /// Pointer to the procedure handling errors, which logs error messages to the console.
    /// </param>
    LCScript.SetErrorHandler(nil, CScriptErrorEvent);

    /// <summary>
    /// Configures the output type of the script engine. Here, the output type is set to
    /// csMEMORY, indicating that the output will be managed in memory.
    /// </summary>
    LCScript.SetOutputType(csMEMORY);

    /// <summary>
    /// Adds an include path to the script engine for searching files.
    /// This path ('res/include') is used to locate header or source files.
    /// </summary>
    LCScript.AddIncludePath('res/include');

    /// <summary>
    /// Adds a library path to the script engine for locating library files.
    /// This path ('res/lib') enables the engine to find libraries required by the script.
    /// </summary>
    LCScript.AddLibraryPath('res/lib');

    /// <summary>
    /// Adds a specific library, 'test01', to the script engine, enabling access
    /// to its symbols and functions.
    /// </summary>
    LCScript.AddLibrary('test01');

    /// <summary>
    /// Relocates the script engine, preparing it to resolve symbols
    /// and complete its setup process for execution.
    /// </summary>
    LCScript.Relocate();

    /// <summary>
    /// Retrieves a variable symbol from the loaded script by name ('myvar'). If found,
    /// 'LMyVar' is assigned a pointer to this variable, allowing direct access to its value.
    /// </summary>
    /// <returns>
    /// Outputs the integer value of 'myvar' to the console if found.
    /// </returns>
    LMyVar := LCScript.GetSymbol('myvar');
    if LMyVar <> nil then
      WriteLn('myvar: ', LMyVar^);

    /// <summary>
    /// Retrieves a procedure symbol from the loaded script by name ('mytest'). If found,
    /// 'LMyTest' is assigned a pointer to this function, allowing it to be called directly.
    /// </summary>
    /// <returns>
    /// Executes the retrieved function 'mytest' with the argument 'this is a test'
    /// if 'LMyTest' is assigned successfully.
    /// </returns>
    LMyTest := LCScript.GetSymbol('mytest');
    if Assigned(LMyTest) then
      LMyTest('this is a test');
  finally
    /// <summary>
    /// Frees the instance of the TCScript class, releasing any allocated resources and
    /// memory associated with the script engine.
    /// </summary>
    LCScript.Free();
  end;
end;

end.
