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

unit UTestbed;

interface

/// <summary>
/// Initiates and executes a set of predefined tests for various CScript functionalities.
/// This procedure demonstrates the use of different script operations such as adding symbols,
/// compiling strings, running external files, creating executables and libraries, and using libraries.
/// </summary>
procedure RunTests();

implementation

uses
  System.SysUtils,
  CScript.Common,
  CScript,
  UAddSymbol,
  UAddFileDLL,
  UAddFileRun,
  UCompileString,
  UGetSymbol,
  UCreateEXE,
  UCreateLIB,
  UUseLIB;

/// <summary>
/// Executes a test case based on a predefined test number. The test cases include
/// loading and running files, adding symbols, compiling code from strings, and creating
/// both executables and libraries. Each test demonstrates a unique feature of the CScript library.
/// </summary>
procedure RunTests();
var
  /// <summary>
  /// Integer value representing the selected test case number.
/// </summary>
  LNum: Integer;
begin
  // Display the version of CScript in use
  Writeln('CScript v', CSCRIPT_FULL_VERSION);
  WriteLn;

  // Define the test case number to execute
  LNum := 01;

  /// <summary>
  /// Executes a specific procedure based on the value of <c>LNum</c>.
  /// Each case corresponds to a distinct CScript functionality.
  /// </summary>
  case LNum of
    01: AddFileRun();
    02: AddFileDLL();
    03: AddSymbol();
    04: CompileString();
    05: GetSymbol();
    06: CreateEXE();
    07: CreateLIB();
    08: UseLIB();
  else
    /// <summary>
    /// Outputs an error message if <c>LNum</c> does not match any valid test case number.
    /// </summary>
    Writeln('Invalid number: ', LNum);
  end;

  /// <summary>
  /// Pauses the execution at the end of the tests, allowing the user to review any console output.
  /// </summary>
  Pause();
end;

end.

