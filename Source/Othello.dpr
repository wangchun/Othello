program Othello;

uses
  Forms,
  Main in 'Main.pas' {MainForm},
  About in 'About.pas' {AboutBox},
  Option in 'Option.pas' {OptionBox},
  History in 'History.pas' {HistoryBox},
  Search in 'Search.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'ºÚ°×Æå';
  Application.HelpFile := 'Othello.hlp';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
