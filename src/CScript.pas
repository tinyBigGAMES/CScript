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

unit CScript;

{$I CScript.Defines.inc}

interface

uses
  WinApi.Windows,
  System.Generics.Collections,
  System.SysUtils,
  System.IOUtils,
  System.StrUtils,
  System.Classes,
  CScript.Deps,
  CScript.Common;

/// <summary>
/// Major version of the CSCRIPT.
/// </summary>
/// <remarks>
/// This represents the main version number, typically updated for significant changes or milestones.
/// </remarks>
const
  CSCRIPT_MAJOR_VERSION = '0';

/// <summary>
/// Minor version of the CSCRIPT.
/// </summary>
/// <remarks>
/// This is incremented for smaller, incremental improvements or updates.
/// </remarks>
const
  CSCRIPT_MINOR_VERSION = '1';

/// <summary>
/// Patch version of the CSCRIPT.
/// </summary>
/// <remarks>
/// This number increases for bug fixes or minor improvements that do not affect major or minor versions.
/// </remarks>
const
  CSCRIPT_PATCH_VERSION = '0';

/// <summary>
/// Full version of the CSCRIPT, formatted as Major.Minor.Patch.
/// </summary>
/// <remarks>
/// This combines the major, minor, and patch versions into a single version string.
/// </remarks>
const
  CSCRIPT_FULL_VERSION = CSCRIPT_MAJOR_VERSION + '.' + CSCRIPT_MINOR_VERSION + '.' + CSCRIPT_PATCH_VERSION;

type
  /// <summary>
  /// Specifies the output type for the TCScript class, determining the output format of the script compilation.
  /// </summary>
  TCScriptOutputType = (csMEMORY, csLib, csEXE, csDLL);

  /// <summary>
  /// Defines the subsystem type for executable generation in TCScript.
  /// </summary>
  TCScriptExeSubsystem = (csCONSOLE, csGUI);

  /// <summary>
  /// Defines the type for the script error event handler, allowing custom handling of script errors.
  /// </summary>
  /// <param name="ASender">The sender object associated with the event.</param>
  /// <param name="AText">The text message describing the error.</param>
  TCScriptErrorEvent = procedure(const ASender: Pointer; const AText: string);

