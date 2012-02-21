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
	if Application.MessageBox('��Ҫ�����ʷ��¼��', '�ڰ���', MB_YESNO or MB_ICONQUESTION) = IDYES then
	begin
		Reg := TRegistry.Create;
		Reg.DeleteKey('\Software\WC\�ڰ���\��ʷ��¼');
		Reg.Free;
		ListView.Items.Clear
	end
end;

end.
