unit History;

interface

uses
	Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
	ComCtrls, StdCtrls, Buttons;

type
	THistoryBox = class(TForm)
		BitBtnClear: TBitBtn;
		BitBtnOK: TBitBtn;
		ListView: TListView;
		procedure BitBtnClearClick(Sender: TObject);
	private
		{ Private declarations }
	public
		{ Public declarations }
	end;

var
	HistoryBox: THistoryBox;

implementation

{$R *.DFM}

uses
	Registry;

procedure THistoryBox.BitBtnClearClick(Sender: TObject);
var
	Reg: TRegistry;
begin
	if Application.MessageBox('真要清除历史记录吗？', '黑白棋', MB_YESNO or MB_ICONQUESTION) = IDYES then
	begin
		Reg := TRegistry.Create;
		Reg.DeleteKey('\Software\WC\黑白棋\历史记录');
		Reg.Free;
		ListView.Items.Clear
	end
end;

end.
