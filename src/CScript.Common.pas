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

unit CScript.Common;

{$I CScript.Defines.inc}

interface

uses
  WinApi.Windows,
  WinApi.Messages,
  System.Generics.Collections,
  System.SysUtils,
  System.IOUtils,
  System.Classes,
  System.Zip,
  System.RegularExpressions;

const
  INVALID_HANDLE = -1;

type
  { TBaseObject }
  TBaseObject = class
  public
    constructor Create(); virtual;
    destructor Destroy(); override;
  end;

  { TZipManager }
  TZipManager = class
  private
    FZipFile: TZipFile;
    FHandleCounter: Integer;
    ResourceStream: TResourceStream;
  public
    FZipStreams: TDictionary<Integer, TMemoryStream>;
    constructor Create();
    destructor Destroy(); override;
    function LoadZipFromFile(const AFilename: string): Boolean;
    function LoadZipFromResource(const AResName: string): Boolean;
    function OpenFileInZip(const AFilename: string): Integer;
    procedure CloseFile(const AFileHandle: Integer);
    function ReadFile(const AHandle: Integer; const ABuffer: Pointer; const ACount: Longint): Longint;
    function SeekFile(const AHandle: Integer; const AOffset: Longint; const AOrigin: Word): Longint;
  end;

//== MISC ===================================================================
procedure Pause();
function  AsUTF8(const AText: string): Pointer;
function  EnableVirtualTerminalProcessing(): DWORD;
function  IsFileInUse(const aFilename: string): Boolean;
function  CreateDirsInPath(const aFilename: string): Boolean;
function  HasConsoleOutput: Boolean;
function  AddPathToSystemPath(const APath: string): Boolean;
function  NormalizeZipPath(const APath: string): string;
function  EnsureLibFormat(const AFileName: string): string;

var
  ZipManager: TZipManager;

implementation

var
  Marshaller: TMarshaller;

{ TBaseObject }
constructor TBaseObject.Create();
begin
  inherited;
end;

destructor TBaseObject.Destroy();
begin
  inherited;
end;

{ TZipManager }
constructor TZipManager.Create;
begin
  FZipFile := TZipFile.Create;
  FZipStreams := TDictionary<Integer, TMemoryStream>.Create;
  FHandleCounter := 1;
end;

destructor TZipManager.Destroy;
var
  Stream: TMemoryStream;
begin
  for Stream in FZipStreams.Values do
    Stream.Free;
  FZipStreams.Free;
  FZipFile.Free;
  if Assigned(ResourceStream) then
    ResourceStream.Free();

  inherited;
end;

function TZipManager.LoadZipFromFile(const AFilename: string): Boolean;
begin
  FZipFile.Open(AFilename, zmRead);
  Result := True;
end;

function TZipManager.LoadZipFromResource(const AResName: string): Boolean;
begin
  // Close any currently open zip file
  if FZipFile.Stream <> nil then
    FZipFile.Close;
  try
    ResourceStream := TResourceStream.Create(HInstance, AResName, RT_RCDATA);
    FZipFile.Open(ResourceStream, zmRead); // Open the zip from the resource stream
    Result := True;
  except
    Result := False;
  end;
end;

function TZipManager.OpenFileInZip(const AFilename: string): Integer;
var
  Stream: TMemoryStream;
  Bytes: TBytes;
  FileIndex: Integer;
begin
  FileIndex := FZipFile.IndexOf(AFilename);
  if FileIndex >= 0 then
  begin
    FZipFile.Read(FileIndex, Bytes); // Read the file from the zip archive into bytes
    Stream := TMemoryStream.Create;
    Stream.WriteData(Bytes, Length(Bytes)); // Write bytes to memory stream
    Stream.Position := 0; // Reset to start for reading
    Inc(FHandleCounter);
    FZipStreams.Add(FHandleCounter, Stream); // Store stream with a handle
    Result := FHandleCounter;
  end
  else
    Result := INVALID_HANDLE;
end;

procedure TZipManager.CloseFile(const AFileHandle: Integer);
var
  Stream: TMemoryStream;
begin
  if FZipStreams.TryGetValue(AFileHandle, Stream) then
  begin
    Stream.Free;
    FZipStreams.Remove(AFileHandle);
    FZipStreams.TrimExcess();
  end;
end;

function TZipManager.ReadFile(const AHandle: Integer; const ABuffer: Pointer; const ACount: Longint): Longint;
var
  Stream: TMemoryStream;
begin
  if FZipStreams.TryGetValue(AHandle, Stream) then
    Result := Stream.Read(ABuffer^, ACount)
  else
    Result := -1;
end;

function TZipManager.SeekFile(const AHandle: Integer; const AOffset: Longint; const AOrigin: Word): Longint;
var
  Stream: TMemoryStream;
begin
  if FZipStreams.TryGetValue(AHandle, Stream) then
    Result := Stream.Seek(AOffset, AOrigin)
  else
    Result := -1;
end;



