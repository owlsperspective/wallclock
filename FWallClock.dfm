object FormWallClock: TFormWallClock
  Left = 0
  Top = 0
  AlphaBlend = True
  BorderIcons = []
  BorderStyle = bsNone
  Caption = 'Wall clock'
  ClientHeight = 112
  ClientWidth = 224
  Color = clBtnFace
  TransparentColor = True
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -48
  Font.Name = 'Calibri'
  Font.Style = []
  FormStyle = fsStayOnTop
  PopupMode = pmExplicit
  Position = poDesigned
  OnCreate = FormCreate
  OnShow = FormShow
  TextHeight = 59
  object Label1: TSkLabel
    Left = 16
    Top = 8
    Width = 25
    Height = 65
    AutoSize = False
    TextSettings.Decorations.StrokeColor = claWhite
    TextSettings.Decorations.Thickness = 0.500000000000000000
    TextSettings.Font.Families = 'Calibri'
    TextSettings.Font.Size = 48.000000000000000000
    TextSettings.Font.Weight = Semibold
    TextSettings.FontColor = claWhite
    TextSettings.HorzAlign = Center
    TextSettings.Trimming = None
    Words = <
      item
        Caption = '0'
        StyledSettings = [Family, Size, Style, FontColor, Other]
      end>
  end
  object Label2: TSkLabel
    Left = 40
    Top = 8
    Width = 25
    Height = 65
    AutoSize = False
    TextSettings.Decorations.StrokeColor = claWhite
    TextSettings.Decorations.Thickness = 0.500000000000000000
    TextSettings.Font.Families = 'Calibri'
    TextSettings.Font.Size = 48.000000000000000000
    TextSettings.Font.Weight = Semibold
    TextSettings.FontColor = claWhite
    TextSettings.HorzAlign = Center
    TextSettings.Trimming = None
    Words = <
      item
        Caption = '0'
        StyledSettings = [Family, Size, Style, FontColor, Other]
      end>
  end
  object Label3: TSkLabel
    Left = 64
    Top = 8
    Width = 25
    Height = 65
    AutoSize = False
    TextSettings.Decorations.StrokeColor = claWhite
    TextSettings.Decorations.Thickness = 0.500000000000000000
    TextSettings.Font.Families = 'Calibri'
    TextSettings.Font.Size = 48.000000000000000000
    TextSettings.Font.Weight = Semibold
    TextSettings.FontColor = claWhite
    TextSettings.HorzAlign = Center
    TextSettings.Trimming = None
    Words = <
      item
        Caption = ':'
        StyledSettings = [Family, Size, Style, FontColor, Other]
      end>
  end
  object Label4: TSkLabel
    Left = 88
    Top = 8
    Width = 25
    Height = 65
    AutoSize = False
    TextSettings.Decorations.StrokeColor = claWhite
    TextSettings.Decorations.Thickness = 0.500000000000000000
    TextSettings.Font.Families = 'Calibri'
    TextSettings.Font.Size = 48.000000000000000000
    TextSettings.Font.Weight = Semibold
    TextSettings.FontColor = claWhite
    TextSettings.HorzAlign = Center
    TextSettings.Trimming = None
    Words = <
      item
        Caption = '0'
        StyledSettings = [Family, Size, Style, FontColor, Other]
      end>
  end
  object Label5: TSkLabel
    Left = 112
    Top = 8
    Width = 25
    Height = 65
    AutoSize = False
    TextSettings.Decorations.StrokeColor = claWhite
    TextSettings.Decorations.Thickness = 0.500000000000000000
    TextSettings.Font.Families = 'Calibri'
    TextSettings.Font.Size = 48.000000000000000000
    TextSettings.Font.Weight = Semibold
    TextSettings.FontColor = claWhite
    TextSettings.HorzAlign = Center
    TextSettings.Trimming = None
    Words = <
      item
        Caption = '0'
        StyledSettings = [Family, Size, Style, FontColor, Other]
      end>
  end
  object Label6: TSkLabel
    Left = 136
    Top = 8
    Width = 25
    Height = 65
    AutoSize = False
    TextSettings.Decorations.StrokeColor = claWhite
    TextSettings.Decorations.Thickness = 0.500000000000000000
    TextSettings.Font.Families = 'Calibri'
    TextSettings.Font.Size = 48.000000000000000000
    TextSettings.Font.Weight = Semibold
    TextSettings.FontColor = claWhite
    TextSettings.HorzAlign = Center
    TextSettings.Trimming = None
    Words = <
      item
        Caption = ':'
        StyledSettings = [Family, Size, Style, FontColor, Other]
      end>
  end
  object Label7: TSkLabel
    Left = 160
    Top = 8
    Width = 25
    Height = 65
    AutoSize = False
    TextSettings.Decorations.StrokeColor = claWhite
    TextSettings.Decorations.Thickness = 0.500000000000000000
    TextSettings.Font.Families = 'Calibri'
    TextSettings.Font.Size = 48.000000000000000000
    TextSettings.Font.Weight = Semibold
    TextSettings.FontColor = claWhite
    TextSettings.HorzAlign = Center
    TextSettings.Trimming = None
    Words = <
      item
        Caption = '0'
        StyledSettings = [Family, Size, Style, FontColor, Other]
      end>
  end
  object Label8: TSkLabel
    Left = 184
    Top = 8
    Width = 25
    Height = 65
    AutoSize = False
    TextSettings.Decorations.StrokeColor = claWhite
    TextSettings.Decorations.Thickness = 0.500000000000000000
    TextSettings.Font.Families = 'Calibri'
    TextSettings.Font.Size = 48.000000000000000000
    TextSettings.Font.Weight = Semibold
    TextSettings.FontColor = claWhite
    TextSettings.HorzAlign = Center
    TextSettings.Trimming = None
    Words = <
      item
        Caption = '0'
        StyledSettings = [Family, Size, Style, FontColor, Other]
      end>
  end
  object LabelDate: TSkLabel
    Left = 16
    Top = 72
    Width = 192
    Height = 32
    AutoSize = False
    TextSettings.Decorations.StrokeColor = claWhite
    TextSettings.Decorations.Thickness = 0.500000000000000000
    TextSettings.Font.Families = 'Calibri'
    TextSettings.Font.Size = 24.000000000000000000
    TextSettings.Font.Weight = Semibold
    TextSettings.FontColor = claWhite
    TextSettings.HorzAlign = Trailing
    TextSettings.Trimming = None
    Words = <
      item
        Caption = '9999-99-99 (XXX)'
        StyledSettings = [Family, Size, Style, FontColor, Other]
      end>
  end
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
