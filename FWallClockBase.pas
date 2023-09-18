unit FWallClockBase;

interface

uses
  Winapi.Windows, Winapi.Messages, Winapi.ShellAPI,
  System.SysUtils, System.Variants, System.Classes, System.Actions,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Menus, Vcl.ActnList;

type
  TFormWallClockBase = class(TForm)
    TimerFade: TTimer;
    TrayIcon: TTrayIcon;
    ActionList: TActionList;
    ActionExit: TAction;
    ActionReverseColors: TAction;
    ActionIgnoreFullScreen: TAction;
    PopupMenu: TPopupMenu;
    MenuItemMonitors: TMenuItem;
    MenuItemReverseColors: TMenuItem;
    MenuItemIgnoreFullScreen: TMenuItem;
    MenuItemExit: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure TimerUpdateTimer(Sender: TObject);
    procedure TimerFadeTimer(Sender: TObject);
    procedure TrayIconClick(Sender: TObject);
    procedure PopupMenuPopup(Sender: TObject);
    procedure ActionExitExecute(Sender: TObject);
    procedure ActionReverseColorsExecute(Sender: TObject);
    procedure ActionIgnoreFullScreenExecute(Sender: TObject);
  private
    const
      FadeOutDelta: Integer = -10;
      FadeInDelta: Integer = 20;
      MinAlphaBlendValue: Integer =  80;
      MaxAlphaBlendValue: Integer = 255;
  private
    FFadeDelta: Integer;
    FMonitorHandle: THandle;
    procedure DoClickMonitor(Sender: TObject);
    procedure AdjustPosition(AMonitorHandle: THandle);
    procedure AdjustZOrder;
    procedure BuildMonitorMenu;
    procedure RefreshMonitors;
  protected
    FInitialized: Boolean;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure Initialize; virtual;
    procedure AdjustColors(Highlight: Boolean); virtual; abstract;
    procedure ShowTime;
    procedure DoShowTime(ST: TSystemTime); virtual; abstract;
  public
    procedure WmDisplayChange(var Message: TWMDisplayChange); message WM_DISPLAYCHANGE;
  end;


implementation

{$R *.dfm}

procedure TFormWallClockBase.FormCreate(Sender: TObject);
begin
  FInitialized  := False;

  FMonitorHandle := INVALID_HANDLE_VALUE;
  ActionReverseColors.Checked := False;
  ActionIgnoreFullScreen.Checked := False;
end;

procedure TFormWallClockBase.FormShow(Sender: TObject);
begin
  if FInitialized = True then
  begin
    Exit;
  end;
  FInitialized := True;

  Initialize;

  ShowTime;
end;

procedure TFormWallClockBase.TimerUpdateTimer(Sender: TObject);
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
  if (Visible = FullScreenDetected) and
     ((ActionIgnoreFullScreen.Checked = False) or (Visible = False)) then
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

procedure TFormWallClockBase.TimerFadeTimer(Sender: TObject);
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

procedure TFormWallClockBase.TrayIconClick(Sender: TObject);
begin
  AdjustZOrder;
end;

procedure TFormWallClockBase.PopupMenuPopup(Sender: TObject);
begin
  BuildMonitorMenu;
  AdjustZOrder;
end;

procedure TFormWallClockBase.ActionExitExecute(Sender: TObject);
begin
  Close;
end;

procedure TFormWallClockBase.ActionReverseColorsExecute(Sender: TObject);
begin
  ActionReverseColors.Checked := not ActionReverseColors.Checked;
end;

procedure TFormWallClockBase.ActionIgnoreFullScreenExecute(Sender: TObject);
begin
  ActionIgnoreFullScreen.Checked := not ActionIgnoreFullScreen.Checked;
end;

procedure TFormWallClockBase.WmDisplayChange(var Message: TWMDisplayChange);
begin
  AdjustPosition(FMonitorHandle);
end;

