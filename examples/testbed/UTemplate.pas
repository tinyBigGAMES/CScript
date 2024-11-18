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

unit UTemplate;

interface

procedure Template();

implementation

uses
  System.SysUtils,
  CScript;

procedure CScriptErrorEvent(const ASender: Pointer; const AText: string);
begin
  WriteLn(AText);
end;

procedure Template();
var
  LCScript: TCScript;
begin
  LCScript := TCScript.Create();
  try
    LCScript.SetErrorHandler(nil, CScriptErrorEvent);
    LCScript.SetOutputType(csMEMORY);
    LCScript.AddIncludePath('res/include');
    LCScript.AddLibraryPath('res/lib');

  finally
    LCScript.Free();
  end;
end;

end.
