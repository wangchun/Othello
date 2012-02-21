unit About;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
	Buttons, ExtCtrls;

type
	TAboutBox = class(TForm)
		BitBtnOK: TBitBtn;
		ImageProgramIcon: TImage;
		LabelComments: TLabel;
		LabelCopyright: TLabel;
		LabelProductName: TLabel;
		LabelVersion: TLabel;
		Panel: TPanel;
	private
		{ Private declarations }
	public
		{ Public declarations }
	end;

var
	AboutBox: TAboutBox;

implementation

{$R *.DFM}


end.

