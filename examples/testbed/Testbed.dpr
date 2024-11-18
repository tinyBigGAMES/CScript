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

program Testbed;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  UTestbed in 'UTestbed.pas',
  UAddFileDLL in 'UAddFileDLL.pas',
  UAddSymbol in 'UAddSymbol.pas',
  UAddFileRun in 'UAddFileRun.pas',
  UCompileString in 'UCompileString.pas',
  UGetSymbol in 'UGetSymbol.pas',
  UCreateEXE in 'UCreateEXE.pas',
  UCreateLIB in 'UCreateLIB.pas',
  UUseLIB in 'UUseLIB.pas';

begin
  try
    RunTests();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
