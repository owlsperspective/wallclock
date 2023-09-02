﻿unit FWallClock;

interface

uses
  Winapi.Windows, Winapi.Messages, Winapi.ShellAPI,
  System.SysUtils, System.Variants, System.Classes, System.Actions, System.UITypes,
  System.Skia,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.ActnList, Vcl.Menus, Vcl.Skia;

type
  TFormWallClock = class(TForm)
    TimerUpdate: TTimer;
    Label1: TSkLabel;
    Label2: TSkLabel;
    Label3: TSkLabel;
    Label4: TSkLabel;
    Label5: TSkLabel;
    Label6: TSkLabel;
    Label7: TSkLabel;
    Label8: TSkLabel;
    LabelDate: TSkLabel;
    TimerFade: TTimer;
    TrayIcon: TTrayIcon;
    ActionList: TActionList;
    ActionExit: TAction;
    PopupMenu: TPopupMenu;
    MenuItemExit: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure TimerUpdateTimer(Sender: TObject);
    procedure TimerFadeTimer(Sender: TObject);
    procedure TrayIconClick(Sender: TObject);
    procedure PopupMenuPopup(Sender: TObject);
    procedure ActionExitExecute(Sender: TObject);
  private
    const
      FigureColor: TColor = $6040A0;
      HighlightColor: TColor = $FF0000;
      BorderColor: TColor = $FFFFFF;
      FadeOutDelta: Integer = -10;
      FadeInDelta: Integer = 20;
      MinAlphaBlendValue: Integer =  80;
      MaxAlphaBlendValue: Integer = 255;
  private
    FLabelTime: array [0..7] of TSkLabel;
    FFadeDelta: Integer;
    procedure AdjustPosition;
    procedure AdjustFigureColors(Highlight: Boolean);
    procedure AdjustZOrder;
    procedure ShowTime;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  public
    procedure WmDisplayChange(var Message: TWMDisplayChange); message WM_DISPLAYCHANGE;
  end;

var
  FormWallClock: TFormWallClock;

implementation

{$R *.dfm}

procedure TFormWallClock.FormCreate(Sender: TObject);
begin
  FLabelTime[0] := Label1;
  FLabelTime[1] := Label2;
  FLabelTime[2] := Label3;
  FLabelTime[3] := Label4;
  FLabelTime[4] := Label5;
  FLabelTime[5] := Label6;
  FLabelTime[6] := Label7;
  FLabelTime[7] := Label8;
end;

procedure TFormWallClock.FormShow(Sender: TObject);
var
  I: Integer;
begin
  AdjustPosition;
  AdjustFigureColors(False);
  for I := Low(FLabelTime) to High(FLabelTime) do
  begin
    FLabelTime[I].TextSettings.Decorations.StrokeColor := TAlphaColorRec.Alpha or TAlphaColor(BorderColor);
  end;
  LabelDate.TextSettings.Decorations.StrokeColor := TAlphaColorRec.Alpha or TAlphaColor(BorderColor);

  Color := BorderColor xor $010101;
  TransparentColorValue := Color;
  ShowTime;
end;

procedure TFormWallClock.TimerUpdateTimer(Sender: TObject);
var
  quns: QUERY_USER_NOTIFICATION_STATE;
  FullScreenDetected: Boolean;
begin
  ShowTime;

  FullScreenDetected := False;
  if SHQueryUserNotificationState(quns) = S_OK then
  begin
    FullScreenDetected := quns in [QUNS_BUSY,QUNS_RUNNING_D3D_FULL_SCREEN];
  end;
  if Visible = FullScreenDetected then
  begin
    Visible := not FullScreenDetected;
    if Visible = True then
    begin
      AdjustZOrder;
    end;
  end;

  if (Mouse.CursorPos.X >= Left) and (Mouse.CursorPos.X < (Left + ClientWidth)) and
     (Mouse.CursorPos.Y >= Top)  and (Mouse.CursorPos.Y < (Top  + ClientHeight)) then
  begin
    { Fade out }
    FFadeDelta := FadeOutDelta;
    TimerFade.Enabled := True;
  end
  else
  begin
    if AlphaBlendValue < 255 then
    begin
      { Fade in }
      FFadeDelta := FadeInDelta;
      TimerFade.Enabled := True;
    end;
  end;
