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

program csc;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  ucsc in 'ucsc.pas';

begin
  try
    RunCSC();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
