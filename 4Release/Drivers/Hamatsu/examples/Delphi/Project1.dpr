program Project1;

uses
  Forms,
  Test in 'Test.pas' {Form1},
  RegTh in 'RegTh.pas';

{$R *.RES}

 begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