type
  /// <summary>
  /// TCScript provides functionality for compiling and managing script-based operations, including error handling,
  /// output type configuration, and additional script options such as version info and icons.
  /// </summary>
  TCScript = class(TBaseObject)
  private
    FState: PTCCState;
    FOutputType: TCScriptOutputType;
    FExeSubsystem: TCScriptExeSubsystem;
    FOutputTypeSet: Boolean;
    FExeSubsystemSet: Boolean;
    FRelocated: Boolean;
    FOnError: record
      Sender: Pointer;
      Handler: TCScriptErrorEvent;
    end;
    procedure ErrorHandler(const AText: string);
    procedure Startup();
    procedure Shutdown();

  public
    /// <summary>
    /// Initializes a new instance of TCScript.
    /// </summary>
    constructor Create(); override;

    /// <summary>
    /// Releases all resources associated with the TCScript instance.
    /// </summary>
    destructor Destroy(); override;

    /// <summary>
    /// Resets the TCScript instance to its initial state.
    /// </summary>
    procedure Reset();

    /// <summary>
    /// Sets a custom error handler for managing script errors.
    /// </summary>
    /// <param name="ASender">The object sending the error.</param>
    /// <param name="AHandler">The event handler to handle the error.</param>
    procedure SetErrorHandler(const ASender: Pointer; const AHandler: TCScriptErrorEvent);

    /// <summary>
    /// Retrieves the current error handler.
    /// </summary>
    /// <param name="ASender">The sender object of the error handler.</param>
    /// <param name="AHandler">The event handler for errors.</param>
    procedure GetErrorHandler(var ASender: Pointer; var AHandler: TCScriptErrorEvent);

    /// <summary>
    /// Adds a library path to the script for locating libraries during compilation.
    /// </summary>
    /// <param name="APath">The library path to add.</param>
    /// <returns>True if the path was added successfully; otherwise, False.</returns>
    function AddLibraryPath(const APath: string): Boolean;

    /// <summary>
    /// Adds an include path for locating header files during script compilation.
    /// </summary>
    /// <param name="APath">The include path to add.</param>
    /// <returns>True if the path was added successfully; otherwise, False.</returns>
    function AddIncludePath(const APath: string): Boolean;

    /// <summary>
    /// Sets the output type for the script.
    /// </summary>
    /// <param name="AOutputType">The output type to set.</param>
    /// <returns>True if the output type was set successfully; otherwise, False.</returns>
    function SetOutputType(const AOutputType: TCScriptOutputType): Boolean;

    /// <summary>
    /// Gets the current output type of the script.
    /// </summary>
    /// <returns>The current output type.</returns>
    function GetOutputType(): TCScriptOutputType;

    /// <summary>
    /// Sets the executable subsystem type.
    /// </summary>
    /// <param name="AExeSubsystem">The executable subsystem to set.</param>
    /// <returns>True if the subsystem was set successfully; otherwise, False.</returns>
    function SetExeSubsystem(const AExeSubsystem: TCScriptExeSubsystem): Boolean;

    /// <summary>
    /// Gets the current executable subsystem type.
    /// </summary>
    /// <returns>The current executable subsystem.</returns>
    function GetExeSubsystem(): TCScriptExeSubsystem;

    /// <summary>
    /// Adds a specified library to the script, making its functions and symbols available for use.
    /// </summary>
    /// <param name="AName">The name of the library to add, typically including the path if required.</param>
    /// <returns>
    /// True if the library was successfully added; otherwise, False.
    /// </returns>
    /// <remarks>
    /// This function allows the script to dynamically link to external libraries by name, which can be essential for
    /// accessing additional functionality or symbols not natively provided within the script environment.
    /// </remarks>
    function  AddLibrary(const AName: string): Boolean;

    /// <summary>
    /// Adds a file to the script compilation.
    /// </summary>
    /// <param name="AFilename">The filename to add.</param>
    /// <returns>True if the file was added successfully; otherwise, False.</returns>
    function AddFile(const AFilename: string): Boolean;

    /// <summary>
    /// Saves the compiled output to a specified file.
    /// </summary>
    /// <param name="AFilename">The filename for the output file.</param>
    /// <returns>True if the file was saved successfully; otherwise, False.</returns>
    function SaveOutputFile(const AFilename: string): Boolean;

    /// <summary>
    /// Compiles a string of code.
    /// </summary>
    /// <param name="ABuffer">The string buffer to compile.</param>
    /// <returns>True if the string was compiled successfully; otherwise, False.</returns>
    function CompileString(const ABuffer: string): Boolean;

    /// <summary>
    /// Adds a symbol to the script.
    /// </summary>
    /// <param name="AName">The name of the symbol to add.</param>
    /// <param name="AValue">The value associated with the symbol.</param>
    procedure AddSymbol(const AName: string; AValue: Pointer);

    /// <summary>
    /// Defines a symbol within the script.
    /// </summary>
    /// <param name="AName">The name of the symbol to define.</param>
    /// <param name="AValue">The value associated with the symbol.</param>
    procedure DefineSymbol(const AName: string; const AValue: string);

    /// <summary>
    /// Undefines a symbol, removing it from the script.
    /// </summary>
    /// <param name="AName">The name of the symbol to undefine.</param>
    procedure UndefineSymbol(const AName: string);

    /// <summary>
    /// Retrieves a symbol's address.
    /// </summary>
    /// <param name="AName">The name of the symbol to retrieve.</param>
    /// <returns>A pointer to the symbol's value, if found; otherwise, nil.</returns>
    function GetSymbol(const AName: string): Pointer;

    /// <summary>
    /// Executes the compiled script.
    /// </summary>
    /// <returns>True if the script executed successfully; otherwise, False.</returns>
    function Run(): Boolean;

    /// <summary>
    /// Relocates the script for execution.
    /// </summary>
    /// <returns>True if the relocation succeeded; otherwise, False.</returns>
    function Relocate(): Boolean;
  end;

implementation

