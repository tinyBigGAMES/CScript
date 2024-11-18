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

unit CScript.Deps.CRuntime;

{$I CScript.Defines.inc}

interface

const
  kernelbase = 'kernelbase.dll';
  kernel32 = 'kernel32.dll';
  shell32 = 'shell32.dll';
  user32 = 'user32.dll';
  ucrt = 'api-ms-win-crt-private-l1-1-0.dll';

//=== KERNELBASE ============================================================
procedure ___chkstk_ms; stdcall; external kernelbase name '__chkstk';

//=== KERNEL32 ==============================================================
procedure RtlAddFunctionTable; stdcall; external 'kernel32.dll';
procedure RtlDeleteFunctionTable; stdcall; external 'kernel32.dll';

//=== UCRT ==================================================================
procedure memset; cdecl; external ucrt;
procedure strcpy; cdecl; external ucrt;
procedure strncmp; cdecl; external ucrt;
procedure strstr; cdecl; external ucrt;
procedure strlen; cdecl; external ucrt;
procedure memcpy; external ucrt;
procedure realloc; cdecl; external ucrt;
procedure free; cdecl; external ucrt;
procedure strtoul; cdecl; external ucrt;
procedure strncpy; cdecl; external ucrt;
procedure memmove; cdecl; external ucrt;
procedure qsort; cdecl; external ucrt;
procedure strcmp; cdecl; external ucrt;
procedure strtol; cdecl; external ucrt;
procedure fseek; cdecl; external ucrt;
procedure fclose; cdecl; external ucrt;
procedure memcmp; cdecl; external ucrt;
procedure _errno; cdecl; external ucrt;
procedure _stricmp; cdecl; external ucrt;
procedure longjmp; cdecl; external ucrt;
procedure memchr; cdecl; external ucrt;
procedure _time64; cdecl; external ucrt;
procedure ldexp; cdecl; external ucrt;
procedure fopen; cdecl; external ucrt;
procedure __intrinsic_setjmpex; cdecl; external ucrt name '__intrinsic_setjmpex';
procedure strrchr; cdecl; external ucrt;
procedure _localtime64; cdecl; external ucrt;
procedure strtoull; cdecl; external ucrt name 'strtoull';
procedure __p__environ; cdecl; external ucrt;
procedure getcwd; cdecl; external ucrt name '_getcwd';
procedure unlink; cdecl; external ucrt name '_unlink';
procedure __acrt_job_func; cdecl; external ucrt;
procedure putchar; cdecl; external ucrt;
procedure fflush; cdecl; external ucrt;
procedure strchr; cdecl; external ucrt;
procedure fputs; cdecl; external ucrt;
procedure strlwr; external ucrt name '_strlwr';
procedure stricmp; cdecl; external ucrt name '_stricmp';
procedure atoi; cdecl; external ucrt;
procedure puts; cdecl; external ucrt;
procedure fdopen; cdecl; external ucrt name '_fdopen';
procedure fputc; cdecl; external ucrt;
procedure strerror; cdecl; external ucrt;
procedure __mingw_strtod; cdecl; external ucrt name 'strtod';
procedure _fullpath; cdecl; external ucrt;
procedure exit; cdecl; external ucrt;
procedure __acrt_iob_func; cdecl; external ucrt;
procedure __mingw_strtof; cdecl; external ucrt name 'strtof';

//=== HOOKS =================================================================
{ Orginal }
function h_open(const Filename: PAnsiChar; Flags: Integer; Mode: Integer = 0): Integer; cdecl; external ucrt name '_open';
function h_close(FileHandle: Integer): Integer; cdecl; external ucrt name '_close';
function h_read(FileHandle: Integer; Buffer: Pointer; Count: Cardinal): Integer; cdecl; external ucrt name '_read';
function h_lseek(FileHandle: Integer; Offset: Integer; Origin: Integer): Integer; cdecl; external ucrt name '_lseek';
function h_fwrite(ptr: Pointer; size: Cardinal; count: Cardinal; stream: Pointer): Cardinal; cdecl; external ucrt name 'fwrite';
function __stdio_common_vsprintf(options: UInt64; buffer: PAnsiChar; bufferCount: NativeUInt; format: PAnsiChar; locale: Pointer; args: Pointer): Integer; cdecl; external ucrt name '__stdio_common_vsprintf';
function __stdio_common_vfprintf(options: UInt64; stream: Pointer; format: PAnsiChar; locale: Pointer; args: Pointer): Integer; cdecl; external ucrt name '__stdio_common_vfprintf';

