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

unit UCreateLIB;

interface

/// <summary>
/// Demonstrates creating a static library using the script engine by compiling
/// a specified source file and saving the output in library format.
/// </summary>
procedure CreateLIB();

implementation

uses
  System.SysUtils,
  CScript;

/// <summary>
/// Error handling procedure for script errors, logging any issues encountered
/// during the script execution process to the console.
/// </summary>
/// <param name="ASender">
/// Pointer to the object that triggered the error event, generally the script engine.
/// </param>
/// <param name="AText">
/// The error message as a string, detailing the nature of the error encountered.
/// </param>
procedure CScriptErrorEvent(const ASender: Pointer; const AText: string);
begin
  WriteLn(AText);
end;

/// <summary>
/// Creates a static library by compiling a source file and saving it as a library.
/// This procedure demonstrates setting up include paths, adding files, and saving
/// the final output in a format usable by other applications.
/// </summary>
procedure CreateLIB();
var
  /// <summary>
  /// Instance of <c>TCScript</c>, representing the script engine responsible
  /// for compiling source files and generating library outputs.
/// </summary>
  LCScript: TCScript;
begin
  // Instantiate the script engine.
  LCScript := TCScript.Create();
  try
    /// <summary>
    /// Sets the error handler for the script engine to log any errors encountered.
    /// </summary>
    LCScript.SetErrorHandler(nil, CScriptErrorEvent);

    /// <summary>
    /// Configures the script engine output type to csLIB, indicating that the output
    /// should be saved as a static library.
    /// </summary>
    LCScript.SetOutputType(csLIB);

    /// <summary>
    /// Adds an include path ('res/include') to the script engine for locating header
    /// files required during the compilation of the source file.
    /// </summary>
    LCScript.AddIncludePath('res/include');

    /// <summary>
    /// Adds a library path ('res/lib') to the script engine, specifying where library files
    /// should be saved or located during the process.
    /// </summary>
    LCScript.AddLibraryPath('res/lib');

    /// <summary>
    /// Adds a source file ('res/src/libminiaudio.c') to be compiled into the library.
    /// If the file is successfully added, the script engine proceeds to save the output.
    /// </summary>
    if LCScript.AddFile('res/src/libminiaudio.c') then
    begin
      /// <summary>
      /// Saves the compiled output as 'libminiaudio.a' within the 'res/lib' directory.
      /// </summary>
      /// <remarks>
      /// On successful creation of the library, a confirmation message is printed.
      /// If saving fails, an error message is displayed.
      /// </remarks>
      if LCScript.SaveOutputFile('res/lib/libminiaudio.a') then
      begin
        Writeln('Created "res/lib/libminiaudio.a"');
        Writeln('Success!');
      end
      else
        Writeln('Failed');
    end;
  finally
    /// <summary>
    /// Frees the TCScript instance, releasing resources allocated during the script execution.
    /// </summary>
    LCScript.Free();
  end;
end;

end.