procedure TFormWallClockBase.CreateParams(var Params: TCreateParams);
begin
  inherited;
  Params.ExStyle := (Params.ExStyle or WS_EX_TRANSPARENT or WS_EX_NOACTIVATE) and not WS_EX_APPWINDOW;
end;

procedure TFormWallClockBase.Initialize;
var
  Monitor: TMonitor;
begin
  Monitor := Screen.PrimaryMonitor;
  if Monitor <> nil then
  begin
    FMonitorHandle := Monitor.Handle;
  end;
  AdjustPosition(FMonitorHandle);
  AdjustColors(False);
end;

procedure TFormWallClockBase.ShowTime;
var
  ST: TSystemTime;
begin
  GetLocalTime(ST);
  DoShowTime(ST);
end;

procedure TFormWallClockBase.DoClickMonitor(Sender: TObject);
var
  MonitorIndex: Integer;
begin
  MonitorIndex := (Sender as TMenuItem).Tag;
  AdjustPosition(Screen.Monitors[MonitorIndex].Handle);
end;

procedure TFormWallClockBase.AdjustPosition(AMonitorHandle: THandle);
var
  I: Integer;
  Monitor: TMonitor;
  WorkAreaRect: TRect;
begin
  RefreshMonitors;

  Monitor := nil;
  for I := 0 to Screen.MonitorCount - 1 do
  begin
    if Screen.Monitors[I].Handle = AMonitorHandle then
    begin
      Monitor := Screen.Monitors[I];
      Break;
    end;
  end;

  if Monitor = nil then
  begin
    Monitor := Screen.PrimaryMonitor;
  end;

  if Monitor = nil then
  begin
    WorkAreaRect := Screen.WorkAreaRect;
    FMonitorHandle := INVALID_HANDLE_VALUE;
  end
  else
  begin
    WorkAreaRect := Monitor.WorkAreaRect;
    FMonitorHandle := Monitor.Handle;
  end;
  SetBounds(WorkAreaRect.Right - Width,WorkAreaRect.Top,Width,Height);
end;

procedure TFormWallClockBase.AdjustZOrder;
begin
  SetWindowPos(Handle,HWND_TOPMOST,0,0,0,0,SWP_NOMOVE or SWP_NOSIZE or SWP_NOACTIVATE or SWP_NOOWNERZORDER);
end;

procedure TFormWallClockBase.BuildMonitorMenu;
var
  I: Integer;
  MenuItem: TMenuItem;
begin
  RefreshMonitors;

  MenuItemMonitors.Clear;

  for I := 0 to Screen.MonitorCount - 1 do
  begin
    MenuItem := TMenuItem.Create(Self);
    MenuItem.Tag := I;

    MenuItem.Name := 'MenuItemMonitor' + IntToStr(Screen.Monitors[I].MonitorNum);
    MenuItem.Caption := 'Monitor ' + IntToStr(Screen.Monitors[I].MonitorNum + 1);
    if Screen.Monitors[I].Primary = True then
    begin
      MenuItem.Caption := MenuItem.Caption + ' (Primary)';
    end;
    MenuItem.OnClick := DoClickMonitor;
    if (FMonitorHandle = INVALID_HANDLE_VALUE) then
    begin
      if Screen.Monitors[I].Primary = True then
      begin
        MenuItem.Checked := True;
        FMonitorHandle := Screen.Monitors[I].Handle;
      end;
    end
    else
    begin
      if FMonitorHandle = Screen.Monitors[I].Handle then
      begin
        MenuItem.Checked := True;
      end;
    end;

    MenuItemMonitors.Add(MenuItem);
  end;
end;

procedure TFormWallClockBase.RefreshMonitors;
begin
  SendMessage(Application.Handle,WM_WTSSESSION_CHANGE,0,0);  // Force call Screen.GetMonitors. See https://quality.embarcadero.com/browse/RSP-37708
end;

end.
