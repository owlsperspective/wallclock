unit FWallClock;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes, System.Actions, System.UITypes,
  System.Skia, System.Math,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.ActnList, Vcl.Menus, Vcl.Skia,
  FWallClockBase;

type
  TFormWallClock = class(TFormWallClockBase)
    Label1: TSkLabel;
    Label2: TSkLabel;
    Label3: TSkLabel;
    Label4: TSkLabel;
    Label5: TSkLabel;
    Label6: TSkLabel;
    Label7: TSkLabel;
    Label8: TSkLabel;
    LabelDate: TSkLabel;
    LabelBatteryStatus: TSkLabel;
    ActionReverseColors: TAction;
    MenuItemReverseColors: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure ActionReverseColorsExecute(Sender: TObject);
  private
    const
      FigureColor: array [Boolean] of TColor = ($6040A0, $DFFFD0);
      HighlightColor: TColor = $FF4B00;
      BorderColor: array [Boolean] of TColor = ($F0D0FF, $80A040);
  protected
    FLabelTime: array [0..7] of TSkLabel;
    FBatteryUpdateInterval: Integer;
    FBatteryUpdateCount: Integer;
    procedure Initialize; override;
    procedure AdjustColors(Highlight: Boolean); override;
    procedure DoShowTime(ST: TSystemTime); override;
    procedure DoShowBatteryStatus;
    class function DecodeSecond(Value: Integer): String;
  end;

var
  FormWallClock: TFormWallClock;

implementation

{$R *.dfm}

procedure TFormWallClock.FormCreate(Sender: TObject);
begin
  inherited;

  FLabelTime[0] := Label1;
  FLabelTime[1] := Label2;
  FLabelTime[2] := Label3;
  FLabelTime[3] := Label4;
  FLabelTime[4] := Label5;
  FLabelTime[5] := Label6;
  FLabelTime[6] := Label7;
  FLabelTime[7] := Label8;

  ActionReverseColors.Checked := False;
end;

procedure TFormWallClock.ActionReverseColorsExecute(Sender: TObject);
begin
  ActionReverseColors.Checked := not ActionReverseColors.Checked;
end;

procedure TFormWallClock.Initialize;
begin
  inherited;
  AdjustColors(False);

  FBatteryUpdateInterval := (MSecsPerSec div 2) div TimerUpdate.Interval;
  FBatteryUpdateCount := FBatteryUpdateInterval;
end;

procedure TFormWallClock.AdjustColors(Highlight: Boolean);
var
  I: Integer;
  AlphaColor: TAlphaColor;
  Reverse: Boolean;
begin
  { Font color }
  if Highlight = False then
  begin
    AlphaColor := TAlphaColor(FigureColor[ActionReverseColors.Checked]);
  end
  else
  begin
    AlphaColor := TAlphaColor(HighlightColor);
  end;
  AlphaColor := TAlphaColorRec.Alpha or AlphaColor;

  { Apply font color }
  for I := Low(FLabelTime) to High(FLabelTime) do
  begin
    FLabelTime[I].TextSettings.FontColor := AlphaColor;
  end;
  LabelDate.TextSettings.FontColor := AlphaColor;
  LabelBatteryStatus.TextSettings.FontColor := AlphaColor;

  { Border color }
  Reverse := ActionReverseColors.Checked;
  AlphaColor := TAlphaColorRec.Alpha or TAlphaColor(BorderColor[Reverse]);

  { Apply border color }
  for I := Low(FLabelTime) to High(FLabelTime) do
  begin
    FLabelTime[I].TextSettings.Decorations.StrokeColor := AlphaColor;
  end;
  LabelDate.TextSettings.Decorations.StrokeColor := AlphaColor;
  LabelBatteryStatus.TextSettings.Decorations.StrokeColor := AlphaColor;

  { Form color }
  Color := BorderColor[Reverse] xor $010101;
  TransparentColorValue := Color;
end;

procedure TFormWallClock.DoShowTime(ST: TSystemTime);
const
  CSeparator: array [Boolean] of String = (' ', ':');
  CDOW: array [0..6] of String = ('SUN','MON','TUE','WED','THU','FRI','SAT');
var
  S: String;
  ShowColon: Boolean;
  Highlight: Boolean;
  I: Integer;
begin
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
  AdjustColors(Highlight);

  S := Format('%0:.4d-%1:.2d-%2:.2d (%3:s)',[ST.wYear,ST.wMonth,ST.wDay,CDOW[ST.wDayOfWeek]]);
  if LabelDate.Caption <> S then
  begin
    LabelDate.Caption := S;
  end;

  TrayIcon.Hint := Application.Title + sLineBreak +
                   Format('%0:.4d-%1:.2d-%2:.2d (%3:s)' + sLineBreak + '%4:.2d:%5:.2d:%6:.2d',
                          [ST.wYear,ST.wMonth,ST.wDay,CDOW[ST.wDayOfWeek],ST.wHour,ST.wMinute,ST.wSecond]);

  DoShowBatteryStatus;
end;

procedure TFormWallClock.DoShowBatteryStatus;
var
  SPS: TSystemPowerStatus;
  Status: String;
begin
  if FBatteryUpdateCount < FBatteryUpdateInterval then
  begin
    FBatteryUpdateCount := FBatteryUpdateCount + 1;
    Exit;
  end;
  FBatteryUpdateCount := 0;

  FillChar(SPS,SizeOf(SPS),0);
  if GetSystemPowerStatus(SPS) = False then
  begin
    Exit;
  end;

  if (SPS.ACLineStatus = AC_LINE_ONLINE) and
     (SPS.BatteryLifePercent = BATTERY_PERCENTAGE_UNKNOWN) and
     (SPS.BatteryLifeTime = BATTERY_LIFE_UNKNOWN) then
  begin
    LabelBatteryStatus.Visible := False;
  end
  else
  begin
    LabelBatteryStatus.Visible := True;
    Status := '';
    if SPS.BatteryLifePercent <> BATTERY_PERCENTAGE_UNKNOWN then
    begin
      Status := Format('%d%%',[SPS.BatteryLifePercent]);
    end;
    if SPS.BatteryLifeTime <> BATTERY_LIFE_UNKNOWN then
    begin
      Status := Status + Format(' (%s)',[DecodeSecond(SPS.BatteryLifeTime)]);
    end
    else if SPS.ACLineStatus = AC_LINE_ONLINE then
    begin
      Status := Status + ' (AC)';
    end;
    LabelBatteryStatus.Caption := Status;
  end;
end;

class function TFormWallClock.DecodeSecond(Value: Integer): String;
var
  DividedValue: Word;
  Reminder: Word;
begin
  { Second (ignore) }
  DivMod(Value,SecsPerMin,DividedValue,Reminder);

  { Minute }
  DivMod(DividedValue,MinsPerHour,DividedValue,Reminder);
  Result := Format('%.2dm',[Reminder]);
  if DividedValue = 0 then
  begin
    Exit;
  end;

  { Hour }
  Result := Format('%dh',[DividedValue]) + Result;
end;

end.