//== MISC ===================================================================
procedure Pause();
begin
  WriteLn;
  Write('Press ENTER to continue...');
  ReadLn;
  WriteLn;
end;

function AsUTF8(const AText: string): Pointer;
begin
  Result := Marshaller.AsUtf8(AText).ToPointer;
end;

function EnableVirtualTerminalProcessing(): DWORD;
var
  HOut: THandle;
  LMode: DWORD;
begin
  HOut := GetStdHandle(STD_OUTPUT_HANDLE);
  if HOut = INVALID_HANDLE_VALUE then
  begin
    Result := GetLastError;
    Exit;
  end;

  if not GetConsoleMode(HOut, LMode) then
  begin
    Result := GetLastError;
    Exit;
  end;

  LMode := LMode or ENABLE_VIRTUAL_TERMINAL_PROCESSING;
  if not SetConsoleMode(HOut, LMode) then
  begin
    Result := GetLastError;
    Exit;
  end;

  Result := 0;  // Success
end;

function IsFileInUse(const aFilename: string): Boolean;
var
  LHFileRes: THandle;
begin
  Result := False;
  if not FileExists(aFilename) then Exit;
  LHFileRes := CreateFile(PChar(aFilename), GENERIC_READ or GENERIC_WRITE,
    0, nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);
  Result := Boolean(LHFileRes = INVALID_HANDLE_VALUE);
  if not Result then
    CloseHandle(LHFileRes);
end;

function CreateDirsInPath(const aFilename: string): Boolean;
var
  s: string;
begin
  Result := False;

  if aFilename.IsEmpty then
    Exit;

  s := TPath.GetDirectoryName(aFilename);
  if s.IsEmpty then Exit;

  TDirectory.CreateDirectory(s);
  Result := TDirectory.Exists(s)

end;

function HasConsoleOutput: Boolean;
var
  Stdout: THandle;
begin
  Stdout := GetStdHandle(Std_Output_Handle);
  Win32Check(Stdout <> Invalid_Handle_Value);
  Result := Stdout <> 0;
end;


function AddPathToSystemPath(const APath: string): Boolean;
var
  LCurrentPath: string;
begin
  Result := False;
  if not TDirectory.Exists(APath) then Exit;

  SetLength(LCurrentPath, GetEnvironmentVariable('PATH', nil, 0) - 1);
  GetEnvironmentVariable('PATH', PChar(LCurrentPath), Length(LCurrentPath) + 1);

  if not LCurrentPath.Contains(APath) then
  begin
    LCurrentPath := APath + ';' + LCurrentPath;
    if SetEnvironmentVariable('PATH', PChar(LCurrentPath)) then
    begin
      SendMessage(HWND_BROADCAST, WM_SETTINGCHANGE, 0, LPARAM(PChar('Environment')));
      Result := True;
    end;
  end;
end;

function NormalizeZipPath(const APath: string): string;
var
  Segments: TArray<string>;
  Stack: TStack<string>;
  Segment: string;
begin
  Stack := TStack<string>.Create;
  try
    // Split the path into individual segments
    Segments := APath.Split(['/', '\']);

    for Segment in Segments do
    begin
      if Segment = '..' then
      begin
        // Go up one level if possible
        if Stack.Count > 0 then
          Stack.Pop;
      end
      else if (Segment <> '.') and (Segment <> '') then
      begin
        // Add valid segment to the stack
        Stack.Push(Segment);
      end;
    end;

    // Rebuild the normalized path
    Result := '';
    while Stack.Count > 0 do
    begin
      if Result = '' then
        Result := Stack.Pop
      else
        Result := Stack.Pop + '/' + Result;
    end;
  finally
    Stack.Free;
  end;
end;

function EnsureLibFormat(const AFileName: string): string;
var
  LPath, LBaseName: string;
begin
  LPath := TPath.GetDirectoryName(AFileName);
  LBaseName := TPath.GetFileName(AFileName);

  if not LBaseName.StartsWith('lib', True) then
    LBaseName := 'lib' + LBaseName;

  LBaseName := TPath.ChangeExtension(LBaseName, '.a');
  Result := TPath.Combine(LPath, LBaseName);
end;

procedure Test;
var
  LPath: string;
begin
  LPath := 'include/../math.h';
  Writeln(NormalizeZipPath(LPath)); // Outputs: "math.h"
end;


//===========================================================================
function a608f59a965c4689873b5c2ed210cd8d(): string;
const
  CValue = 'e6871fe63c774aca9b51b8efa856370a';
begin
  Result := CValue;
end;

initialization
  ReportMemoryLeaksOnShutdown := True;

  SetConsoleCP(CP_UTF8);
  SetConsoleOutputCP(CP_UTF8);
  EnableVirtualTerminalProcessing();

  ZipManager := TZipManager.Create;
  if not ZIpManager.LoadZipFromResource(a608f59a965c4689873b5c2ed210cd8d()) then
   Abort();

finalization
  ZipManager.Free;

end.
