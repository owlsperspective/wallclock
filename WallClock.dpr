program WallClock;

uses
  Vcl.Forms,
  FWallClockBase in 'FWallClockBase.pas' {FormWallClockBase},
  FWallClock in 'FWallClock.pas' {FormWallClock};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'Wall clock';
  Application.CreateForm(TFormWallClock, FormWallClock);
  Application.Run;
end.
