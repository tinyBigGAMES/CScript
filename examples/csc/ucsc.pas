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

unit ucsc;

interface

procedure RunCSC();

implementation

uses
  System.SysUtils,
  System.IOUtils,
  CScript;

procedure RunCSC();
var
  LCScript: TCScript;
  LSourceFilename: string;
  LOutputFilename: string;

  procedure Header();
  begin
    WriteLn('CScript™ Compiler v0.1.0');
    WriteLn('Copyright © 2024-present tinyBigGAMES™ LLC');
    WriteLn('All Rights Reserved.');
    WriteLn;
  end;

  procedure Usage();
  begin
    WriteLn;
    WriteLn('Usage: csc sourcefile[.c] outputfile[.exe]');
  end;

begin
  Header();

  if ParamCount < 2 then
  begin
    Writeln('No source/output file specified');
    Usage();
    Exit;
  end;

  LSourceFilename := ParamStr(1);
  LSourceFilename := TPath.ChangeExtension(LSourceFilename, 'c');
  if not TFile.Exists(LSourceFilename) then
  begin
    WriteLn('Source file was not found: ', LSourceFilename);
    Exit;
  end;

  LOutputFilename := ParamStr(2);
  LOutputFilename := TPath.ChangeExtension(LOutputFilename, 'exe');

  LCScript := TCScript.Create();
  try
    LCScript.SetOutputType(csEXE);
    LCScript.SetExeSubsystem(csCONSOLE);
    if LCScript.AddFile(LSourceFilename) then
    begin
      if LCScript.SaveOutputFile(LOutputFilename) then
        begin
          Writeln(Format('Created "%s"', [LOutputFilename]));
          WriteLn('Success!');
        end
      else
        begin
          WriteLn('Failed!');
        end;
    end;
  finally
    LCScript.Free();
  end;
end;

end.
