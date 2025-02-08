object FormWallClockBase: TFormWallClockBase
  Left = 0
  Top = 0
  AlphaBlend = True
  BorderIcons = []
  BorderStyle = bsNone
  Caption = 'Wall clock'
  ClientHeight = 256
  ClientWidth = 256
  Color = clBtnFace
  TransparentColor = True
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  FormStyle = fsStayOnTop
  PopupMode = pmExplicit
  Position = poDesigned
  OnCreate = FormCreate
  OnShow = FormShow
  TextHeight = 15
  object TimerUpdate: TTimer
    Interval = 250
    OnTimer = TimerUpdateTimer
    Left = 8
    Top = 8
  end
  object TimerFade: TTimer
    Enabled = False
    Interval = 10
    OnTimer = TimerFadeTimer
    Left = 72
    Top = 8
  end
  object TrayIcon: TTrayIcon
    Hint = 'Hint'
    BalloonHint = 'BaloonHint'
    BalloonTitle = 'BaloonTitle'
    BalloonFlags = bfInfo
    PopupMenu = PopupMenu
    Visible = True
    OnClick = TrayIconClick
    Left = 8
    Top = 64
  end
  object ActionList: TActionList
    Left = 72
    Top = 64
    object ActionExit: TAction
      Caption = 'E&xit'
      OnExecute = ActionExitExecute
    end
    object ActionIgnoreFullScreen: TAction
      Caption = '&Ignore full screen'
      OnExecute = ActionIgnoreFullScreenExecute
    end
    object ActionRegisterRunAtLogin: TAction
      Caption = '&Register to registry'
      OnExecute = ActionRegisterRunAtLoginExecute
    end
    object ActionUnregisterRunAtLogin: TAction
      Caption = '&Unregister from registry'
      OnExecute = ActionUnregisterRunAtLoginExecute
    end
  end
  object PopupMenu: TPopupMenu
    OnPopup = PopupMenuPopup
    Left = 128
    Top = 64
    object MenuItemMonitors: TMenuItem
      Caption = '&Monitor'
    end
    object MenuItemIgnoreFullScreen: TMenuItem
      Action = ActionIgnoreFullScreen
    end
    object MenuItemRunAtLogin: TMenuItem
      Caption = 'Run at &Login'
      object MenuItemRegisterRunAtLogin: TMenuItem
        Action = ActionRegisterRunAtLogin
      end
      object MenuItemUnregisterRunAtLogin: TMenuItem
        Action = ActionUnregisterRunAtLogin
      end
    end
    object MenuItemExit: TMenuItem
      Action = ActionExit
    end
  end
end