{ TCScript }
procedure TCScript_ErrorHandler(aSender: Pointer; const AText: PUTF8Char); cdecl;
var
  LText: string;
begin
  LText := UTF8ToUnicodeString(AText);
  LText := LText.Replace('tcc:', '');
  LText := LText.Trim;

  TCScript(aSender).ErrorHandler(LText);
end;

function TCScript_Realloc(APtr: Pointer; ASize: Cardinal): Pointer; cdecl;
begin
  ReallocMem(APtr, ASize);
  Result := APtr;
end;

procedure TCScript.ErrorHandler(const AText: string);
begin
  if ContainsText(AText, 'warning: Ignoring unknown preprocessing directive') then
    Exit;
  if Assigned(FOnError.Handler) then
    FOnError.Handler(FOnError.Sender, AText)
  else
    if HasConsoleOutput then
      WriteLn(AText);
end;

procedure TCScript.Startup();
begin
  FOutputTypeSet := False;
  FExeSubsystemSet := False;
  FRelocated := False;

  tcc_set_realloc(TCScript_Realloc);

  FState := tcc_new();
  if not Assigned(FState) then Exit;

  tcc_set_error_func(FState, Self, TCScript_ErrorHandler);
  tcc_set_options(FState, '-Wall -fms-extensions -g -r -mms-bitfields');
  tcc_set_options(FState, '-Wno-implicit-function-declaration');
  tcc_add_library_path(FState, AsUTF8(TPath.GetDirectoryName(ParamStr(0))));

  DefineSymbol('DLL_EXPORT', ' __declspec(dllexport)');
  DefineSymbol('DLL_IMPORT', ' __declspec(dllimport)');
  DefineSymbol('DLL_IMPORT_DATA', ' extern __declspec(dllimport)');
  DefineSymbol('CSCRIPT', '');
end;

procedure TCScript.Shutdown();
begin
  if not Assigned(FState) then Exit;

  tcc_delete(FState)
end;

constructor TCScript.Create();
begin
  inherited;
  Startup();
end;

destructor TCScript.Destroy();
begin
  Shutdown();
  inherited;
end;

procedure TCScript.Reset();
begin
  Shutdown();
  Startup();
end;

procedure TCScript.SetErrorHandler(const ASender: Pointer; const AHandler: TCScriptErrorEvent);
begin
  FOnError.Sender := ASender;
  FOnError.Handler := AHandler;
end;

procedure TCScript.GetErrorHandler(var ASender: Pointer; var AHandler: TCScriptErrorEvent);
begin
  ASender := FOnError.Sender;
  AHandler := FOnError.Handler;
end;

function TCScript.AddLibraryPath(const APath: string): Boolean;
begin
  Result := False;
  if not Assigned(FState) then Exit;

  Result := Boolean(tcc_add_library_path(FState, AsUTF8(APath)) > -1);
  if Result then
  begin
    AddPathToSystemPath(APath);
  end;
end;

function  TCScript.SetOutputType(const AOutputType: TCScriptOutputType): Boolean;
var
  LOutputType: Integer;
begin
  Result := False;
  if not Assigned(FState) then Exit;
  if FOutputTypeSet then Exit;

  case AOutputType of
    csMEMORY: LOutputType := TCC_OUTPUT_MEMORY;
    csLib   : LOutputType := TCC_OUTPUT_OBJ;
    csEXE   : LOutputType := TCC_OUTPUT_EXE;
    csDLL   : LOutputType := TCC_OUTPUT_DLL;
  else
    LOutputType := TCC_OUTPUT_MEMORY;
  end;

  Result := Boolean(tcc_set_output_type(FState, LOutputType) >-1);
  if Result then
  begin
    FOutputType := AOutputType;
    FOutputTypeSet := True;
  end;
end;

function  TCScript.GetOutputType(): TCScriptOutputType;
begin
  Result := FOutputType;
end;

function  TCScript.AddLibrary(const AName: string): Boolean;
var
  LName: string;
begin
  Result := False;
  if not Assigned(FState) then Exit;
  if FRelocated then Exit;
  LName := TPath.GetFileNameWithoutExtension(AName);
  Result := Boolean(tcc_add_library(FState, AsUtf8(LName)) > -1);