{ Local }
function open(const Filename: PAnsiChar; Flags: Integer; Mode: Integer = 0): Integer; cdecl;
function close(FileHandle: Integer): Integer; cdecl;
function read(FileHandle: Integer; Buffer: Pointer; Count: Cardinal): Integer; cdecl;
function lseek(FileHandle: Integer; Offset: Integer; Origin: Integer): Integer; cdecl;
function fwrite(ptr: Pointer; size: Cardinal; count: Cardinal; stream: Pointer): Cardinal; cdecl;
function _vsnprintf(buffer: PAnsiChar; bufferCount: NativeUInt; format: PAnsiChar; args: Pointer): Integer; cdecl;
function vsnprintf(buffer: PAnsiChar; bufferCount: NativeUInt; format: PAnsiChar; args: Pointer): Integer; cdecl;
function vfprintf(stream: Pointer; format: PAnsiChar; args: Pointer): Integer; cdecl;
function __mingw_vsprintf(buffer: PAnsiChar; bufferCount: NativeUInt; format: PAnsiChar; args: Pointer): Integer; cdecl;
function __mingw_vfprintf(stream: Pointer; format: PAnsiChar; args: Pointer): Integer; cdecl;

implementation

uses
  System.SysUtils,
  System.IOUtils,
  CScript.Common;

//=== CRUNTIME HOOKS ========================================================
{ Local }
function __mingw_vsprintf(buffer: PAnsiChar; bufferCount: NativeUInt; format: PAnsiChar; args: Pointer): Integer; cdecl;
begin
  Result := __stdio_common_vsprintf(0, buffer, bufferCount, format, nil, args);
end;

function __mingw_vfprintf(stream: Pointer; format: PAnsiChar; args: Pointer): Integer; cdecl;
begin
  Result := __stdio_common_vfprintf(0, stream, format, nil, args);
end;

function vfprintf(stream: Pointer; format: PAnsiChar; args: Pointer): Integer; cdecl;
begin
  Result := __stdio_common_vfprintf(0, stream, format, nil, args);
end;

function _vsnprintf(buffer: PAnsiChar; bufferCount: NativeUInt; format: PAnsiChar; args: Pointer): Integer; cdecl;
begin
  Result := __stdio_common_vsprintf(0, buffer, bufferCount, format, nil, args);
end;

function vsnprintf(buffer: PAnsiChar; bufferCount: NativeUInt; format: PAnsiChar; args: Pointer): Integer; cdecl;
begin
  Result := __stdio_common_vsprintf(0, buffer, bufferCount, format, nil, args);
end;

function fwrite(ptr: Pointer; size: Cardinal; count: Cardinal; stream: Pointer): Cardinal; cdecl;
begin
  Result := h_fwrite(ptr, size, count, stream);
end;

function open(const Filename: PAnsiChar; Flags: Integer; Mode: Integer = 0): Integer; cdecl;
var
  LFilename: string;
  LStartPath: string;
begin
  LStartPath := TPath.GetDirectoryName(ParamStr(0)) + '\';
  LStartPath := LStartPath.Replace('\', '/');
  LFilename := string(Filename);

  LFilename := LFilename.Replace('\', '/');
  LFilename := LFilename.Replace(LStartPath, '', [rfIgnoreCase]);


  Result :=  ZipManager.OpenFileInZip(NormalizeZipPath(LFilename));
  if Result = INVALID_HANDLE then
    Result := h_open(Filename, Flags, Mode);
end;

function close(FileHandle: Integer): Integer; cdecl;
begin
  if ZipManager.FZipStreams.ContainsKey(FileHandle) then
  begin
    ZipManager.CloseFile(FileHandle);
    Result := 0;
  end
  else
    Result := h_close(FileHandle);
end;

function read(FileHandle: Integer; Buffer: Pointer; Count: Cardinal): Integer; cdecl;
begin
  if ZipManager.FZipStreams.ContainsKey(FileHandle) then
    Result := ZipManager.ReadFile(FileHandle, Buffer, Count)
  else
    Result := h_read(FileHandle, Buffer, Count);
end;

function lseek(FileHandle: Integer; Offset: Integer; Origin: Integer): Integer; cdecl;
begin
  if ZipManager.FZipStreams.ContainsKey(FileHandle) then
    Result := ZipManager.SeekFile(FileHandle, Offset, Origin)
  else
    Result := h_lseek(FileHandle, Offset, Origin);
end;

end.