end;

procedure TFormWallClock.TimerFadeTimer(Sender: TObject);
var
  NewValue: Integer;
begin
  NewValue := AlphaBlendValue + FFadeDelta;
  if NewValue <= MinAlphaBlendValue then
  begin
    NewValue := MinAlphaBlendValue;
    TimerFade.Enabled := False;
  end
  else if NewValue >= MaxAlphaBlendValue then
  begin
    NewValue := MaxAlphaBlendValue;
    TimerFade.Enabled := False;
  end;
  AlphaBlendValue := NewValue;
end;

procedure TFormWallClock.TrayIconClick(Sender: TObject);
begin
  AdjustZOrder;
end;

procedure TFormWallClock.PopupMenuPopup(Sender: TObject);
begin
  AdjustZOrder;
end;

procedure TFormWallClock.ActionExitExecute(Sender: TObject);
begin
  Close;
end;

procedure TFormWallClock.CreateParams(var Params: TCreateParams);
begin
  inherited;
  Params.ExStyle := (Params.ExStyle or WS_EX_TRANSPARENT or WS_EX_NOACTIVATE) and not WS_EX_APPWINDOW;
end;

procedure TFormWallClock.WmDisplayChange(var Message: TWMDisplayChange);
begin
  AdjustPosition;
end;

procedure TFormWallClock.AdjustPosition;
begin
  SetBounds(Screen.WorkAreaRect.Right - Width,0,Width,Height);
end;

procedure TFormWallClock.AdjustFigureColors(Highlight: Boolean);
var
  I: Integer;
  AlphaColor: TAlphaColor;
begin
  if Highlight = False then
  begin
    AlphaColor := TAlphaColor(FigureColor);
  end
  else
  begin
    AlphaColor := TAlphaColor(HighlightColor);
  end;
  AlphaColor := TAlphaColorRec.Alpha or AlphaColor;

  for I := Low(FLabelTime) to High(FLabelTime) do
  begin
    FLabelTime[I].TextSettings.FontColor := AlphaColor;
  end;
  LabelDate.TextSettings.FontColor := AlphaColor;
end;

procedure TFormWallClock.AdjustZOrder;
begin
  SetWindowPos(Handle,HWND_TOPMOST,0,0,0,0,SWP_NOMOVE or SWP_NOSIZE or SWP_NOACTIVATE or SWP_NOOWNERZORDER);
end;

procedure TFormWallClock.ShowTime;
const
  CSeparator: array [Boolean] of String = (' ', ':');
  CDOW: array [0..6] of String = ('SUN','MON','TUE','WED','THU','FRI','SAT');
var
  S: String;
  ST: TSystemTime;
  ShowColon: Boolean;
  Highlight: Boolean;
  I: Integer;
begin
  GetLocalTime(ST);

  ShowColon := (ST.wMilliseconds < 500);
  S := Format('%0:.2d%3:s%1:.2d%3:s%2:.2d',[ST.wHour,ST.wMinute,ST.wSecond,CSeparator[ShowColon]]);
  for I := Low(FLabelTime) to High(FLabelTime) do
  begin
    if FLabelTime[I].Caption <> S[I + 1] then
    begin
      FLabelTime[I].Caption := S[I + 1];
    end;
  end;

  Highlight := ((ST.wMinute = 59) and (ST.wSecond >= 59)) or ((ST.wMinute = 0) and (ST.wSecond <= 1));
  AdjustFigureColors(Highlight);

  S := Format('%0:.4d-%1:.2d-%2:.2d (%3:s)',[ST.wYear,ST.wMonth,ST.wDay,CDOW[ST.wDayOfWeek]]);
  if LabelDate.Caption <> S then
  begin
    LabelDate.Caption := S;
  end;

  TrayIcon.Hint := Application.Title + sLineBreak +
                   Format('%0:.4d-%1:.2d-%2:.2d (%3:s)' + sLineBreak + '%4:.2d:%5:.2d:%6:.2d',
                          [ST.wYear,ST.wMonth,ST.wDay,CDOW[ST.wDayOfWeek],ST.wHour,ST.wMinute,ST.wSecond]);
end;

end.
