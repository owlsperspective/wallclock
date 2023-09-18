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
      Caption = #32066#20102'(&X)'
      OnExecute = ActionExitExecute
    end
    object ActionReverseColors: TAction
      Caption = #33394#12434#21453#36578'(&R)'
      OnExecute = ActionReverseColorsExecute
    end
    object ActionIgnoreFullScreen: TAction
      Caption = #12501#12523#12473#12463#12522#12540#12531#12434#28961#35222'(&I)'
      OnExecute = ActionIgnoreFullScreenExecute
    end
  end
  object PopupMenu: TPopupMenu
    OnPopup = PopupMenuPopup
    Left = 128
    Top = 64
    object MenuItemMonitors: TMenuItem
      Caption = #12514#12491#12479'(&M)'
    end
    object MenuItemReverseColors: TMenuItem
      Action = ActionReverseColors
    end
    object MenuItemIgnoreFullScreen: TMenuItem
      Action = ActionIgnoreFullScreen
    end
    object MenuItemExit: TMenuItem
      Action = ActionExit
    end
  end
end