end;


function TCScript.AddFile(const AFilename: string): Boolean;
begin
  Result := False;
  if not Assigned(FState) then Exit;

  Result := Boolean(tcc_add_file(FState, AsUTF8(AFilename)) > -1);
end;

function TCScript.SetExeSubsystem(const AExeSubsystem: TCScriptExeSubsystem): Boolean;
begin
  Result := False;
  if not Assigned(FState) then Exit;

  if FExeSubsystemSet  then Exit;
  if FRelocated then Exit;
  if FOutputType = csMEMORY then Exit;

  case AExeSubsystem of
    csCONSOLE:
    begin
      Result := Boolean(tcc_set_options(FState, '-Wl,-subsystem=console') > -1);
    end;

    csGUI:
    begin
      Result := Boolean(tcc_set_options(FState, '-Wl,-subsystem=gui') > -1);
    end;
  end;

  FExeSubsystem := AExeSubsystem;
  FExeSubsystemSet := True;
end;

function  TCScript.GetExeSubsystem(): TCScriptExeSubsystem;
begin
  Result := FExeSubsystem;
end;

function TCScript.CompileString(const ABuffer: string): Boolean;
begin
  Result := False;
  if not Assigned(FState) then Exit;
  if FRelocated then Exit;
  if ABuffer.IsEmpty then Exit;

  Result := Boolean(tcc_compile_string(FState, AsUtf8(ABuffer)) > -1);
end;

procedure TCScript.AddSymbol(const AName: string; AValue: Pointer);
begin
  if not Assigned(FState) then Exit;
  if FRelocated then Exit;
  if AName.IsEmpty then Exit;

  tcc_add_symbol(FState, AsUtf8(AName), AValue);
end;

function TCScript.AddIncludePath(const APath: string): Boolean;
begin
  Result := False;
  if not Assigned(FState) then Exit;
  if APath.IsEmpty then Exit;
  if not TDirectory.Exists(APath) then Exit;

  Result := Boolean(tcc_add_include_path(FState, AsUtf8(APath)) > -1);
end;

procedure TCScript.DefineSymbol(const AName: string; const AValue: string);
begin
  if not Assigned(FState) then Exit;

  tcc_define_symbol(FState, AsUtf8(AName), AsUtf8(AValue));
end;

procedure TCScript.UndefineSymbol(const AName: string);
begin
  if not Assigned(FState) then Exit;

  tcc_undefine_symbol(FState, AsUtf8(AName));
end;

function TCScript.GetSymbol(const AName: string): Pointer;
begin
  Result := nil;
  if not Assigned(FState) then Exit;
  if not FRelocated then Exit;
  Result := tcc_get_symbol(FState, AsUtf8(AName));
end;

function TCScript.SaveOutputFile(const AFilename: string): Boolean;
var
  LFilename: string;
begin
  Result := False;
  if not Assigned(FState) then Exit;
  if FOutputType = csMEMORY then Exit;
  if FRelocated then Exit;
  if aFilename.IsEmpty then Exit;
  case FOutputType of
    csLib:
    begin
      LFilename := EnsureLibFormat(AFilename);
    end;

    csEXE:
    begin
      LFilename := TPath.ChangeExtension(aFilename, 'exe');
    end;

    csDLL:
    begin
      LFilename := TPath.ChangeExtension(aFilename, 'dll');
    end;
  end;
  CreateDirsInPath(LFilename);
  if TFile.Exists(LFilename) then
    if IsFileInUse(LFilename) then Exit;
  Result := Boolean(tcc_output_file(FState, AsUtf8(LFilename)) > -1);
end;

function TCScript.Run(): Boolean;
begin
  Result := False;
  if not Assigned(FState) then Exit;
  if FRelocated then Exit;
  Result := Boolean(tcc_run(FState, 0, nil) > -1);
  if Result then
    FRelocated := Result;
end;

function TCScript.Relocate(): Boolean;
begin
  Result := False;
  if not Assigned(FState) then Exit;
  if FRelocated then Exit;
  Result := Boolean(tcc_relocate(FState) > -1);
  FRelocated := Result;
end;

end.
